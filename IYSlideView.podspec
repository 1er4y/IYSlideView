#
# Be sure to run `pod lib lint IYSlideView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IYSlideView'
  s.version          = '0.1.2'
  s.summary          = 'Expandable UIView with AutoLayout. Expanding from different positions and in different directions.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
	Subclass of UIViev class that allows the user to open and close the View with the gestures in different directions. Offers four directions gestures: from top to bottom, bottom to top, right to left, left to right. After opening at full size, shows your specified UIViewController as child in container (Just like Container View in Storyboard). Fully supports the Auto layout. Simple installation in 3 steps. Very nice and flexibly customizable animation of opening and closing.
                       DESC

  s.homepage         = 'https://github.com/1er4y/IYSlideView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ilnur Yagudin' => '1er4yy@gmail.com' }
  s.source           = { :git => 'https://github.com/1er4y/IYSlideView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/rem1x_69'

  s.ios.deployment_target = '9.1'

  s.source_files = 'IYSlideView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'IYSlideView' => ['IYSlideView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
	s.frameworks = 'UIKit', 'Foundation'
end
