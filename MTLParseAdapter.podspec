Pod::Spec.new do |s|
  s.name             = "MTLParseAdapter"
  s.version          = "0.1.0"
  s.summary          = "Easily convert your objects to and from Parse PFObjects"
  s.description      = <<-DESC
                        This library provides an interface to convert
                        objects that conform to MTLJSONSerializing to and
                        from PFObjects provided by the Parse SDK.
                       DESC
  s.homepage         = "https://github.com/lazerwalker/MTLParseAdapter"
  s.license          = 'MIT'
  s.author           = { "Mike Walker" => "michael@lazerwalker.com" }
  s.source           = { :git => "https://github.com/lazerwalker/MTLParseAdapter.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MTLParseAdapter' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'Asterism', '~> 1.0'
  s.dependency 'Mantle', '~> 1.5'
  s.dependency 'Parse', '~> 1.6'
end
