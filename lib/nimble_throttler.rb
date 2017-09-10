require 'singleton'
require 'rack'
require 'active_support'

class NimbleThrottler
  include Singleton

  attr_accessor :data, :cache_store
  attr_reader :default_period, :default_limit

  def initialize
    @data = {}
    @cache_store = ActiveSupport::Cache::MemoryStore.new
    @default_period = 1.hours
    @default_limit = 100
  end

  def add(key, value)
    @data[key] = value
  end

  class << self
    def configure(&block)
      class_eval(&block) if block_given?
    end

    def throttle(endpoint, opts)
      instance.add(endpoint, opts)
    end

    def endpoints
      instance.data.keys
    end

    def throttle_for(req)
      key, expires_in = key_and_expires_in(req)
      result = instance.cache_store.increment(key, 1, expires_in: expires_in)
      instance.cache_store.write(key, 1, expires_in: expires_in) if result.nil?
      result || 1
    end

    def exceed_limit?(req)
      key, = key_and_expires_in(req)
      count = instance.cache_store.read(key).to_i
      count > instance.data[req.path][:limit].to_i
    end

    def expires_in(req)
      _, expires_in = key_and_expires_in(req)
      expires_in
    end

    def key_and_expires_in(req)
      period = (instance.data[req.path][:period] || instance.default_period).to_i
      epoch_time = Time.current.to_i
      expires_in = (period - (epoch_time % period) + 1)
      key = "req/ip:#{req.ip}:#{(epoch_time / period)}"
      [key, expires_in]
    end
  end
end
