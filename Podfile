source 'https://github.com/CocoaPods/Specs'

platform :ios, '8.0'

use_frameworks!

def commonpods
  pod 'IP-UIKit-Wisdom'
  pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift.git', :branch => "swift-3.0"
  pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift.git', :branch => "swift-3.0"
end

target 'SwiftWisdom' do
  commonpods()
end

target 'SwiftWisdomTests' do
  commonpods()
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.11'
    end
  end
end
