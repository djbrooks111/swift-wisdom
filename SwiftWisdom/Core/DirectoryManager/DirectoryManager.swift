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
        guard let path = directoryUrl.path else { return [] }
        let all = try? fileManager.subpathsOfDirectory(atPath: path)
        return all ?? []
    }
    
    // MARK: Initializer
    
    public init(directoryName: String, fileManager: FileManager = FileManager.default) {
        self.directoryName = directoryName
        self.fileManager = fileManager
        // Should fail if not available
        self.directoryUrl = try! fileManager.directoryPathWithName(directoryName)
    }
    
    // MARK: Move
    
    public func moveFileIntoDirectory(originUrl: URL, targetName: String) throws {
        let filePath = directoryUrl.appendingPathComponent(targetName)
        guard let originPath = originUrl.path, let targetPath = filePath.path else { return }
        if fileManager.fileExists(atPath: targetPath) {
            try deleteFileWithName(targetName)
        }
        try fileManager.moveItem(atPath: originPath, toPath: targetPath)
    }
    
    // MARK: Write
    
    public func writeData(_ data: Data, withName name: String = UUID().uuidString) -> Bool {
        let filePath = directoryUrl.appendingPathComponent(name)
        guard let path = filePath.path else { return false }
        return ((try? data.write(to: URL(fileURLWithPath: path), options: [.dataWritingAtomic])) != nil)
    }
    
    public func writeDataInBackground(_ data: Data, withName name: String = UUID().uuidString, completion: (_ fileName: String, _ success: Bool) -> Void = { _ in }) {
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
        guard let path = fileUrl.path else {
            throw Error.unableToCreatePath(url: fileUrl)
        }
        try fileManager.removeItem(atPath: path)
    }
    
    // MARK: Fetch
    
    public func fetchFileWithName(_ fileName: String) -> Data? {
        let filePath = directoryUrl.appendingPathComponent(fileName)
        guard let path = filePath.path else { return nil }
        return (try? Data(contentsOf: URL(fileURLWithPath: path)))
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
        guard let path = directoryPath.path else { throw DirectoryManager.Error.unableToCreatePath(url: directoryPath) }
        guard !fileExists(atPath: path) else { return }
        try createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
    }
}
