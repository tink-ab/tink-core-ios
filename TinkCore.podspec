Pod::Spec.new do |spec|
  spec.name         = "TinkCore"
  spec.summary      = "Tink Core iOS SDK"
  spec.description  = <<-DESC
                    Core library for Tink SDKs.
                    DESC
  spec.version      = "2.4.0"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.authors      = { "Tink AB" => "mobile@tink.se" }
  spec.homepage     = "https://github.com/tink-ab/tink-core-ios"
  spec.source       = { :git => "https://github.com/tink-ab/tink-core-ios.git", :tag => spec.version }

  spec.platform     = :ios, "13.0"
  spec.swift_version = ["5.1", "5.2", "5.3", "5.4", "5.5", "5.6", "5.7", "5.8"]

  spec.vendored_frameworks = 'TinkCore.xcframework'
end
