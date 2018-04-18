Pod::Spec.new do |s|
  s.name             = 'CustomPresenter'
  s.version          = '0.3.0'
  s.summary          = 'Custom view controller transitioning implementation'
  s.description      = <<-DESC
CustomPresenter provides a straighforward implementation of custom view controller transitioning for presentation and dismissal. It provides control over timing, background and metrics of presented view controller.
                       DESC
  s.homepage         = 'https://github.com/azubala/CustomPresenter'  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'azubala' => 'alek@zubala.com' }
  s.source           = { :git => 'https://github.com/azubala/CustomPresenter.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alekzubala'

  s.ios.deployment_target = '8.0'
  s.source_files = 'CustomPresenter/Classes/**/*'  
  s.swift_version = "4.0"
end
