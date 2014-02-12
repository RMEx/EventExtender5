=begin
 Event Extender 5
 Network Module
 ===============================================================================
 http://www.biloucorp.com
 ===============================================================================
 By Nuki & Grim

=end

#==============================================================================
# ** Network
#------------------------------------------------------------------------------
# Network Interface
#==============================================================================

module Network
  #--------------------------------------------------------------------------
  # * API
  #--------------------------------------------------------------------------
  CloseSocket = Win32API.new('ws2_32', 'closesocket', 'p', 'l')
  Htons       = Win32API.new('ws2_32', 'htons', 'l', 'l')
  Inet_Addr   = Win32API.new('ws2_32', 'inet_addr', 'p', 'l')
  WSocket     = Win32API.new('ws2_32', 'socket', 'lll', 'l')
  Connect     = Win32API.new('ws2_32', 'connect', 'ppl', 'l')
  Send        = Win32API.new('ws2_32', 'send', 'ppll', 'l')
  Recv        = Win32API.new('ws2_32', 'recv', 'ppll', 'l')
  Shutdown    = Win32API.new('ws2_32', 'shutdown', 'pl', 'l')

  #==============================================================================
  # ** Socket
  #------------------------------------------------------------------------------
  # Socket Interface
  #==============================================================================

  class Socket
    #--------------------------------------------------------------------------
    # * Singleton
    #--------------------------------------------------------------------------
    class << self
      attr_accessor :singleton
      Socket.singleton = Socket.new
    end
    #--------------------------------------------------------------------------
    # * Object Constructor
    #--------------------------------------------------------------------------
    def initialize
      @socket     = WSocket.call(2,1,0)
      @connected  = false
      @shutdowned = - 1
    end
    #--------------------------------------------------------------------------
    # * Create connect buffer
    #--------------------------------------------------------------------------
    def connect_socket(port, host)
      s_family = 2
      s_port   = Htons.call(port)
      i_addr   = Inet_Addr.call(host)
      [s_family, s_port, i_addr].pack('sSLx8')
    end
    #--------------------------------------------------------------------------
    # * Make connection
    #--------------------------------------------------------------------------
    def make_connection(port, host)
      addr = connect_socket(port, host)
      !(Connect.call(@socket, addr, addr.size) == -1)
    end
    #--------------------------------------------------------------------------
    # * Connect
    #--------------------------------------------------------------------------
    def connect(host, port)
      if make_connection(port, host)
        @connected = true
        return
      end
      raise RuntimeError.new("Connection failed")
    end
    #--------------------------------------------------------------------------
    # * Shutdown
    #   < 0 No shutdowning
    #   0 = Stop reception
    #   1 = Stop sending
    #   2 = Stop everything
    #--------------------------------------------------------------------------
    def shutdown(how = 2)
      if how >= 0
        Shutdown.call(@socket, how)
      end
      @shutdowned = how
    end
    #--------------------------------------------------------------------------
    # * Close connection
    #--------------------------------------------------------------------------
    def close 
      @connected = false
      CloseSocket.call(@socket)
    end
    #--------------------------------------------------------------------------
    # * Send message
    #--------------------------------------------------------------------------
    def send(data)
      raise RuntimeError.new("Socket is shutdowned") if @shutdowned >= 1
      value = Send.call(@socket, data, data.length, 0)
      shutdown(1) if value == -1
      return !(value == -1)
    end
    #--------------------------------------------------------------------------
    # * Reception message
    #--------------------------------------------------------------------------
    def recv(len = 256)
      raise RuntimeError.new("Socket is shutdowned") if @shutdowned == 0 || @shutdowned == 2
      buffer = [].pack('x'+len.to_s)
      value = Recv.(@socket, buffer, len, 0)
      return buffer.gsub(/\x00/, "") if value != -1
      shutdown(1)
      false
    end
    #--------------------------------------------------------------------------
    # * Encapsulation
    #--------------------------------------------------------------------------
    private :connect_socket
    private :make_connection
  end

end
