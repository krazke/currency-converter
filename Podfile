platform :ios, '14.0'

use_frameworks!
inhibit_all_warnings!

def ui_pods
  pod 'SnapKit'
end

def utility_pods
  pod 'Swinject'
  pod 'Moya'
  pod 'RealmSwift', '~>10'
end

target 'currency-converter' do
  ui_pods
  utility_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings["ONLY_ACTIVE_ARCH"] = "YES"
    end
    
    # Fix Xcode 14 bundle code signing issue
    if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
      target.build_configurations.each do |config|
          config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end