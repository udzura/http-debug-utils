# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'http-debug-utils/version'

Gem::Specification.new do |spec|
  spec.name          = "http-debug-utils"
  spec.version       = HttpDebugUtils::VERSION
  spec.authors       = ["Uchio KONDO"]
  spec.email         = ["udzura@udzura.jp"]
  spec.description   = %q{HTTP Debugging toolz!!}
  spec.summary       = <<-EOD
HTTP Debugging toolz!!

Commands:
    * http-request-dumper.rb : Catches all and dumps HTTP Request
    * request-cloner.rb      : Cloning HTTP requests to some backends
  EOD
  spec.homepage      = "https://github.com/udzura/http-debug-utils"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "kage"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
