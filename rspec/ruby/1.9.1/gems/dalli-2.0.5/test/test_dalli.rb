require 'helper'
require 'memcached_mock'

describe 'Dalli' do
  describe 'options parsing' do
    should 'handle deprecated options' do
      dc = Dalli::Client.new('foo', :compression => true)
      assert dc.instance_variable_get(:@options)[:compress]
      refute dc.instance_variable_get(:@options)[:compression]
    end

    should 'not warn about valid options' do
      dc = Dalli::Client.new('foo', :compress => true)
      # Rails.logger.expects :warn
      assert dc.instance_variable_get(:@options)[:compress]
    end
  end

  describe 'key validation' do
    should 'not allow blanks' do
      dc = Dalli::Client.new
      dc.set '   ', 1
      assert_equal 1, dc.get('   ')
      dc.set "\t", 1
      assert_equal 1, dc.get("\t")
      dc.set "\n", 1
      assert_equal 1, dc.get("\n")
      assert_raises ArgumentError do
        dc.set "", 1
      end
      assert_raises ArgumentError do
        dc.set nil, 1
      end
    end
  end

  should "default to localhost:11211" do
    dc = Dalli::Client.new
    ring = dc.send(:ring)
    s1 = ring.servers.first.hostname
    assert_equal 1, ring.servers.size
    dc.close

    dc = Dalli::Client.new('localhost:11211')
    ring = dc.send(:ring)
    s2 = ring.servers.first.hostname
    assert_equal 1, ring.servers.size
    dc.close

    dc = Dalli::Client.new(['localhost:11211'])
    ring = dc.send(:ring)
    s3 = ring.servers.first.hostname
    assert_equal 1, ring.servers.size
    dc.close

    assert_equal '127.0.0.1', s1
    assert_equal s2, s3
  end

  context 'using a live server' do

    should "support get/set" do
      memcached do |dc|
        dc.flush

        val1 = "1234567890"*105000
        assert_error Dalli::DalliError, /too large/ do
          dc.set('a', val1)
          val2 = dc.get('a')
          assert_equal val1, val2
        end

        val1 = "1234567890"*100000
        dc.set('a', val1)
        val2 = dc.get('a')
        assert_equal val1, val2

        assert_equal true, dc.set('a', nil)
        assert_nil dc.get('a')
      end
    end

    should "support stats" do
      memcached do |dc|
        # make sure that get_hits would not equal 0
        dc.get(:a)

        stats = dc.stats
        servers = stats.keys
        assert(servers.any? do |s|
          stats[s]["get_hits"].to_i != 0
        end)

        # reset_stats test
        results = dc.reset_stats
        assert(results.all? { |x| x })
        stats = dc.stats
        servers = stats.keys

        # check if reset was performed
        servers.each do |s|
          assert_equal 0, dc.stats[s]["get_hits"].to_i
        end
      end
    end

    should "support the fetch operation" do
      memcached do |dc|
        dc.flush

        expected = { 'blah' => 'blerg!' }
        executed = false
        value = dc.fetch('fetch_key') do
          executed = true
          expected
        end
        assert_equal expected, value
        assert_equal true, executed

        executed = false
        value = dc.fetch('fetch_key') do
          executed = true
          expected
        end
        assert_equal expected, value
        assert_equal false, executed
      end
    end

    should "support the fetch operation with falsey values" do
      memcached do |dc|
        dc.flush

        dc.set("fetch_key", false)
        res = dc.fetch("fetch_key") { flunk "fetch block called" }
        assert_equal false, res

        dc.set("fetch_key", nil)
        res = dc.fetch("fetch_key") { "bob" }
        assert_equal 'bob', res
      end
    end

    should "support the cas operation" do
      memcached do |dc|
        dc.flush

        expected = { 'blah' => 'blerg!' }

        resp = dc.cas('cas_key') do |value|
          fail('Value should not exist')
        end
        assert_nil resp

        mutated = { 'blah' => 'foo!' }
        dc.set('cas_key', expected)
        resp = dc.cas('cas_key') do |value|
          assert_equal expected, value
          mutated
        end
        assert_equal true, resp

        resp = dc.get('cas_key')
        assert_equal mutated, resp
      end
    end

    should "support multi-get" do
      memcached do |dc|
        dc.close
        dc.flush
        resp = dc.get_multi(%w(a b c d e f))
        assert_equal({}, resp)

        dc.set('a', 'foo')
        dc.set('b', 123)
        dc.set('c', %w(a b c))
        resp = dc.get_multi(%w(a b c d e f))
        assert_equal({ 'a' => 'foo', 'b' => 123, 'c' => %w(a b c) }, resp)

        # Perform a huge multi-get with 10,000 elements.
        arr = []
        dc.multi do
          10_000.times do |idx|
            dc.set idx, idx
            arr << idx
          end
        end

        result = dc.get_multi(arr)
        assert_equal(10_000, result.size)
        assert_equal(1000, result['1000'])
      end
    end

    should 'support raw incr/decr' do
      memcached do |client|
        client.flush

        assert_equal true, client.set('fakecounter', 0, 0, :raw => true)
        assert_equal 1, client.incr('fakecounter', 1)
        assert_equal 2, client.incr('fakecounter', 1)
        assert_equal 3, client.incr('fakecounter', 1)
        assert_equal 1, client.decr('fakecounter', 2)
        assert_equal "1", client.get('fakecounter', :raw => true)

        resp = client.incr('mycounter', 0)
        assert_nil resp

        resp = client.incr('mycounter', 1, 0, 2)
        assert_equal 2, resp
        resp = client.incr('mycounter', 1)
        assert_equal 3, resp

        resp = client.set('rawcounter', 10, 0, :raw => true)
        assert_equal true, resp

        resp = client.get('rawcounter', :raw => true)
        assert_equal '10', resp

        resp = client.incr('rawcounter', 1)
        assert_equal 11, resp
      end
    end

    should "support incr/decr operations" do
      memcached do |dc|
        dc.flush

        resp = dc.decr('counter', 100, 5, 0)
        assert_equal 0, resp

        resp = dc.decr('counter', 10)
        assert_equal 0, resp

        resp = dc.incr('counter', 10)
        assert_equal 10, resp

        current = 10
        100.times do |x|
          resp = dc.incr('counter', 10)
          assert_equal current + ((x+1)*10), resp
        end

        resp = dc.decr('10billion', 0, 5, 10)
        # go over the 32-bit mark to verify proper (un)packing
        resp = dc.incr('10billion', 10_000_000_000)
        assert_equal 10_000_000_010, resp

        resp = dc.decr('10billion', 1)
        assert_equal 10_000_000_009, resp

        resp = dc.decr('10billion', 0)
        assert_equal 10_000_000_009, resp

        resp = dc.incr('10billion', 0)
        assert_equal 10_000_000_009, resp

        assert_nil dc.incr('DNE', 10)
        assert_nil dc.decr('DNE', 10)

        resp = dc.incr('big', 100, 5, 0xFFFFFFFFFFFFFFFE)
        assert_equal 0xFFFFFFFFFFFFFFFE, resp
        resp = dc.incr('big', 1)
        assert_equal 0xFFFFFFFFFFFFFFFF, resp

        # rollover the 64-bit value, we'll get something undefined.
        resp = dc.incr('big', 1)
        0x10000000000000000.wont_equal resp
        dc.reset
      end
    end

    should 'support the append and prepend operations' do
      memcached do |dc|
        resp = dc.flush
        assert_equal true, dc.set('456', 'xyz', 0, :raw => true)
        assert_equal true, dc.prepend('456', '0')
        assert_equal true, dc.append('456', '9')
        assert_equal '0xyz9', dc.get('456', :raw => true)
        assert_equal '0xyz9', dc.get('456')

        assert_equal false, dc.append('nonexist', 'abc')
        assert_equal false, dc.prepend('nonexist', 'abc')
      end
    end

    should 'allow TCP connections to be configured for keepalive' do
      memcached(19122, '', :keepalive => true) do |dc|
        dc.set(:a, 1)
        ring = dc.send(:ring)
        server = ring.servers.first
        socket = server.instance_variable_get('@sock')

        optval = socket.getsockopt(Socket::SOL_SOCKET, Socket::SO_KEEPALIVE)
        optval = optval.unpack 'i'

        assert_equal true, (optval[0] != 0)
      end
    end

    should "pass a simple smoke test" do
      memcached do |dc|
        resp = dc.flush
        resp.wont_be_nil
        assert_equal [true, true], resp

        assert_equal true, dc.set(:foo, 'bar')
        assert_equal 'bar', dc.get(:foo)

        resp = dc.get('123')
        assert_equal nil, resp

        resp = dc.set('123', 'xyz')
        assert_equal true, resp

        resp = dc.get('123')
        assert_equal 'xyz', resp

        resp = dc.set('123', 'abc')
        assert_equal true, resp

        dc.prepend('123', '0')
        dc.append('123', '0')

        assert_raises Dalli::DalliError do
          resp = dc.get('123')
        end

        dc.close
        dc = nil

        dc = Dalli::Client.new('localhost:19122')

        resp = dc.set('456', 'xyz', 0, :raw => true)
        assert_equal true, resp

        resp = dc.prepend '456', '0'
        assert_equal true, resp

        resp = dc.append '456', '9'
        assert_equal true, resp

        resp = dc.get('456', :raw => true)
        assert_equal '0xyz9', resp

        resp = dc.set('456', false)
        assert_equal true, resp

        resp = dc.get('456')
        assert_equal false, resp

        resp = dc.stats
        assert_equal Hash, resp.class

        dc.close
      end
    end

    should "support multithreaded access" do
      memcached do |cache|
        cache.flush
        workers = []

        cache.set('f', 'zzz')
        assert_equal true, (cache.cas('f') do |value|
          value << 'z'
        end)
        assert_equal 'zzzz', cache.get('f')

        # Have a bunch of threads perform a bunch of operations at the same time.
        # Verify the result of each operation to ensure the request and response
        # are not intermingled between threads.
        10.times do
          workers << Thread.new do
            100.times do
              cache.set('a', 9)
              cache.set('b', 11)
              inc = cache.incr('cat', 10, 0, 10)
              cache.set('f', 'zzz')
              wont_be_nil(cache.cas('f') do |value|
                value << 'z'
              end)
              assert_equal false, cache.add('a', 11)
              assert_equal({ 'a' => 9, 'b' => 11 }, cache.get_multi(['a', 'b']))
              inc = cache.incr('cat', 10)
              assert_equal 0, inc % 5
              dec = cache.decr('cat', 5)
              assert_equal 11, cache.get('b')
            end
          end
        end

        workers.each { |w| w.join }
        cache.flush
      end
    end

    should "handle namespaced keys" do
      memcached do |dc|
        dc = Dalli::Client.new('localhost:19122', :namespace => 'a')
        dc.set('namespaced', 1)
        dc2 = Dalli::Client.new('localhost:19122', :namespace => 'b')
        dc2.set('namespaced', 2)
        assert_equal 1, dc.get('namespaced')
        assert_equal 2, dc2.get('namespaced')

        dc3 = Dalli::Client.new('localhost:19122', :namespace => 'c' * 100)
        assert_raises ArgumentError do
          dc3.get "a" * 151
        end
      end
    end

    should "handle namespaced keys in multi_get" do
      memcached do |dc|
        dc = Dalli::Client.new('localhost:19122', :namespace => 'a')
        dc.set('a', 1)
        dc.set('b', 2)
        assert_equal({'a' => 1, 'b' => 2}, dc.get_multi('a', 'b'))
      end
    end

    should "handle application marshalling issues" do
      memcached do |dc|
        old = Dalli.logger
        Dalli.logger = Logger.new(nil)
        begin
          assert_equal false, dc.set('a', Proc.new { true })
        ensure
          Dalli.logger = old
        end
      end
    end

    context 'with compression' do
      should 'allow large values' do
        memcached do |dc|
          dalli = Dalli::Client.new(dc.instance_variable_get(:@servers), :compress => true)

          value = "0"*1024*1024
          assert_raises Dalli::DalliError, /too large/ do
            dc.set('verylarge', value)
          end
          dalli.set('verylarge', value)
        end
      end
    end

    context 'in low memory conditions' do

      should 'handle error response correctly' do
        memcached(19125, '-m 1 -M') do |dc|
          failed = false
          value = "1234567890"*100
          1_000.times do |idx|
            begin
              assert_equal true, dc.set(idx, value)
            rescue Dalli::DalliError
              failed = true
              assert((800..960).include?(idx), "unexpected failure on iteration #{idx}")
              break
            end
          end
          assert failed, 'did not fail under low memory conditions'
        end
      end

      should 'fit more values with compression' do
        memcached(19126, '-m 1 -M') do |dc|
          dalli = Dalli::Client.new('localhost:19126', :compress => true)
          failed = false
          value = "1234567890"*1000
          10_000.times do |idx|
            begin
              assert_equal true, dalli.set(idx, value)
            rescue Dalli::DalliError
              failed = true
              assert((6000..7800).include?(idx), "unexpected failure on iteration #{idx}")
              break
            end
          end
          assert failed, 'did not fail under low memory conditions'
        end
      end

    end

  end
end
