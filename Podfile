source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!
use_frameworks!
platform :ios, '10.0'

def test_pods
  pod 'Quick'
  pod 'Nimble'
end

target 'TimerCoreTests' do
  test_pods
end

target 'ModuleIntegrationTests' do
	test_pods
	pod 'TimerCore', :path => './'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.2'
        end
    end
end
