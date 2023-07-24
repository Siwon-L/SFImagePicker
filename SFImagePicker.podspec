#
# Be sure to run `pod lib lint SFImagePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SFImagePicker'
  s.version          = '0.3.0'
  s.summary          = 'SFImagePicker is a multi-select imagePicker library that uses photoKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'SFImagePicker is a multi-select imagePicker library using photoKit. Get the image via delegate or closure.'

  s.homepage         = 'https://github.com/saafaaari/SFImagePicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'saafaaari' => '111dltldnjs@gmail.com' }
  s.source           = { :git => 'https://github.com/saafaaari/SFImagePicker.git', :tag => s.version.to_s }
  
  s.swift_versions = '5.0'
  s.ios.deployment_target = '14.0'
  s.source_files = 'SFImagePicker/Classes/**/*'
  s.frameworks = 'UIKit'
end
