=begin
 Event Extender 5
 Network Module
 ===============================================================================
 http://www.biloucorp.com
 ===============================================================================
 By Nuki & Grim

=end

#==============================================================================
# ** HTTP
#------------------------------------------------------------------------------
# Http Interface
#==============================================================================

module HTTP
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  USER_AGENT    = "ENTERBRAIN/VXACE(EVENTEXTENDER)"
  PROXY_NAME    = "WINHTTP_NO_PROXY_NAME"
  PROXY_BYPASS  = "WINHTTP_NO_PROXY_BYPASS"

  OPTIONS = "OPTIONS".to_ascii
  GET     = "GET".to_ascii
  HEAD    = "HEAD".to_ascii
  POST    = "POST".to_ascii
  PUT     = "PUT".to_ascii
  DELETE  = "DELETE".to_ascii
  TRACE   = "TRACE".to_ascii
  CONNECT = "CONNECT".to_ascii

  WinHttpOpen               = Win32API.new('winhttp','WinHttpOpen',"pippi",'i')
  WinHttpConnect            = Win32API.new('winhttp','WinHttpConnect',"ppii",'i')
  WinHttpOpenRequest        = Win32API.new('winhttp','WinHttpOpenRequest',"pppppii",'i')
  WinHttpSendRequest        = Win32API.new('winhttp','WinHttpSendRequest',"piiiiii",'i')
  WinHttpReceiveResponse    = Win32API.new('winhttp','WinHttpReceiveResponse',"pp",'i')
  WinHttpQueryDataAvailable = Win32API.new('winhttp','WinHttpQueryDataAvailable', "pi", "i")
  WinHttpReadData           = Win32API.new('winhttp','WinHttpReadData',"ppip",'i')
  WinHttpCloseHandle        = Win32API.new('winhttp','WinHttpCloseHandle',"p",'i')

  #==============================================================================
  # ** Request
  #------------------------------------------------------------------------------
  # Http Request Interface
  #==============================================================================

  class Request
    #--------------------------------------------------------------------------
    # * Public instance variables
    #--------------------------------------------------------------------------
    attr_accessor :result
    #--------------------------------------------------------------------------
    # * Constructor
    #--------------------------------------------------------------------------
    def initialize(host, path, method, port = 80, closable = true)
      @hinternet = WinHttpOpen.call(USER_AGENT, 0, PROXY_NAME, PROXY_BYPASS, 0)
      raise RuntimeError.new("Request construction failed") unless @hinternet
      connect(host, port)
      open_request(method, path)
      send_request
      @result = receive_response
      close if closable
    end
    #--------------------------------------------------------------------------
    # * HTTP Connection
    #--------------------------------------------------------------------------
    def connect(host, port = 80)
      @connection = WinHttpConnect.call(@hinternet, host.to_ascii, port, 0)
      raise RuntimeError.new("Request connection failed") unless @connection
    end
    #--------------------------------------------------------------------------
    # * Open request
    #--------------------------------------------------------------------------
    def open_request(method, path)
      @request = WinHttpOpenRequest.call(@connection, method, path.to_ascii, nil, nil, 0, 0)
      raise RuntimeError.new("Request decoration failed") unless @connection
    end
    #--------------------------------------------------------------------------
    # * Send request
    #--------------------------------------------------------------------------
    def send_request
      @send = WinHttpSendRequest.call(@request, 0, 0, 0, 0, 0, 0)
      raise RuntimeError.new("Request sending failed") unless @send
    end
    #--------------------------------------------------------------------------
    # * receive response
    #--------------------------------------------------------------------------
    def receive_response
      if WinHttpReceiveResponse.call(@request, nil)
        dwSize = 0
        if WinHttpQueryDataAvailable.call(@request, dwSize)
          p dwSize
          buffer = [].pack("x#{dwSize+1}")
          downloaded = [0].pack('i')
          if WinHttpReadData.call(@request, buffer, dwSize, downloaded)
            datasize = downloaded.unpack('i')[0]
            p buffer
            return buffer[0, datasize]
          end
        end
      end
      raise RuntimeError.new("Request reception failed")
    end
    #--------------------------------------------------------------------------
    # * Close connection
    #--------------------------------------------------------------------------
    def close
      WinHttpCloseHandle.call(@hinternet)
      WinHttpCloseHandle.call(@connection)
      WinHttpCloseHandle.call(@request)
    end

    #--------------------------------------------------------------------------
    # * Encapsulation
    #--------------------------------------------------------------------------
    private :connect
    private :open_request
    private :send_request
    private :receive_response
  end
  
end

#==============================================================================
# ** Socket
#------------------------------------------------------------------------------
# Socket Interface
#==============================================================================

class Socket

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
