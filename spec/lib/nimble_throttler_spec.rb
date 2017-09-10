require "spec_helper"

RSpec.describe NimbleThrottler do
  let(:request1) {
    Rack::Request.new(
      Rack::MockRequest.env_for("http://example.com/home", "REMOTE_ADDR" => "1.2.3.4")
    )
  }

  let(:request2) {
    Rack::Request.new(
      Rack::MockRequest.env_for("http://example.com/testing", "REMOTE_ADDR" => "1.2.3.4")
    )
  }

  before do
    NimbleThrottler.configure do
      throttle "/testing", limit: 10, period: 3600
      throttle "/home", limit: 20, period: 7200
    end
  end

  describe '#configure' do
    it 'add throttle endpoints' do
      expect(NimbleThrottler.endpoints).to include("/testing")
      expect(NimbleThrottler.instance.data["/testing"][:limit]).to eq(10)
      expect(NimbleThrottler.instance.data["/testing"][:period]).to eq(3600)

      expect(NimbleThrottler.endpoints).to include("/home")
      expect(NimbleThrottler.instance.data["/home"][:limit]).to eq(20)
      expect(NimbleThrottler.instance.data["/home"][:period]).to eq(7200)
    end
  end

  describe '#throttle_for' do
    it "throttle the endpoind" do
      NimbleThrottler.throttle_for(request1)
      key, = NimbleThrottler.key_and_expires_in(request1)

      expect(NimbleThrottler.instance.cache_store.read(key)).to eq(1)

      4.times { NimbleThrottler.throttle_for(request1) }

      expect(NimbleThrottler.instance.cache_store.read(key)).to eq(5)
    end
  end

  describe '#exceed_limit?' do
    it "return true when exceed the limit" do
      21.times { NimbleThrottler.throttle_for(request2) }

      expect(NimbleThrottler.exceed_limit?(request2)).to eq(true)
    end
  end
end
