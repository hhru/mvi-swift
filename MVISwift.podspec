Pod::Spec.new do |spec|
  spec.name = "MVISwift"
  spec.version = "1.0.1"
  spec.summary = "MVISwift is a modern, Swift-based MVI framework with Combine"

  spec.homepage = "https://github.com/hhru/mvi-swift"
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { "Alex Tsybulko" => "working.tsybulko@gmail.com" }
  spec.source = { :git => "https://github.com/hhru/mvi-swift.git", :tag => "#{spec.version}" }

  spec.swift_version = '5.7'
  spec.requires_arc = true
  spec.source_files = 'Sources/**/*.swift'

  spec.ios.frameworks = 'Combine'
  spec.ios.deployment_target = "13.0"

  spec.tvos.frameworks = 'Combine'
  spec.tvos.deployment_target = "13.0"

  # https://github.com/CocoaPods/CocoaPods/issues/11547#issuecomment-1350518586
  spec.user_target_xcconfig = { 'GENERATE_INFOPLIST_FILE' => 'YES' }
end
