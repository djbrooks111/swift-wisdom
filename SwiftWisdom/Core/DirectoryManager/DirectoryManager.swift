//
//  DirectoryManager.swift
//  bmap
//
//  Created by Logan Wright on 12/2/15.
//  Copyright © 2015 Intrepid. All rights reserved.
//

import Foundation

public final class DirectoryManager {
    
    enum Error : Error {
        case unableToCreatePath(url: URL)
    }
    
    private let directoryName: String
    private let fileManager: FileManager
    private let directoryUrl: URL
    
    // MARK: All Files
    
    public var allFilesInDirectory: [String] {
        let all = try? fileManager.subpathsOfDirectory(atPath: directoryUrl.path)
        return all ?? []
    }
    
    // MARK: Initializer
    
    public init(directoryName: String, fileManager: FileManager = FileManager.default) {
        self.directoryName = directoryName
        self.fileManager = fileManager
        // Should fail if not available
        // fileManager.path
        self.directoryUrl = try! fileManager.directoryPathWithName(directoryName)
    }
    
    // MARK: Move
    
    public func moveFileIntoDirectory(originUrl: URL, targetName: String) throws {
        let filePath = directoryUrl.appendingPathComponent(targetName)
        if fileManager.fileExists(atPath: filePath.path) {
            try deleteFileWithName(targetName)
        }
        try fileManager.moveItem(atPath: originUrl.path, toPath: filePath.path)
    }
    
    // MARK: Write
    
    public func writeData(_ data: Data, withName name: String = UUID().uuidString) -> Bool {
        let filePath = directoryUrl.appendingPathComponent(name)
        return ((try? data.write(to: URL(fileURLWithPath: filePath.path), options: [.atomicWrite])) != nil)
    }
    
    public func writeDataInBackground(_ data: Data, withName name: String = UUID().uuidString, completion: @escaping (_ fileName: String, _ success: Bool) -> Void = { _ in }) {
        Background {
            let success = self.writeData(data, withName: name)
            Main {
                completion(name, success)
            }
        }
    }
    
    // MARK: Delete
    
    public func deleteFileWithName(_ fileName: String) throws {
        let fileUrl = directoryUrl.appendingPathComponent(fileName)
        try fileManager.removeItem(atPath: fileUrl.path)
    }
    
    // MARK: Fetch
    
    public func fetchFileWithName(_ fileName: String) -> Data? {
        let filePath = directoryUrl.appendingPathComponent(fileName)
        return (try? Data(contentsOf: URL(fileURLWithPath: filePath.path)))
    }
}

extension FileManager {
    private func directoryPathWithName(_ directoryName: String) throws -> URL {
        let pathsArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard let pathString = pathsArray.first, let documentsDirectoryPath = URL(string: pathString) else { fatalError("Unable to create directory") }
        let directoryPath = documentsDirectoryPath.appendingPathComponent(directoryName)
        try createDirectoryIfNecessary(directoryPath)
        return directoryPath
    }
    
    private func createDirectoryIfNecessary(_ directoryPath: URL) throws {
        guard !fileExists(atPath: directoryPath.path) else { return }
        try createDirectory(atPath: directoryPath.path, withIntermediateDirectories: false, attributes: nil)
    }
}
