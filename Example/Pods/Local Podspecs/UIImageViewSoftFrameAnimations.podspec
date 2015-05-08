#
# Be sure to run `pod lib lint UIImageViewSoftFrameAnimations.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "UIImageViewSoftFrameAnimations"
  s.version          = "1.0"
  s.summary          = "A powerfull UIImageView extension to play frame animations"
  s.description      = <<-DESC
Powerfull UIImageView extension to play frame animations without loading all the uiimage in memory.
                       DESC
  s.homepage         = "https://github.com/AlbertMontserrat/UIImageViewSoftFrameAnimations"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Albert Montserrat" => "albert.montserrat.gambus@gmail.com" }
  s.source           = { :git => "https://github.com/AlbertMontserrat/UIImageViewSoftFrameAnimations.git", :tag => s.version.to_s }

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'UIImageViewSoftFrameAnimations' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
