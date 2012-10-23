require 'stringio'

# Becuase of some wierdness in MiniTest
#debug, $DEBUG = $DEBUG, false
#require 'minitest/unit'
#$DEBUG = debug

module Turn

  # Turn's MiniTest test runner class.
  #
  class MiniRunner < ::MiniTest::Unit

    #
    def initialize
      @turn_config = Turn.config

      super()

      # route minitests traditional output to nowhere
      # (instead of overriding #puts and #print)
      @@out = ::StringIO.new
    end

    #
    def turn_reporter
      @turn_config.reporter
    end

    # Turn calls this method to start the test run.
    def start(args=[])
      # minitest changed #run in 6023c879cf3d5169953e on April 6th, 2011
      if ::MiniTest::Unit.respond_to?(:runner=)
        ::MiniTest::Unit.runner = self
      end
      # FIXME: why isn't @test_count set?
      run(args)
      return @turn_suite
    end

    # Override #_run_suite to setup Turn.
    def _run_suites suites, type
      @turn_suite = Turn::TestSuite.new(@turn_config.suite_name)
      @turn_suite.size = ::MiniTest::Unit::TestCase.test_suites.size

      turn_reporter.start_suite(@turn_suite)

      if @turn_config.matchcase
        suites = suites.select{ |suite| @turn_config.matchcase =~ suite.name }
      end

      result = suites.map { |suite| _run_suite(suite, type) }

      turn_reporter.finish_suite(@turn_suite)

      return result
    end

    # Override #_run_suite to iterate tests via Turn.
    def _run_suite suite, type
      # suites are cases in minitest
      @turn_case = @turn_suite.new_case(suite.name)

      filter = @turn_config.pattern || /./

      suite.send("#{type}_methods").grep(filter).each do |test|
        @turn_case.new_test(test)
      end

      turn_reporter.start_case(@turn_case)

      header = "#{type}_suite_header"
      puts send(header, suite) if respond_to? header

      assertions = @turn_case.tests.map do |test|
        @turn_test = test
        turn_reporter.start_test(@turn_test)

        inst = suite.new(test.name) #method
        inst._assertions = 0

        result = inst.run self

        if result == "."
          turn_reporter.pass
        end

        turn_reporter.finish_test(@turn_test)

        inst._assertions
      end

      @turn_case.count_assertions = assertions.inject(0) { |sum, n| sum + n }

      turn_reporter.finish_case(@turn_case)

      return assertions.size, assertions.inject(0) { |sum, n| sum + n }
    end

    # Override #puke to update Turn's internals and reporter.
    def puke(klass, meth, err)
      case err
      when MiniTest::Skip
        @turn_test.skip!
        turn_reporter.skip #(e)
      when MiniTest::Assertion
        @turn_test.fail!(err)
        turn_reporter.fail(err)
      else
        @turn_test.error!(err)
        turn_reporter.error(err)
      end
      super(klass, meth, err)
    end

    # To maintain compatibility with old versions of MiniTest.
    #
    # Hey, Ryan Davis wrote this code!
    if ::MiniTest::Unit::VERSION < '2.0'    
      #attr_accessor :options

      #
      def run(args=[])
        suites = ::MiniTest::Unit::TestCase.test_suites
        return if suites.empty?

        @test_count, @assertion_count = 0, 0
        sync = @@out.respond_to? :"sync=" # stupid emacs
        old_sync, @@out.sync = @@out.sync, true if sync

        results = _run_suites suites, :test #type

        @test_count      = results.inject(0) { |sum, (tc, _)| sum + tc }
        @assertion_count = results.inject(0) { |sum, (_, ac)| sum + ac }

        @@out.sync = old_sync if sync

        return failures + errors if @test_count > 0 # or return nil...
      rescue Interrupt
        abort 'Interrupted'
      end

    end

  end

end
