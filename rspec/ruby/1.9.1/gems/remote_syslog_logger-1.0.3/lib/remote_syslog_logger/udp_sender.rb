require 'socket'
require 'syslog_protocol'

module RemoteSyslogLogger
  class UdpSender
    def initialize(remote_hostname, remote_port, options = {})
      @remote_hostname = remote_hostname
      @remote_port     = remote_port
      @whinyerrors     = options[:whinyerrors]
      
      @socket = UDPSocket.new
      @packet = SyslogProtocol::Packet.new

      local_hostname   = options[:local_hostname] || (Socket.gethostname rescue `hostname`.chomp)
      local_hostname   = 'localhost' if local_hostname.nil? || local_hostname.empty?
      @packet.hostname = local_hostname

      @packet.facility = options[:facility] || 'user'
      @packet.severity = options[:severity] || 'notice'
      @packet.tag      = options[:program]  || "#{File.basename($0)}[#{$$}]"
    end
    
    def transmit(message)
      message.split(/\r?\n/).each do |line|
        begin
          next if line =~ /^\s*$/
          packet = @packet.dup
          packet.content = line
          @socket.send(packet.assemble, 0, @remote_hostname, @remote_port)
        rescue
          $stderr.puts "#{self.class} error: #{$!.class}: #{$!}\nOriginal message: #{line}"
          raise if @whinyerrors
        end
      end
    end
    
    # Make this act a little bit like an `IO` object
    alias_method :write, :transmit
    
    def close
      @socket.close
    end
  end
end
