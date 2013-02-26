# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paperclip_async/version'

Gem::Specification.new do |spec|
  spec.name          = "paperclip_async"
  spec.version       = PaperclipAsync::VERSION
  spec.authors       = ["Yuri Barbashov"]
  spec.email         = ["lolcoltd@gmail.com"]
  spec.description   = %q{Async processing of paperclip thumbnails}
  spec.summary       = %q{Async processing of paperclip thumbnails}
  spec.homepage      = "https://github.com/playa/paperclip_async"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
