# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "nimble_throttler"
  spec.version       = "0.0.1"
  spec.authors       = ["Long Nguyen"]
  spec.email         = ["long.polyglot@gmail.com"]

  spec.summary       = "Simple throttler"
  spec.description   = "Simple throttler that base on the IP address"
  spec.homepage      = "https://github.com/kimquy/scratch_rate_limitter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rack"
  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'rubocop'
end
