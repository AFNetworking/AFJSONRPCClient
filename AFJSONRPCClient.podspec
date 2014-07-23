Pod::Spec.new do |s|
  s.name = 'AFJSONRPCClient'
  s.version = '2.1.1'
  s.homepage = 'https://github.com/AFNetworking/AFJSONRPCClient'
  s.social_media_url = "https://twitter.com/AFNetworking"
  s.authors = { 'wiistriker' => 'wiistriker@gmail.com', 'Mattt Thompson' => 'm@mattt.me' }
  s.license = 'MIT'
  s.summary = 'A JSON-RPC client build on AFNetworking.'
  s.source = { :git => 'https://github.com/AFNetworking/AFJSONRPCClient.git',
               :tag => '2.1.1' }
  s.source_files = 'AFJSONRPCClient'
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.dependency 'AFNetworking', '~> 2.1'
end
