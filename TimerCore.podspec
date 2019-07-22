Pod::Spec.new do |s|
  s.name = "TimerCore"
  s.version = "1.0.0"
  s.summary = "Micro Feature"
  s.description = <<-DESC
                  TimerCore is resposible for ...
                  DESC
  s.homepage = "http://db-in"
  s.documentation_url = "https://db-in.github.io/TimerCore/"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = 'db-in'
  s.source = { :git => "https://github.com/dineybomfim/TimmerCore.git", :tag => s.version, :submodules => true }
  s.swift_version = '4.1'

  s.requires_arc = true
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.public_header_files = 'TimerCore/**/*.h'
  s.source_files = 'TimerCore/**/*.{h,m,swift}'
  s.exclude_files = 'TimerCore/**/Info.plist'

  s.ios.frameworks = 'Foundation'

end
