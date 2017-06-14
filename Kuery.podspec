Pod::Spec.new do |s|
  s.name             = 'Kuery'
  s.version          = '0.2.0'
  s.summary          = "A type-safe Core Data query API using Swift 4's Smart KeyPaths."
  s.description      = <<-DESC
                         Kuery, a type-safe Core Data query API using Swift 4's Smart KeyPaths.
                       DESC
  s.homepage         = 'https://github.com/kishikawakatsumi/Kuery'
  s.source_files     = 'Sources/Kuery/*.swift'
  s.pod_target_xcconfig = { 'SWIFT_WHOLE_MODULE_OPTIMIZATION' => 'YES', 'APPLICATION_EXTENSION_API_ONLY' => 'YES' }
  s.frameworks = 'Foundation', 'CoreData'
  s.source           = { :git => 'https://github.com/kishikawakatsumi/Kuery.git', :tag => "v#{s.version}" }
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kishikawa Katsumi' => 'kishikawakatsumi@mac.com' }
  s.social_media_url = 'https://twitter.com/k_katsumi'
  s.ios.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'
  s.tvos.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
end
