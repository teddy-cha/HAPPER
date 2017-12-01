# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'


use_frameworks!

target 'Happer' do
    pod 'WSTagsField'
    pod 'FSCalendar'
    pod 'RealmSwift'
    pod "SwiftSpinner"
    pod 'Zip', '~> 0.7'
    pod 'SwiftyDropbox'
    pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift3'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
