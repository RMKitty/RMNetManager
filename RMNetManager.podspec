#
#  Be sure to run `pod spec lint RMNetManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|


  spec.name         = "RMNetManager"
  spec.version      = "0.0.2"
  spec.summary      = "A simple wrapper Alamofire for HTTP/HTTPs post and get."

  spec.description  = <<-DESC
						RMNetManager is a simple wrapper of Alamofire only with POST and GET.
                   DESC

  spec.homepage     = "https://github.com/RMKitty/RMNetManager"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  # spec.license      = "MIT"
  spec.license      = { :type => "MIT", :file => "LICENSE" }


  spec.author             = { "R_M_" => "RMKitty@163.com" }
  # Or just: spec.author    = "R_M_"
  # spec.authors            = { "R_M_" => "RMKitty@163.com" }
  # spec.social_media_url   = "https://twitter.com/R_M_"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #
  spec.swift_version = "4.2"
  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

  #  When using multiple platforms
   spec.ios.deployment_target = "9.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/RMKitty/RMNetManager.git", :tag => "#{spec.version}" }


  spec.source_files  = "RMNetManager/*.swift"
  # spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
   spec.dependency "Alamofire", "~> 4.7.3"

end
