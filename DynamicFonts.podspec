require 'json'
package = JSON.parse(File.read(File.join(__dir__, './', 'package.json')))

Pod::Spec.new do |s|
  s.name                   = "DynamicFonts"

  s.version                = package['version']
  s.homepage               = package['url']
  s.summary                = package['description']
  s.license                = package['license']
  s.author                 = package['author']
  s.source                 = { :git => package['repository']['url'] }

  s.ios.deployment_target  = '9.0'
  s.tvos.deployment_target = '9.2'
  s.source_files           = 'DynamicFonts.{h,m}'
  s.frameworks             = 'Foundation', 'UIKit', 'CoreText'
  s.dependency 'React-Core'
end
