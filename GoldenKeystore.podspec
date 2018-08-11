Pod::Spec.new do |s|
  s.name             = 'GoldenKeystore'
  s.version          = '1.0.3'
  s.summary          = 'A Swift library for generating BIP32, BIP39 key pairs'

  s.homepage         = 'https://github.com/goldennetwork/GoldenKeystore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Viettranx' => 'viettranx@gmail.com' }
  s.source           = { :git => 'https://github.com/goldennetwork/GoldenKeystore.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'
  s.swift_version = '4.1'
  s.source_files = '*.swift'
  s.dependency 'TrezorCrypto', '0.0.6'
end
