source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

abstract_target 'DribbbleCommon' do

plugin 'cocoapods-keys', {
    :project => "Dribbble",
    :keys => [
      "DribbbleClientID",
      "DribbbleClientSecret",
      "DribbbleClientAccessToken"
    ]}
  
  pod 'RealmSwift'
  pod 'RxBlocking'
  pod 'RxCocoa'
  pod 'RxSwift'
  pod 'Moya/RxSwift'
  pod 'ObjectMapper'
  pod 'ReachabilitySwift'
  pod 'RxDataSources'

  target 'Dribbble' do

    # UI
    pod 'UIColor_Hex_Swift'
    pod 'PopupDialog'
    pod 'CryptoSwift'
    pod 'Kingfisher'
    pod 'Font-Awesome-Swift'
    
    # Helpers
    pod 'SwiftyUserDefaults'
    pod 'SwiftMessages'
    pod 'SwiftDate'
    pod 'OAuthSwift'

  end
  
  target 'DribbbleTests' do
    
    pod 'Quick'
    pod 'Nimble'

  end

   post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
  
end
