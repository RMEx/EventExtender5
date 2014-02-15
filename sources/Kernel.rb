# -*- coding: utf-8 -*-
=begin
 Event Extender 5
 Standard Module
 ===============================================================================
 http://www.biloucorp.com
 ===============================================================================
 Authors : 
 
 -Grim 
 -Hiino
 -Joke
 -Raho
 -Nuki
 -XHTMLBoy
 -Altor
 -Zangther
 
  # - Zeus81 (A lot of help for a lot of things)
  # - Fabien (Buzzer Command)
  # - Avygeil (A lot of inspiration)
  # - Heos (Beta test)
  # - Lidenvice (Help for test and ergonomic reflection and proofreading)
  # - Ulis (proofreading)
  #------------------------------------------------------------------------------
  # And for their social and technic help:
  #------------------------------------------------------------------------------
  # Magi, Al Rind, Testament, 
  # S4suk3, Tonyryu, Siegfried, Berka, Nagato Yuki, Roys, 
  # Raymo, Ypsoriama, Amalrich Von Monesser, Magic, Strall, 2cri,
  # TI-MAX, Playm, Kmkzy
#==============================================================================
=end

#==============================================================================
# ** Command
#------------------------------------------------------------------------------
# Adds easily usable commands
#==============================================================================

module Command
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  extend self
  #--------------------------------------------------------------------------
  # * Random between range
  #--------------------------------------------------------------------------
  def random(*min, max)
    min[0] ||= 0
    min, max = [min[0], max.to_i].sort
    min + Kernel.rand(max-min)
  end
  #--------------------------------------------------------------------------
  # * Return ID of current map
  #--------------------------------------------------------------------------
  def map_id
    $game_map.map_id
  end
  #--------------------------------------------------------------------------
  # * Return map's name
  #--------------------------------------------------------------------------
  def map_name
    $game_map.map_name
  end
  #--------------------------------------------------------------------------
  # * Get Event Id form coords
  #--------------------------------------------------------------------------
  def id_at(x, y)
    result = $game_map.id_xy(x, y)
    return result if result > 0
    return 0 if $game_player.x == x && $game_player.y == y
    return -1
  end
  #--------------------------------------------------------------------------
  # * Get terrain Tag from coords
  #--------------------------------------------------------------------------
  def terrain_tag(x, y)
    $game_map.terrain_tag(x, y)
  end
  #--------------------------------------------------------------------------
  # * Get Tile ID from coords and layer (0,1,2)
  #--------------------------------------------------------------------------
  def tile_id(x, y, layer)
    $game_map.tile_id(x, y, layer)
  end
  #--------------------------------------------------------------------------
  # * Get Region ID from coords
  #--------------------------------------------------------------------------
  def region_id(x, y)
    $game_map.region_id(x, y)
  end
  #--------------------------------------------------------------------------
  # * Check passability
  #--------------------------------------------------------------------------
  def square_passable?(x, y, d=2)
    $game_map.passable?(x, y, d)
  end
  #--------------------------------------------------------------------------
  # * Get a percent
  #--------------------------------------------------------------------------
  def percent(value, max)
    (value*100)/max
  end
  #--------------------------------------------------------------------------
  # * Get a value from a percent
  #--------------------------------------------------------------------------
  def apply_percent(percent, max)
    (percent*max)/100
  end
  #--------------------------------------------------------------------------
  # * Build a color
  #--------------------------------------------------------------------------
  def color(r, g, b, a=255)
    Color.new(r, g, b, a)
  end
  #--------------------------------------------------------------------------
  # * Build a color
  #--------------------------------------------------------------------------
  def tone(r, g, b, gr=255)
    Tone.new(r, g, b, gr)
  end
  #--------------------------------------------------------------------------
  # * Flash a tile square
  #--------------------------------------------------------------------------
  def flash_square(*coords, r, g, b)
    r = proportion(percent(r, 255), 15)
    g = proportion(percent(g, 255), 15)
    b = proportion(percent(r, 255), 15)
    color = (r.to_s(16)+g.to_s(16)+b.to_s(16)).to_i(16)
    tilemap.flash_data ||= Table.new($game_map.width, $game_map.height)
    case coords.length
    when 1
      coords.each{|i|tilemap.flash_data[i[0], i[1]] = color}
      return true
    when 2
      if coords[0].is_a?(Enumerable) && coords[1].is_a?(Enumerable)
        coords[1].each do |y|
          coords[0].each do |x|
            tilemap.flash_data[x, y] = color
          end
        end
        return true
      end
      if coords[0].is_a?(Enumerable) && coords[1].is_a?(Numeric)
        coords[0].each{|x|tilemap.flash_data[x, coords[1]] = color}
        return true
      end
      if coords[1].is_a?(Enumerable) && coords[0].is_a?(Numeric)
        coords[1].each{|y|tilemap.flash_data[coords[0], y] = color}
        return true
      end
      if coords[0].is_a?(Numeric) && coords[1].is_a?(Numeric)
        tilemap.flash_data[coords[0], coords[1]] = color
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * UnFlash a tile
  #--------------------------------------------------------------------------
  def unflash_square(*c)
    flash_square(*c, 0, 0, 0)
  end
  #--------------------------------------------------------------------------
  # * Include event page
  #--------------------------------------------------------------------------
  def include_page(map_id, id, page_id)
    return unless self.class == Game_Interpreter
    self.append_interpreter(map_id, id, page_id)
  end
  #--------------------------------------------------------------------------
  # * Return Windows Username
  #--------------------------------------------------------------------------
  def windows_username
    USERNAME
  end
  #--------------------------------------------------------------------------
  # * Method suggestions
  #--------------------------------------------------------------------------
  def method_missing(*args)
    keywords = Command.singleton_methods
    keywords.uniq!
    keywords.delete(:method_missing)
    keywords.collect!{|i|i.to_s}
    keywords.sort_by!{|o| o.damerau_levenshtein(args[0].to_s)}
    snd = keywords.length > 1 ? " or \"#{keywords[1]}\"" : ""
    msg = Vocab.method_missing(args, keywords)
    raise(NoMethodError, msg)
  end
  #==============================================================================
  # ** Private methods
  #------------------------------------------------------------------------------
  # Private methods of Module
  #==============================================================================
  #--------------------------------------------------------------------------
  # * Get Current Scene
  #--------------------------------------------------------------------------
  def scene
    SceneManager.scene
  end
  #--------------------------------------------------------------------------
  # * Get Spriteset of current Map
  #--------------------------------------------------------------------------
  def spriteset
    scene.spriteset
  end
  #--------------------------------------------------------------------------
  # * Get tileset of current Map
  #--------------------------------------------------------------------------
  def tilemap
    spriteset.tilemap
  end
  #--------------------------------------------------------------------------
  # * Privatisation
  #--------------------------------------------------------------------------
  private :scene, :spriteset, :tilemap
  #==============================================================================
  # ** Command::Description
  #------------------------------------------------------------------------------
  # Information about commands
  #==============================================================================
  module Description
    #--------------------------------------------------------------------------
    # * Singleton
    #--------------------------------------------------------------------------
    class << self; attr_accessor :Category; end
    #--------------------------------------------------------------------------
    # * Singleton
    #--------------------------------------------------------------------------
    extend self
    #--------------------------------------------------------------------------
    # * Register Category
    #--------------------------------------------------------------------------
    def register_category(name, s_name, desc)
      Description.Category ||= {}
      Description.Category[name] = Struct.new(:name, :desc).new(s_name, desc)
    end
    #--------------------------------------------------------------------------
    # * Register Simple command
    #   Std format :  import(key, category, desc, [*types], return_type) 
    #   Issues format import(key, category, [*[desc, [*types], return_type]])
    #--------------------------------------------------------------------------
    def import(key, category, *args)
      if args.length > 1
        if args.length == 2
          arg = []
          ret = args[1]
        else
          arg = args[1]
          ret = args[2]
        end
        hash = {
          category: category,
          desc: args[0],
          args: arg,
          returnable: ret
        }
      elsif args.length == 1
        hash = {category: category, issues: []}
        args.each do |elt|
          e_hash = {
            desc: elt[0],
            args: elt[1],
            returnable: elt[2]
          }
          hash[:issues] << e_hash
        end
      end
      if hash
        define_singleton_method(key){hash}
        return true
      end
      return false
    end
    #--------------------------------------------------------------------------
    # * All commands
    #--------------------------------------------------------------------------
    def all
      all_methods = singleton_methods
      all_methods.delete(:all)
      all_methods.delete(:import)
      all_methods.delete(:register_category)
      all_methods.delete(:Category)
      all_methods.delete(:Category=)
      all_methods
    end
  end
  #==============================================================================
  # ** Command::API
  #------------------------------------------------------------------------------
  # Information about commands
  #==============================================================================
  module API
    #--------------------------------------------------------------------------
    # * API for command handling
    #--------------------------------------------------------------------------
    def command(name, *args)
      method_name = name.to_sym
      Command.send(method_name, *args)
    end
    #--------------------------------------------------------------------------
    # * Alias
    #--------------------------------------------------------------------------
    alias :cmd :command
    alias :c :command
  end
end


#==============================================================================
# ** V (special thanks to Nuki)
#------------------------------------------------------------------------------
#  Variable handling API
#==============================================================================

module V
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  extend self
  #--------------------------------------------------------------------------
  # * Returns a Game Variable
  #--------------------------------------------------------------------------
  def [](key)
    $game_variables[key] || 0
  end
  
  #--------------------------------------------------------------------------
  # * Modifies a variable
  #--------------------------------------------------------------------------
  def []=(key, value)
    if key.is_a?(Range)
      key.each do |k|
        $game_variables[k] = value
      end
    else
      $game_variables[key] = value
    end
  end
end

#==============================================================================
# ** S (special thanks to Nuki)
#------------------------------------------------------------------------------
# Switch handling API
#==============================================================================

module S
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  extend self
  #--------------------------------------------------------------------------
  # * Returns a Game Switch
  #--------------------------------------------------------------------------
  def [](key)
    $game_switches[key] || false
  end
  #--------------------------------------------------------------------------
  # * Modifies a Game Switch
  #--------------------------------------------------------------------------
  def []=(key, value)
    if key.is_a?(Range)
      key.each do |k|
        $game_switches[k] = value.to_bool
      end
    else
      $game_switches[key] = value.to_bool
    end
  end
end

#==============================================================================
# ** SV (special thanks to Zeus81)
#------------------------------------------------------------------------------
#  self Variable handling API
#==============================================================================

module SV
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  extend self
  #--------------------------------------------------------------------------
  # * Returns a self Variable
  #--------------------------------------------------------------------------
  def [](*args, id)
    id = args[-1] || Game_Interpreter.current_id
    map_id = args[-2] || Game_Interpreter.current_map_id
    $game_self_vars.fetch([map_id, id, id], 0)
  end
  #--------------------------------------------------------------------------
  # * Modifies a self variable
  #--------------------------------------------------------------------------
  def []=(*args, id, value)
    id = args[-1] || Game_Interpreter.current_id
    map_id = args[-2] || Game_Interpreter.current_map_id
    $game_self_vars[[map_id, id, id]] = value
    $game_map.need_refresh = true
  end
end

#==============================================================================
# ** SS (special thanks to Zeus81)
#------------------------------------------------------------------------------
#  Self Switches handling API
#==============================================================================

module SS
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  extend self
  #--------------------------------------------------------------------------
  # * map key
  #--------------------------------------------------------------------------
  def map_id_s(id)
    auth = ["A","B","C","D"]
    return id if auth.include?(id)
    return auth[id-1] if id.to_i.between?(1, 4)
    return "A"
  end
  private :map_id_s
  #--------------------------------------------------------------------------
  # * Returns a self switch
  #--------------------------------------------------------------------------
  def [](*args, id)
    id = args[-1] || Game_Interpreter.current_id
    map_id = args[-2] || Game_Interpreter.current_map_id
    key = [map_id, id, map_id_s(id)]
    $game_self_switches[key]
  end
  #--------------------------------------------------------------------------
  # * Modifies a self switch
  #--------------------------------------------------------------------------
  def []=(*args, id, value)
    id = args[-1] || Game_Interpreter.current_id
    map_id = args[-2] || Game_Interpreter.current_map_id
    key = [map_id, id, map_id_s(id)]
    $game_self_switches[key] = value.to_bool
    $game_map.need_refresh = true
  end
end

#==============================================================================
# ** Module
#------------------------------------------------------------------------------
#  A Module is a collection of methods and constants. 
#  The methods in a module may be instance methods or module methods.
#==============================================================================

class Module
  #--------------------------------------------------------------------------
  # * Add Commands to Command Collection
  #--------------------------------------------------------------------------
  def append_commands
    Command.send(:extend, self)
    Game_Interpreter.send(:include, self)
  end
  #--------------------------------------------------------------------------
  # * Public Command Interface
  #--------------------------------------------------------------------------
  def include_commands
    include Command::API
    include Command
  end
  #--------------------------------------------------------------------------
  # * Add Commands Description
  #--------------------------------------------------------------------------
  def append_descriptions
    Command::Description.send(:extend, self)
  end
end

#==============================================================================
# ** Object
#------------------------------------------------------------------------------
#  Generic behaviour
#==============================================================================

class Object
  #--------------------------------------------------------------------------
  # * check type : bool
  #--------------------------------------------------------------------------
  def boolean?; false;  end
  def to_bool;  !!self; end
  #--------------------------------------------------------------------------
  # * Polymorphic casting
  #--------------------------------------------------------------------------
  def nothing; self; end
  #--------------------------------------------------------------------------
  # * Get Instance values
  #--------------------------------------------------------------------------
  def instance_values
    instances = Hash.new
    instance_variables.each do |i|
      instances[i] = instance_variable_get(i)
    end
    instances
  end
end

#==============================================================================
# ** FalseClass
#------------------------------------------------------------------------------
#  The false class. false is the only instance of the FalseClass class. 
#  false, like nil, denotes a FALSE condition, while all other objects are TRUE.
#==============================================================================

class FalseClass
  #--------------------------------------------------------------------------
  # * check type : bool
  #--------------------------------------------------------------------------
  def boolean?; true;  end
  def to_bool;  false;  end
  #--------------------------------------------------------------------------
  # * Toggle
  #--------------------------------------------------------------------------
  def toggle; true; end
end

#==============================================================================
# ** TrueClass
#------------------------------------------------------------------------------
#  The true class. true is the only instance of the TrueClass class. 
#  true is a representative object that denotes a TRUE condition.
#==============================================================================

class TrueClass
  #--------------------------------------------------------------------------
  # * check type : bool
  #--------------------------------------------------------------------------
  def boolean?; false;  end
  def to_bool;  true;   end
  #--------------------------------------------------------------------------
  # * Toggle
  #--------------------------------------------------------------------------
  def toggle; false; end
end


#==============================================================================
# ** Win32API
#------------------------------------------------------------------------------
#  win32/registry is registry accessor library for Win32 platform. 
#  It uses dl/import to call Win32 Registry APIs.
#==============================================================================

class Win32API
  #--------------------------------------------------------------------------
  # * RGSS DLL
  #--------------------------------------------------------------------------
  GetPrivateProfileStringA  = self.new('kernel32', 'GetPrivateProfileStringA', 'pppplp', 'l')
  buffer = [].pack('x256')
  GetPrivateProfileStringA.('Game', 'Library', '', buffer, 256, ".\\Game.ini")
  RGSSLIB = buffer.delete(0.chr)
  #--------------------------------------------------------------------------
  # * Librairy
  #--------------------------------------------------------------------------
  CloseClipboard            ||= self.new('user32', 'CloseClipboard', 'v', 'i')
  EmptyClipboard            ||= self.new('user32', 'EmptyClipboard', 'v', 'i')
  FindWindow                ||= self.new('user32', 'FindWindow', 'pp', 'i')
  GetClipboardData          ||= self.new('user32', 'GetClipboardData', 'i', 'i')
  GetCursorPos              ||= self.new('user32', 'GetCursorPos', 'p', 'i')
  GetDoubleClickTime        ||= self.new('user32', 'GetDoubleClickTime', '', 'i')
  GetKeyboardState          ||= self.new('user32', 'GetKeyboardState', 'p', 'i')
  GlobalAlloc               ||= self.new('kernel32', 'GlobalAlloc', 'ii', 'i')
  GlobalFree                ||= self.new('kernel32', 'GlobalFree', 'i', 'i')
  GlobalLock                ||= self.new('kernel32', 'GlobalLock', 'i', 'l')
  GlobalSize                ||= self.new('kernel32', 'GlobalSize', 'l', 'l')
  GlobalUnlock              ||= self.new('kernel32', 'GlobalUnlock', 'l', 'v')
  MapVirtualKey             ||= self.new('user32', 'MapVirtualKey', 'ii', 'i')
  Memcpy                    ||= self.new('msvcrt', 'memcpy', 'ppi', 'i')
  MessageBox                ||= self.new('user32','MessageBox','lppl','i')
  MultiByteToWideChar       ||= self.new('kernel32', 'MultiByteToWideChar', 'ilpipi', 'i')
  OpenClipboard             ||= self.new('user32', 'OpenClipboard', 'i', 'i')
  RegisterClipboardFormat   ||= self.new('user32', 'RegisterClipboardFormat', 'p', 'i')
  ScreenToClient            ||= self.new('user32', 'ScreenToClient', 'lp', 'i')
  SetClipboardData          ||= self.new('user32', 'SetClipboardData', 'ii', 'i')
  ShowCursor                ||= self.new('user32', 'ShowCursor', 'i', 'i')
  ToUnicode                 ||= self.new('user32', 'ToUnicodeEx', 'llppil', 'l')
  WideCharToMultiByte       ||= self.new('kernel32', 'WideCharToMultiByte', 'ilpipipp', 'i')
  #--------------------------------------------------------------------------
  # * 360 Game Pad WIN32API's
  #--------------------------------------------------------------------------
  xinput = ->(dll){ return dll, self.new(dll, 'XInputGetState', 'ip', 'i')}
  xdll, XInputGetState  =   xinput.('xinput1_3') rescue
                            xinput.('xinput1_2') rescue
                            xinput.('xinput1_1') rescue
                            xinput.('xinput8_1_0') rescue 
                            [nil, nil]
  XInputSetState =  self.new(xdll, 'XInputSetState', 'ip', 'i') if xdll
end

#==============================================================================
# ** Numeric
#------------------------------------------------------------------------------
# Managing digits separately
#==============================================================================

class Numeric
   #--------------------------------------------------------------------------
   # * handle isoler
   #--------------------------------------------------------------------------
   def isole_int(i); (self%(10**i))/(10**(i-1)).to_i; end
   #--------------------------------------------------------------------------
   # * Int isoler
   #--------------------------------------------------------------------------
   [:units, :tens, :hundreds, :thousands,
     :tens_thousands, :hundreds_thousands,
     :millions, :tens_millions, 
     :hundreds_millions ].each.with_index{|m, i|define_method(m){isole_int(i+1)}}
   #--------------------------------------------------------------------------
   # * alias
   #--------------------------------------------------------------------------
   alias :unites              :units
   alias :dizaines            :tens
   alias :centaines           :hundreds
   alias :milliers            :thousands
   alias :dizaines_milliers   :tens_thousands
   alias :centaines_milliers  :hundreds_thousands
   alias :dizaines_millions   :tens_millions
   alias :centaines_millions  :hundreds_millions
end

#==============================================================================
# ** String
#------------------------------------------------------------------------------
#  A String object holds and manipulates an arbitrary sequence of bytes, 
#  typically representing characters.
#==============================================================================

class String
  #--------------------------------------------------------------------------
  # * CONSTANTS
  #--------------------------------------------------------------------------
  ASCII8BIT = 0
  UTF8 = 65001
  #--------------------------------------------------------------------------
  # * convert format to ansi
  #--------------------------------------------------------------------------
  def lpcwstr
    ns = ""
    self.each_char do |c|
      ns += c
      ns += "\0"
    end
    ns
  end
  #--------------------------------------------------------------------------
  # * convert format
  #--------------------------------------------------------------------------
  def convert_format(from, to)
    size = Win32API::MultiByteToWideChar.(from, 0, self, -1, nil, 0)
    buffer = [].pack("x#{size*2}")
    Win32API::MultiByteToWideChar.(from, 0, self, -1, buffer, buffer.size/2)
    size = Win32API::WideCharToMultiByte.(to, 0, buffer, -1, nil, 0, nil, nil)
    second_buffer = [].pack("x#{size}")
    Win32API::WideCharToMultiByte.(to, 0, buffer, -1, second_buffer, second_buffer.size, nil, nil)
    second_buffer.delete!("\000") if to == 65001
    second_buffer.delete!("\x00") if to == 0
    return second_buffer
  end
  #--------------------------------------------------------------------------
  # * return self in ASCII-8BIT
  #--------------------------------------------------------------------------
  def to_ascii; convert_format(UTF8, ASCII8BIT);end
  #--------------------------------------------------------------------------
  # * convert self in ASCII-8BIT
  #--------------------------------------------------------------------------
  def to_ascii!; replace(to_ascii); end
  #--------------------------------------------------------------------------
  # * return self to UTF8
  #--------------------------------------------------------------------------
  def to_utf8; convert_format(ASCII8BIT, UTF8); end
  #--------------------------------------------------------------------------
  # * convert self in UTF8
  #--------------------------------------------------------------------------
  def to_utf8!; replace(to_utf8); end
  #--------------------------------------------------------------------------
  # * Extract number
  #--------------------------------------------------------------------------
  def extract_numbers
    scan(/-*\d+/).collect{|n|n.to_i}
  end
  #--------------------------------------------------------------------------
  # * Calcul the Damerau Levenshtein 's Distance 
  #--------------------------------------------------------------------------
  def damerau_levenshtein(other)
    n, m = self.length, other.length
    return m if n == 0
    return n if m == 0
    matrix  = Array.new(n+1) do |i|
      Array.new(m+1) do |j|
        if i == 0 then j
        elsif j == 0 then i 
        else 0 end
      end
    end
    (1..n).each do |i|
      (1..m).each do |j|
        cost = (self[i] == other[j]) ? 0 : 1
        delete = matrix[i-1][j] + 1
        insert = matrix[i][j-1] + 1
        substitution = matrix[i-1][j-1] + cost
        matrix[i][j] = [delete, insert, substitution].min
        if (i > 1) && (j > 1) && (self[i] == other[j-1]) && (self[i-1] == other[j])
          matrix[i][j] = [matrix[i][j], matrix[i-2][j-2] + cost].min
        end
      end
    end
    return matrix.last.last
  end
  #--------------------------------------------------------------------------
  # * Format a string
  #--------------------------------------------------------------------------
  def cut(len_line)
    n_s = [""]
    i = 0
    self.split(' ').each do |l|
      if (n_s[i].length + l.length) > len_line
        if l.length > len_line
          n_l = l.scan(/.{0,#{len_line-1}}/)
          n_l[0..-3].collect!{|e|e<<'-'}
          n_s += n_l
          i += n_l.length - 1
          next
        else
          i += 1
        end
      end
      n_s[i] ||= ""
      n_s[i] += ' ' << l
    end
    n_s = n_s.join('\n').split('\n')
    n_s.compact.collect(&:strip)
  end
end

#==============================================================================
# ** Rect
#------------------------------------------------------------------------------
#  The rectangle class.
#==============================================================================

class Rect
  #--------------------------------------------------------------------------
  # * check if point 's include in the rect
  #--------------------------------------------------------------------------
  def in?(x, y)
    check_x = x.between?(self.x, self.x+self.width)
    check_y = y.between?(self.y, self.y+self.height)
    check_x && check_y
  end
  #--------------------------------------------------------------------------
  # * check if the mouse 's hover
  #--------------------------------------------------------------------------
  def hover?; in?(Mouse.x, Mouse.y); end
  #--------------------------------------------------------------------------
  # * check Mouse Interaction
  #--------------------------------------------------------------------------
  def click?(key);    hover? && Mouse.click?(key);    end
  def press?(key);    hover? && Mouse.press?(key);    end
  def trigger?(key);  hover? && Mouse.trigger?(key);  end
  def repeat?(key);   hover? && Mouse.repeat?(key);   end
  def release?(key);  hover? && Mouse.release?(key);  end
end

#==============================================================================
# ** Viewport
#------------------------------------------------------------------------------
#  Used when displaying sprites on one portion of the screen
#==============================================================================
class Viewport
  #--------------------------------------------------------------------------
  # * alias
  #--------------------------------------------------------------------------
  alias :ee_initialize initialize
  #--------------------------------------------------------------------------
  # * Public instances variables
  #--------------------------------------------------------------------------
  attr_accessor :elts
  #--------------------------------------------------------------------------
  # * Object initialize
  #--------------------------------------------------------------------------
  def initialize(*args)
    ee_initialize(*args)
    @elts = []
  end
  #--------------------------------------------------------------------------
  # * append Sprites
  #--------------------------------------------------------------------------
  def append(s)
    @elts << (s)
  end
  #--------------------------------------------------------------------------
  # * Calcul height space
  #--------------------------------------------------------------------------
  def calc_height
    return rect.height if @elts.empty?
    v = @elts.max{|a, b| (a.y + a.rect.height) <=> (b.y + b.rect.height)}
    [(v.y+v.rect.height), rect.height].max
  end
  #--------------------------------------------------------------------------
  # * Calcul height space
  #--------------------------------------------------------------------------
  def calc_width
    return rect.width if @elts.empty?
    v = @elts.max{|a, b| (a.x + a.rect.width) <=> (b.x + b.rect.width)}
    [(v.x+v.rect.width), rect.width].max
  end
  #--------------------------------------------------------------------------
  # * Accesseur 
  #--------------------------------------------------------------------------
  def x; rect.x; end
  def y; rect.y; end
  def width; rect.width; end
  def height; rect.height; end
  #--------------------------------------------------------------------------
  # * Mutator
  #--------------------------------------------------------------------------
  def x=(v); rect.x = v; end
  def y=(v); rect.y = v; end
  def width=(v); rect.width = v; end
  def height=(v); rect.height = v; end
end

#==============================================================================
# ** Tilemap
#------------------------------------------------------------------------------
#  Tilemap representation
#==============================================================================
class Tilemap
  #--------------------------------------------------------------------------
  # * alias
  #--------------------------------------------------------------------------
  alias :set_viewport   :viewport=
  alias :ee_initialize  :initialize
  alias :set_map_data   :map_data=
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :x, :y, :rect
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize(vp = nil)
    ee_initialize(vp)
    @x = @y = 0
    @rect = Rect.new(0,0,0,0)
    vp.append(self) if vp
  end
  #--------------------------------------------------------------------------
  # * Set Viewport
  #--------------------------------------------------------------------------
  def viewport=(vp)
    set_viewport(vp)
    vp.append(self) if vp
  end
  #--------------------------------------------------------------------------
  # * Set Map Data
  #--------------------------------------------------------------------------
  def map_data=(md)
    set_map_data(md)
    @rect.set(0,0,(md.xsize*32)+16, (md.ysize*32)+16)
  end
end

#==============================================================================
# ** Plane
#------------------------------------------------------------------------------
#  Scrollable Plane
#==============================================================================
class Plane
  #--------------------------------------------------------------------------
  # * alias
  #--------------------------------------------------------------------------
  alias :set_viewport   :viewport=
  alias :ee_initialize  :initialize
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :x, :y
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize(vp = nil)
    ee_initialize(vp)
    @x = @y = 0
    vp.append(self) if vp
  end
  #--------------------------------------------------------------------------
  # * Set Viewport
  #--------------------------------------------------------------------------
  def viewport=(vp)
    set_viewport(vp)
    vp.append(self) if vp
  end
  #--------------------------------------------------------------------------
  # * Get rect
  #--------------------------------------------------------------------------
  def rect
    return Rect.new(0,0,0,0) unless bitmap
    t_x, t_y = 0, 0
    if viewport != nil
      t_x = viewport.rect.x - viewport.ox
      t_y = viewport.rect.y - viewport.oy
    end
    Rect.new(t_x, t_y, bitmap.width, bitmap.height)
  end
end

#==============================================================================
# ** Sprite
#------------------------------------------------------------------------------
#  Scrollable Sprite
#==============================================================================
class Sprite
  #--------------------------------------------------------------------------
  # * alias
  #--------------------------------------------------------------------------
  alias :set_viewport   :viewport=
  alias :ee_initialize  :initialize
  #--------------------------------------------------------------------------
  # * Initialize
  #--------------------------------------------------------------------------
  def initialize(vp = nil)
    ee_initialize(vp)
    vp.append(self) if vp
  end
  #--------------------------------------------------------------------------
  # * Set Viewport
  #--------------------------------------------------------------------------
  def viewport=(vp)
    set_viewport(vp)
    vp.append(self) if vp
  end
  #--------------------------------------------------------------------------
  # * Get rect
  #--------------------------------------------------------------------------
  def rect
    return Rect.new(0,0,0,0) unless bitmap
    t_x, t_y = self.x, self.y
    if viewport != nil
      t_x = viewport.rect.x - viewport.ox + self.x
      t_y = viewport.rect.y - viewport.oy + self.y
    end
    Rect.new(t_x, t_y, bitmap.width, bitmap.height)
  end
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This is a super class of all windows within the game.
#==============================================================================
class Window_Base
  #--------------------------------------------------------------------------
  # * alias
  #--------------------------------------------------------------------------
  alias :set_viewport :viewport=
  #--------------------------------------------------------------------------
  # * Set Viewport
  #--------------------------------------------------------------------------
  def viewport=(vp)
    set_viewport(vp)
    vp.append(self) if vp
  end
  #--------------------------------------------------------------------------
  # * rect
  #--------------------------------------------------------------------------
  def rect
    return Rect.new(0,0,0,0) if disposed?
    t_x, t_y = self.x, self.y
    if viewport != nil
      t_x = viewport.rect.x - viewport.ox + self.x
      t_y = viewport.rect.y - viewport.oy + self.y
    end
    Rect.new(t_x, t_y, width, height)
  end
end

#==============================================================================
# ** UI
#------------------------------------------------------------------------------
#  User Interaction
#==============================================================================

module UI
  #==============================================================================
  # ** API
  #------------------------------------------------------------------------------
  #  Command handling
  #==============================================================================
  module API
    #--------------------------------------------------------------------------
    # * Keyboard support
    #--------------------------------------------------------------------------
    def key_press?(k);        ::Keyboard.press?(k);       end
    def key_trigger?(k);      ::Keyboard.trigger?(k);     end
    def key_release?(k);      ::Keyboard.release?(k);     end
    def key_repeat?(k);       ::Keyboard.repeat?(k);      end
    def ctrl?(k=nil);         ::Keyboard.ctrl?(k);        end
    def keyboard_all?(m, *k); ::Keyboard.all?(m, *k);     end
    def keyboard_any?(m, *k); ::Keyboard.any?(m, *k);     end
    def caps_lock?;           ::Keyboard.caps_lock?;      end
    def num_lock?;            ::Keyboard.num_lock?;       end
    def scroll_lock?;         ::Keyboard.scroll_lock?;    end
    def maj?;                 ::Keyboard.maj?;            end
    def alt_gr?;              ::Keyboard.alt_gr?;         end
    def keyboard_num;         ::Keyboard.number.to_i;     end
    def keyboard_letter;      ::Keyboard.letter;          end
    def key_time(k);          ::Keyboard.time(k);         end
    def key_current(*m);      ::Keyboard.current_key(*m); end
    #--------------------------------------------------------------------------
    # * Mouse Support
    #--------------------------------------------------------------------------
    def mouse_press?(k);    ::Mouse.press?(k);      end
    def mouse_click?(k);    ::Mouse.click?(k);      end
    def mouse_trigger?(k);  ::Mouse.trigger?(k);    end
    def mouse_release?(k);  ::Mouse.release?(k);    end
    def mouse_repeat?(k);   ::Mouse.repeat?(k);     end
    def mouse_all?(m, *k);  ::Mouse.all?(m, *k);    end
    def mouse_any?(m, *k);  ::Mouse.any?(m, *k);    end
    def mouse_x;            ::Mouse.x;              end
    def mouse_y;            ::Mouse.y;              end 
    def mouse_x_square;     ::Mouse.x_square;       end
    def mouse_y_square;     ::Mouse.y_square;       end
    def mouse_rect;         ::Mouse.rect;           end
    def mouse_last_rect;    ::Mouse.last_rect;      end
    def click_time(k);      ::Mouse.time(k);        end
    def mouse_current(*m)   ::Mouse.current_key(*m);end
    #--------------------------------------------------------------------------
    # * Clipboard support
    #--------------------------------------------------------------------------
    def clipboard_get_text;         ::Clipboard.get_text;         end
    def clipboard_push_text(text);  ::Clipboard.push_text(text);  end
    #--------------------------------------------------------------------------
    # * XBOX360Joypad support
    #--------------------------------------------------------------------------
    def pad360_plugged?(id = 0); XBOX360Utils.plugged?(id);  end
    def pad360_stop_vibration_left(id = 0)
      XBOX360Utils.stop_left_vibration(id)
    end
    def pad360_stop_vibration_right(id = 0)
      XBOX360Utils.stop_right_vibration(id)
    end
    def pad360_vibrate(id = 0, left = 100, right = 100)
      XBOX360Utils.left_vibration(id, left)
      XBOX360Utils.right_vibration(id, right)
    end
    def pad360_stop_vibration(id = 0)
      XBOX360Utils.stop_left_vibration(id)
      XBOX360Utils.stop_right_vibration(id)
    end
    def pad360_vibrate_left(id = 0, s = 100)
      XBOX360Utils.left_vibration(id, s)
    end
    def pad360_vibrate_right(id = 0, s = 100)
      XBOX360Utils.right_vibration(id, s)
    end
    #--------------------------------------------------------------------------
    # * Load Commands
    #--------------------------------------------------------------------------
    append_commands
  end
  
  #==============================================================================
  # ** XBOX360Utils
  #------------------------------------------------------------------------------
  #  Tool for XBOX360GamePad
  #==============================================================================
  module XBOX360Utils
    #--------------------------------------------------------------------------
    # * Singleton
    #--------------------------------------------------------------------------
    class << self
      #--------------------------------------------------------------------------
      # * Public instance variables
      #--------------------------------------------------------------------------
      attr_accessor :v_state
      XBOX360Utils.v_state = [0, 0]
      #--------------------------------------------------------------------------
      # * Set Vibration
      #--------------------------------------------------------------------------
      def set_vibration(id, motor, strength)
        XBOX360Utils.v_state[motor] = (strength.to_f)/100.0
        vibration_left = [XBOX360Utils.v_state[0] * 0xFFFF, 0xFFFF].min
        vibration_right = [XBOX360Utils.v_state[1] * 0xFFFF, 0xFFFF].min
        Win32API::XInputSetState.(id, [vibration_left, vibration_right].pack('S2'))
      end
      #--------------------------------------------------------------------------
      # * Set Vibration to motor left
      #--------------------------------------------------------------------------
      def left_vibration(id, strength)
        set_vibration(id, 0, strength)
      end
      #--------------------------------------------------------------------------
      # * Stop Vibration to motor left
      #--------------------------------------------------------------------------
      def stop_left_vibration(id)
        set_vibration(id, 0, 0)
      end
      #--------------------------------------------------------------------------
      # * Stop Vibration to motor right
      #--------------------------------------------------------------------------
      def stop_right_vibration(id)
        set_vibration(id, 1, 0)
      end
      #--------------------------------------------------------------------------
      # * Set Vibration to motor right
      #--------------------------------------------------------------------------
      def right_vibration(id, strength)
        set_vibration(id, 1, strength)
      end
      #--------------------------------------------------------------------------
      # * Check if controller 's plugged
      #--------------------------------------------------------------------------
      def plugged?(id = 0)
        Win32API::XInputGetState.(id, [].pack('x16')) == 0
      end
    end
  end
  
  #==============================================================================
  # ** Clipboard
  #------------------------------------------------------------------------------
  #  Clipboard manager
  #==============================================================================
  module Clipboard
    #--------------------------------------------------------------------------
    # * Singleton
    #--------------------------------------------------------------------------
    extend self
    #--------------------------------------------------------------------------
    # * Get a clipboard format
    #--------------------------------------------------------------------------
    def get_format(key)
      Win32API::RegisterClipboardFormat.(key)
    end
    #--------------------------------------------------------------------------
    # * Copy Text
    #--------------------------------------------------------------------------
    def push_text(clip_data)
      clip_data.to_ascii!.to_utf8!
      Win32API::OpenClipboard.(0)
      Win32API::EmptyClipboard.()
      hmem = Win32API::GlobalAlloc.(0x42, clip_data.length+1)
      mem = Win32API::GlobalLock.(hmem)
      Win32API::Memcpy.(mem, clip_data, clip_data.length+1)
      Win32API::SetClipboardData.(7, hmem)
      Win32API::GlobalFree.(hmem)
      Win32API::CloseClipboard.()
      true
    end
    #--------------------------------------------------------------------------
    # *  Get value from clipboard
    #--------------------------------------------------------------------------
    def get_text
      Win32API::OpenClipboard.(0)
      data = Win32API::GetClipboardData.(7)
      Win32API::CloseClipboard.()
      return "" if data == 0
      mem = Win32API::GlobalLock.(data)
      size = Win32API::GlobalSize.(data)
      final_data = " "*(size-1)
      Win32API::Memcpy.(final_data, mem, size)
      Win32API::GlobalUnlock.(data)
      final_data
    end
    #--------------------------------------------------------------------------
    # *  Push Command in Clipboard
    #--------------------------------------------------------------------------
    def push_command(*commands)
      clip_data = Marshal.dump(commands)
      clip_data.insert(0, [clip_data.size].pack('L'))
      Win32API::OpenClipboard.(0)
      Win32API::EmptyClipboard.()
      hmem = Win32API::GlobalAlloc.(0x42, clip_data.length)
      mem = Win32API::GlobalLock.(hmem)
      Win32API::Memcpy.(mem, clip_data, clip_data.length)
      Win32API::SetClipboardData.(FORMAT, hmem)
      Win32API::GlobalFree.(hmem)
      Win32API::CloseClipboard.()
      true
    end
  end
  #==============================================================================
  # ** Device
  #------------------------------------------------------------------------------
  #  Abstract Device Representation
  #==============================================================================
  class Device
    #--------------------------------------------------------------------------
    # * Keys definition
    #--------------------------------------------------------------------------
    Keys = {
      mouse_left: 0x01, mouse_right: 0x02, mouse_center: 0x04,
      
      backspace:  0x08, tab:  0x09,   clear:  0x0C, enter:    0x0D,
      shift:      0x10, ctrl: 0x011,  alt:    0x12, pause:    0x13, 
      caps_lock:  0x14, esc:  0x1B,   space:  0x20, page_up:  0x21,
      page_down:  0x22, end:  0x23,   home:   0x24, 
      
      left:   0x25, up:     0x26, right:    0x27, down:     0x28, 
      select: 0x29, print:  0x2A, snapshot: 0x2C, execute:  0x2B, 
      insert: 0x2D, delete: 0x2E, help:     0x2F, 
      
      zero: 0x30, one:    0x31, two:    0x32, three:  0x33, four:   0x34, five: 0x35, 
      six:  0x36, seven:  0x37, eight:  0x38, nine:   0x39, minus:  0xBD, 
      
      a: 0x41, b: 0x42, c: 0x43, d: 0x44, e: 0x45, f: 0x46, g: 0x47, h: 0x48,
      i: 0x49, j: 0x4A, k: 0x4B, l: 0x4C, m: 0x4D, n: 0x4E, o: 0x4F, p: 0x50, 
      q: 0x51, r: 0x52, s: 0x53, t: 0x54, u: 0x55, v: 0x56, w: 0x57, x: 0x58, 
      y: 0x59, z: 0x5A, 
      
      lwindow: 0x5B, rwindow: 0x5C, apps: 0x5D, 
      
      num_zero:   0x60, num_one:    0x61, num_two:  0x62, num_three:  0x63, 
      num_four:   0x64, num_five:   0x65, num_six:  0x66, num_seven:  0x67, 
      num_eight:  0x68, num_nine:   0x69, multiply: 0x6A, add:        0x6B, 
      separator:  0x6C, substract:  0x6D, decimal:  0x6E, divide:     0x6F, 
      
      f1: 0x70, f2: 0x71, f3: 0x72, f4: 0x73, f5: 0x74, f6: 0x75, f7: 0x76, 
      f8: 0x77, f9: 0x78, f10: 0x79,  f11: 0x7A, f12: 0x7B, 
      
      num_lock: 0x90, scroll_lock: 0x91, 
      
      lshift: 0xA0, rshift: 0xA1, lcontrol: 0xA2, rcontrol: 0xA3, lmenu: 0xA4,
      rmenu:  0xA5, 
      
      circumflex: 0xDD, dollar:     0xBA, close_parenthesis: 0xDB, 
      u_grav:     0xC0, square:     0xDE, less_than:         0xE2, 
      colon:      0xBF, semicolon:  0xBE, equal:             0xBB, 
      comma:      0xBC,
      :DOWN => 1000, :LEFT => 1001, :RIGHT => 1002, :UP => 1003, 
      :A => 1004, :B => 1005, :C => 1006, :X => 1007, :Y => 1008, :Z => 1009, :L => 1010, :R => 1011, 
      :SHIFT => 1011, :CTRL => 1012, :ALT => 1013,
      :F5 => 1014, :F6 => 1015, :F7 => 1016, :F8 => 1017, :F9 => 1018
    }
    #--------------------------------------------------------------------------
    # * Togglable keys
    #--------------------------------------------------------------------------
    TOGGLABLE = [Keys[:caps_lock], Keys[:num_lock], Keys[:scroll_lock]]
    #--------------------------------------------------------------------------
    # * Object initialize
    #--------------------------------------------------------------------------
    def initialize
      @count = Array.new{}
      @release = Array.new{}
      setup_keys
    end
    #--------------------------------------------------------------------------
    # * Setup keys
    #--------------------------------------------------------------------------
    def setup_keys
      @keys = Array.new
    end
    #--------------------------------------------------------------------------
    # * Update Press Statement
    #--------------------------------------------------------------------------
    def update_press
      @keys.each do |key_code|
        @count[key_code] ||= 0
        if key_pushable?(key_code)
          @count[key_code] += 1
        elsif @count[key_code] != 0
          @count[key_code] = 0
          @release << key_code
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Update Device Statement
    #--------------------------------------------------------------------------
    def update
      @release.clear
      update_press
    end
    #--------------------------------------------------------------------------
    # * Define device keys
    #--------------------------------------------------------------------------
    def define_keys(*args)
      args.each do |key_name|
        @keys << Keys[key_name]
      end
    end
    #--------------------------------------------------------------------------
    # * Determine if a key 's pushable
    #--------------------------------------------------------------------------
    def key_pushable?(key); false; end
    #--------------------------------------------------------------------------
    # * Determine if a key 's toogle
    #--------------------------------------------------------------------------
    def key_togglable?(key); false; end
    #--------------------------------------------------------------------------
    # * Determine if key's trigged
    #--------------------------------------------------------------------------
    def key_trigger?(code); @count[Keys[code]] == 1; end
    #--------------------------------------------------------------------------
    # * Determine if key's pressed
    #--------------------------------------------------------------------------
    def key_press?(code); @count[Keys[code]] != 0; end
    #--------------------------------------------------------------------------
    # * determine if key release
    #--------------------------------------------------------------------------
    def key_release?(code); @release.include?(Keys[code]); end
    #--------------------------------------------------------------------------
    # * determine duration
    #--------------------------------------------------------------------------
    def time(code); @count[Keys[code]]; end
    #--------------------------------------------------------------------------
    # * determine if key repeat?
    #--------------------------------------------------------------------------
    def key_repeat?(code) 
      @count[Keys[code]] ||= 0
      key_trigger?(code) || (@count[Keys[code]] >= 24 && @count[Keys[code]]%6 == 0)
    end
    #--------------------------------------------------------------------------
    # * determine if key toogle?
    #--------------------------------------------------------------------------
    def key_toggle?(code); key_togglable?(Keys[code]); end
    #--------------------------------------------------------------------------
    # * All
    #--------------------------------------------------------------------------
    def all?(method, *keys)
      keys.all?{|k|self.send(method, k)}
    end
    #--------------------------------------------------------------------------
    # * Any
    #--------------------------------------------------------------------------
    def any?(method, *keys)
      keys = (keys.length == 0) ? Keys.keys : keys
      keys.any?{|k|self.send(method, k)}
    end
    #--------------------------------------------------------------------------
    # * Current key
    #--------------------------------------------------------------------------
    def current_key(method = :press?)
      f = nil
      @keys.each do |k|
        next unless k
        key = Keys.key(k)
        f = key if self.send(method, key)
      end
      return f
    end
    #--------------------------------------------------------------------------
    # * Alias
    #--------------------------------------------------------------------------
    alias :trigger?   :key_trigger?
    alias :press?     :key_press?
    alias :release?   :key_release?
    alias :repeat?    :key_repeat?
    alias :toggle?    :key_toggle?
  end
  
  #==============================================================================
  # ** Keyboard
  #------------------------------------------------------------------------------
  #  Keyboard support
  #==============================================================================
  class Keyboard < Device
    #--------------------------------------------------------------------------
    # * Constants
    #--------------------------------------------------------------------------
    KEY_NUM = [
      :one,       :two,       :three,     :four,      :five,      :six, 
      :seven,     :eight,     :nine,      :num_one,   :num_two,   :num_three, 
      :num_four,  :num_five,  :num_six,   :num_seven, :num_eight, :num_nine
    ]
    DEAD_KEYS = {
      "^"=>{
        "a" => "â", "A" => "Â",
        "e" => "ê", "E" => "Ê", 
        "i" => "î", "I" => "Î",
        "o" => "ô", "O" => "Ô",
        "u" => "û", "U" => "Û",
        " " => "^"
      },
      "¨"=>{
        "a" => "ä", "A" => "Ä",
        "e" => "ë", "E" => "Ë", 
        "i" => "ï", "I" => "Ï",
        "o" => "ö", "O" => "Ö",
        "u" => "ü", "U" => "Ü",
        "y" => "ÿ", " " => "¨"
      },
      "´"=>{
        "a" => "á", "A" => "Á",
        "e" => "é", "E" => "É", 
        "i" => "í", "I" => "Í",
        "o" => "ó", "O" => "Ó",
        "u" => "ú", "U" => "Ú",
        "y" => "ý", "Y" => "Ý",
        " " => "´"
      },
      "`"=>{
        "a" => "à", "A" => "Á",
        "e" => "è", "E" => "É", 
        "i" => "ì", "I" => "Í",
        "o" => "ò", "O" => "Ó",
        "u" => "ù", "U" => "Ú",
        " " => "`"
      },
      "~"=>{
        "a" => "ã", "A" => "Ã",
        "o" => "õ", "O" => "Õ", 
        "n" => "ñ", "N" => "Ñ"
      }
    }
    #--------------------------------------------------------------------------
    # * Public instances variables
    #--------------------------------------------------------------------------
    attr_reader :maj, :caps_lock, :num_lock, :scroll_lock, :alt_gr
    #--------------------------------------------------------------------------
    # * Setup keys
    #--------------------------------------------------------------------------
    def setup_keys
      super
      define_keys :mouse_left, :mouse_right, :mouse_center
      define_keys :backspace, :clear, :enter, :shift, :ctrl, :alt, :pause
      define_keys :caps_lock, :esc, :space, :page_up, :page_down, :end, :home
      define_keys :left, :up, :right, :down, :select, :print, :execute, :help
      define_keys :zero, :one, :two, :three, :four, :five, :six, :seven, :eight, :nine
      define_keys :a, :b, :c, :d, :e, :f, :g, :h, :i, :j, :k, :l, :m, :n, :o, :p, :q
      define_keys :r, :s, :t, :u, :v, :w, :x, :y, :z
      define_keys :lwindow, :rwindow, :apps, :num_zero, :num_one, :num_two, :num_three
      define_keys :num_four, :num_five, :num_six, :num_seven, :num_eight, :num_nine
      define_keys :add, :substract, :divide, :decimal, :multiply, :separator
      define_keys :f1, :f2, :f3, :f4, :f5, :f6, :f7, :f8, :f9, :f10, :f11, :f12
      define_keys :num_lock, :scroll_lock, :lshift, :rshift, :lcontrol, :rcontrol
      define_keys :lmenu, :rmenu, :circumflex, :dollar, :close_parenthesis, :u_grav
      define_keys :square, :less_than, :colon, :semicolon, :equal, :comma, :minus
      define_keys :delete, :snapshot, :insert
      define_keys :DOWN, :LEFT, :RIGHT, :UP, :A, :B, :C, :X, :Y, :Z, :L, :R
      define_keys :SHIFT, :CTRL, :ALT
      define_keys :F5, :F6, :F7, :F8, :F9
    end
    #--------------------------------------------------------------------------
    # * Object initialize
    #--------------------------------------------------------------------------
    def initialize
      super
      @buffer = [].pack('x256')
      @caps_lock = false
      @num_lock = false
      @scroll_lock = false
      @maj = false
      @alt_gr = false
      @wait_char = ""
      @codes = {}
      Keys.each do |i, val|
        @codes[i] = Win32API::MapVirtualKey.(val, 0) if val < 1000
      end
    end
    #--------------------------------------------------------------------------
    # * Keyboard update
    #--------------------------------------------------------------------------
    def update
      super
      update_state
      update_lock
      update_altgr
    end
    #--------------------------------------------------------------------------
    # * Update state
    #--------------------------------------------------------------------------
    def update_state
      Win32API::GetKeyboardState.(@buffer)
    end
    #--------------------------------------------------------------------------
    # * Update lock state
    #--------------------------------------------------------------------------
    def update_lock
      @caps_lock = key_toggle?(:caps_lock)
      @num_lock = key_toggle?(:num_lock)
      @scroll_lock = key_toggle?(:scroll_lock)
      @maj = (@caps_lock) ? !key_press?(:shift) : key_press?(:shift)
    end
    #--------------------------------------------------------------------------
    # * Update altGr state
    #--------------------------------------------------------------------------
    def update_altgr
      if (key_press?(:alt) && key_press?(:lcontrol))
        @alt_gr = true
      else
        @alt_gr = (key_press?(:ctrl) && !key_press?(:lcontrol) && !key_press?(:rcontrol))
      end
    end
    #--------------------------------------------------------------------------
    # * Determine if a key 's pushable
    #--------------------------------------------------------------------------
    def key_pushable?(key_code)
      if key_code >= 1000
        n_code = Keys.index(key_code)
        return Input.press?(n_code)
      end
      @buffer.getbyte(key_code)[7] == 1
    end
    #--------------------------------------------------------------------------
    # * Determine if a key 's toogle
    #--------------------------------------------------------------------------
    def key_togglable?(key_code)
      return @buffer.getbyte(key_code)[0] == 1 if TOGGLABLE.include?(key_code)
      false
    end
    #--------------------------------------------------------------------------
    # * Get the char of a key
    #--------------------------------------------------------------------------
    def char(key)
      return "" if key == :backspace || key == :enter || key == :esc
      out = [].pack('x16')
      size = Win32API::ToUnicode.(Keys[key], 0, @buffer, out, 8, 0)
      return "" if size == 0
      outUTF8 = "\0"*4
      Win32API::WideCharToMultiByte.(65001, 0, out, 1, outUTF8, 4, 0, 0)
      outUTF8.delete!("\0")
      if @wait_char != ""
        if DEAD_KEYS[@wait_char].has_key?(outUTF8)
          outUTF8 = DEAD_KEYS[@wait_char][outUTF8]
          @wait_char = ""
        else
          if DEAD_KEYS.has_key?(outUTF8)
            @wait_char, outUTF8 = outUTF8, @wait_char
          else
            outUTF8 = @wait_char << outUTF8
            @wait_char = ""
          end
        end
      else
        if DEAD_KEYS.has_key?(outUTF8)
          @wait_char = outUTF8
          outUTF8 = ""
        end
      end
      return outUTF8
    end
    #--------------------------------------------------------------------------
    # * Get the current char
    #--------------------------------------------------------------------------
    def letter
      return "" if [:a, :z, :c, :x, :v, :p, :y].any?{|k|ctrl?(k)}
      Keys.keys.each do |i|
        return char(i) if repeat?(i)
      end
      return ""
    end
    #--------------------------------------------------------------------------
    # * Determine number
    #--------------------------------------------------------------------------
    def number
      KEY_NUM.each do |i|
        if repeat?(i)
          c = char(i)
          return (c.to_i.to_s == c) ? c.to_i : nil
        end
      end
      return nil
    end
    #--------------------------------------------------------------------------
    # * Ctrl API
    #--------------------------------------------------------------------------
    def ctrl?(k=nil)
      f = (!k) ? true : trigger?(k)
      return press?(:ctrl) && f
    end
    #--------------------------------------------------------------------------
    # * Alias
    #--------------------------------------------------------------------------
    alias :maj?           :maj
    alias :caps_lock?     :caps_lock
    alias :num_lock?      :num_lock
    alias :scroll_lock?   :scroll_lock
    alias :alt_gr?        :alt_gr
  end
  
  #==============================================================================
  # ** Mouse
  #------------------------------------------------------------------------------
  #  Mouse support
  #==============================================================================
  class Mouse < Device
    #--------------------------------------------------------------------------
    # * Public instances variables
    #--------------------------------------------------------------------------
    attr_reader :x, :y, :x_square, :y_square, :rect, :last_rect
    #--------------------------------------------------------------------------
    # * Setup keys
    #--------------------------------------------------------------------------
    def setup_keys
      super
      define_keys :mouse_left, :mouse_right, :mouse_center
    end
    #--------------------------------------------------------------------------
    # * Object initialize
    #--------------------------------------------------------------------------
    def initialize
      super
      @x = @y = @old_x = @old_y = 0
      @rect, @last_rect = Rect.new(0,0,0,0), Rect.new(0,0,0,0)
    end
    #--------------------------------------------------------------------------
    # * Mouse update
    #--------------------------------------------------------------------------
    def update
      super
      update_position
      update_rect
    end
    #--------------------------------------------------------------------------
    # * Position update
    #--------------------------------------------------------------------------
    def update_position
      @buffer = [0,0].pack('l2')
      @buffer = @buffer.unpack('l2') unless Win32API::GetCursorPos.(@buffer)
      @buffer = @buffer.unpack('l2') if Win32API::ScreenToClient.(RGSSHWND, @buffer)
      @x, @y = *@buffer
      @x_square, @y_square = (@x.to_i/32), (@y.to_i/32)
      if $game_map && SceneManager.scene.is_a?(Scene_Map)
        @x_square += $game_map.display_x
        @y_square += $game_map.display_y
      end
    end
    #--------------------------------------------------------------------------
    # * Rect update
    #--------------------------------------------------------------------------
    def update_rect
      if key_press?(:mouse_left)
        min_x, max_x = [@old_x, @x].sort
        min_y, max_y = [@old_y, @y].sort
        @rect.set(min_x, min_y, (max_x - min_x), (max_x - min_y))
        @last_rect.set(@rect)
      else
        @old_x, @old_y = @x, @y
        @rect.set(0,0,0,0)
      end
    end
    #--------------------------------------------------------------------------
    # * Determine if a key 's pushable
    #--------------------------------------------------------------------------
    def key_pushable?(key_code)
      ::Keyboard.key_pushable?(key_code)
    end
    #--------------------------------------------------------------------------
    # * Set the windows cursor (or not)
    #--------------------------------------------------------------------------
    def show_cursor_system(flag)
      flag = (flag.to_bool) ? 1 : 0
      Win32API::ShowCursor.(flag)
      return flag
    end
    #--------------------------------------------------------------------------
    # * Alias
    #--------------------------------------------------------------------------
    alias :click? :key_press?
  end
end

#==============================================================================
# ** Kernel
#------------------------------------------------------------------------------
#  Object class methods are defined in this module. 
#  This ensures compatibility with top-level method redefinition.
#==============================================================================

module Kernel
  #--------------------------------------------------------------------------
  # * Constants
  #--------------------------------------------------------------------------
  RGSSHWND      = Win32API::FindWindow.('RGSS Player', 0)
  USERNAME      = ENV['USERNAME'].dup.to_utf8
  Clipboard     = UI::Clipboard
  FORMAT        = Clipboard.get_format("VX Ace EVENT_COMMAND")
  Keyboard      = UI::Keyboard.new
  Mouse         = UI::Mouse.new
  #--------------------------------------------------------------------------
  # * RPG Datas Structure
  #--------------------------------------------------------------------------
  RPGDatas = {
    actors:       "Actors", 
    classes:      "Classes",
    skills:       "Skills",
    items:        "Items",
    weapons:      "Weapons",
    armors:       "Armors",
    enemies:      "Enemies",
    troops:       "Troops",
    states:       "States",
    animations:   "Animations",
    tilesets:     "Tilesets",
    common_events:"CommonEvents",
    system:       "System",
    mapinfos:     "MapInfos"
  }
  #--------------------------------------------------------------------------
  # * API for command handling
  #--------------------------------------------------------------------------
  def command(name, *args)
    method_name = name.to_sym
    Command.send(method_name, *args)
  end
  #--------------------------------------------------------------------------
  # * API for category description
  #--------------------------------------------------------------------------
  def register_category(*args)
    Command::Description.register_category(*args)
  end
  #--------------------------------------------------------------------------
  # * API for command description
  #--------------------------------------------------------------------------
  def import_command(*args)
    Command::Description.import(*args)
  end
  #--------------------------------------------------------------------------
  # * Alias
  #--------------------------------------------------------------------------
  alias :cmd  :command
  alias :c    :command
  #--------------------------------------------------------------------------
  # * All selector
  #--------------------------------------------------------------------------
  def all_events
    events(:all_events)
  end
  #--------------------------------------------------------------------------
  # * Selectors
  #--------------------------------------------------------------------------
  def events(*ids, &block)
    return [] unless SceneManager.scene.is_a?(Scene_Map)
    if ids.length == 1 && ids[0] == :all_events
      return $game_map.each_events.values.dup
    end
    result = []
    ids.each{|id| result << $game_map.each_events[id] if $game_map.each_events[id]}
    result += $game_map.each_events.values.select(&block) if block_given?
    result
  end
  #--------------------------------------------------------------------------
  # * Trigger
  #--------------------------------------------------------------------------
  def trigger(&block)
    block
  end
  #--------------------------------------------------------------------------
  # * Alias
  #--------------------------------------------------------------------------
  alias :e        :events
  alias :listener :trigger
  #--------------------------------------------------------------------------
  # * Switch Activation/Desactivation
  #--------------------------------------------------------------------------
  def on;   true;   end
  def off;  false;  end
end

#==============================================================================
# ** Input
#------------------------------------------------------------------------------
#  A module that handles input data from a gamepad or keyboard.
#==============================================================================

module Input 
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  class << self
    #--------------------------------------------------------------------------
    # * Alias
    #--------------------------------------------------------------------------
    alias :extender_update :update
    #--------------------------------------------------------------------------
    # * Input Update
    #--------------------------------------------------------------------------
    def update
      Keyboard.update
      Mouse.update
      extender_update
    end
  end
end

#==============================================================================
# ** Handler
#------------------------------------------------------------------------------
#  Custom Event Handler
#==============================================================================

module Handler
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  class << self
    #--------------------------------------------------------------------------
    # * Public instance variable
    #--------------------------------------------------------------------------
    attr_accessor :std_triggers
    Handler.std_triggers = [
      :hover,
      :click,
      :trigger,
      :release,
      :repeat
    ] 
  end
  #--------------------------------------------------------------------------
  # * Event behaviour
  #--------------------------------------------------------------------------
  module Behaviour
    #--------------------------------------------------------------------------
    # * Setup Event Handler
    #--------------------------------------------------------------------------
    def setup_eHandler
      @__std_triggers = {
        hover:    nil,
        click:    nil,
        trigger:  nil,
        release:  nil, 
        repeat:   nil
      }
      @__cst_triggers = {}
      @table_triggers = {
        hover:    method(:hover?),
        click:    method(:click?),
        trigger:  method(:trigger?),
        release:  method(:release?),
        repeat:   method(:repeat?)
      }
    end
    #--------------------------------------------------------------------------
    # * Unbinding process
    #--------------------------------------------------------------------------
    def unbind(key = nil)
      unless key
        setup_eHandler
        return
      end
      if(Handler.std_triggers.include?(key))
        @__std_triggers[key.to_sym] = nil
        return
      end
      @__cst_triggers[key.to_sym] = nil if @__cst_triggers[key.to_sym]
    end
    #--------------------------------------------------------------------------
    # * Binding event
    #--------------------------------------------------------------------------
    def bind(key, *args, &block)
      if(Handler.std_triggers.include?(key))
        ntriggers = args[0] || -1
        @__std_triggers[key.to_sym] = {
          fun:        block,
          ntriggers:  ntriggers
        }
        return
      end
      trigger = args[0]
      ntriggers = args[1] || -1
      @__cst_triggers[key.to_sym] = {
        trigger:    trigger,
        fun:        block,
        ntriggers:  ntriggers
      }
    end
    #--------------------------------------------------------------------------
    # * Update events
    #--------------------------------------------------------------------------
    def update_eHandler
      @__std_triggers.each do |key, event|
        if event && event[:ntriggers] != 0
          if @table_triggers[key] && @table_triggers[key].()
            event[:fun].(self)
            event[:ntriggers] -= 1 if event[:ntriggers] != -1
          end
        end
      end
      @__cst_triggers.each do |key, event|
        if event
          if event[:ntriggers] != 0
            event[:fun].(self) if event[:trigger].(self)
            event[:ntriggers] -= 1 if event[:ntriggers] != -1
          else
            event = nil
          end
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Hover
    #--------------------------------------------------------------------------
    def hover?
      @rect.hover?
    end
    #--------------------------------------------------------------------------
    # * Click
    #--------------------------------------------------------------------------
    def click?(key = :mouse_left)
      @rect.click?(key)
    end
    #--------------------------------------------------------------------------
    # * Trigger
    #--------------------------------------------------------------------------
    def trigger?(key = :mouse_left)
      @rect.trigger?(key)
    end
    #--------------------------------------------------------------------------
    # * Repeat
    #--------------------------------------------------------------------------
    def repeat?(key = :mouse_left)
      @rect.repeat?(key)
    end
    #--------------------------------------------------------------------------
    # * Release
    #--------------------------------------------------------------------------
    def release?(key = :mouse_left)
      @rect.release?(key)
    end
  end
  #==============================================================================
  # ** API
  #------------------------------------------------------------------------------
  #  Command handling
  #==============================================================================
  module API
    #--------------------------------------------------------------------------
    # * Binding
    #--------------------------------------------------------------------------
    def bind(e, *args, &block)
      e = Kernel.events(e) if e.is_a?(Fixnum)
      e.each{|ev|ev.bind(*args, &block)}
    end
    #--------------------------------------------------------------------------
    # * UnBinding
    #--------------------------------------------------------------------------
    def unbind(e, k=nil)
      e = Kernel.events(e) if e.is_a?(Fixnum)
      e.each{|ev|ev.unbind(k)}
    end
    #--------------------------------------------------------------------------
    # * Mouse Hover Event
    #--------------------------------------------------------------------------
    def mouse_hover_event?(e)
      e = Kernel.events(e) if e.is_a?(Fixnum)
      e.any?{|ev| ev.hover?}
    end
    #--------------------------------------------------------------------------
    # * clicked event
    #--------------------------------------------------------------------------
    def mouse_click_event?(e, k=:mouse_left)
      e = Kernel.events(e) if e.is_a?(Fixnum)
      e.any?{|ev| ev.click?(k)}
    end
    #--------------------------------------------------------------------------
    # * Triggered event
    #--------------------------------------------------------------------------
    def mouse_trigger_event?(e, k=:mouse_left)
      e = Kernel.events(e) if e.is_a?(Fixnum)
      e.any?{|ev| ev.trigger?(k)}
    end
    #--------------------------------------------------------------------------
    # * Repeated event
    #--------------------------------------------------------------------------
    def mouse_repeat_event?(e, k=:mouse_left)
      e = Kernel.events(e) if e.is_a?(Fixnum)
      e.any?{|ev| ev.repeat?(k)}
    end
    #--------------------------------------------------------------------------
    # * Released event
    #--------------------------------------------------------------------------
    def mouse_release_event?(e, k=:mouse_left)
      e = Kernel.events(e) if e.is_a?(Fixnum)
      e.any?{|ev| ev.release?(k)}
    end
    #--------------------------------------------------------------------------
    # * Load Commands
    #--------------------------------------------------------------------------
    append_commands
  end
end

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  This module manages the database and game objects. Almost all of the 
# global variables used by the game are initialized by this module.
#==============================================================================

module DataManager
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  class << self
    #--------------------------------------------------------------------------
    # * Get Path
    #--------------------------------------------------------------------------
    def data_path; $EDITOR ? '../Data/' : 'Data/'; end
    #--------------------------------------------------------------------------
    # * Get Statics Datas
    #--------------------------------------------------------------------------
    RPGDatas.each do |k, m|
      define_method(k) do
        load_data(data_path + m + ".rvdata2")
      end
    end
  end
end

#==============================================================================
# ** Scene_Base
#------------------------------------------------------------------------------
#  This is a super class of all scenes within the game.
#==============================================================================

class Scene_Base
  #--------------------------------------------------------------------------
  # * alias
  #--------------------------------------------------------------------------
  alias :extender_base_terminate :terminate
  #--------------------------------------------------------------------------
  # * Create White BG
  #--------------------------------------------------------------------------
  def create_blank_bg
    @blank_bg = Sprite.new
    @blank_bg.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @blank_bg.bitmap.fill_rect(0,0,Graphics.width, Graphics.height, Color.new(*[255]*3))
  end
  #--------------------------------------------------------------------------
  # * Terminate
  #--------------------------------------------------------------------------
  def terminate
    extender_base_terminate
    @blank_bg.dispose if @blank_bg
  end
end

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================

class Scene_Map
  #--------------------------------------------------------------------------
  # * Public instance variable
  #--------------------------------------------------------------------------
  attr_reader :spriteset
end

#==============================================================================
# ** Game_Screen
#------------------------------------------------------------------------------
#  This class handles screen maintenance data, such as changes in color tone,
# flashes, etc. It's used within the Game_Map and Game_Troop classes.
#==============================================================================

class Game_Screen
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader :tone_duration
end

#==============================================================================
# ** Game_Message
#------------------------------------------------------------------------------
#  This class handles the state of the message window that displays text or
# selections, etc. The instance of this class is referenced by $game_message.
#==============================================================================

class Game_Message
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :call_event
end

#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * Public instance variable
  #--------------------------------------------------------------------------
  attr_accessor :interpreter
  attr_reader   :each_events
  #--------------------------------------------------------------------------
  # * alias
  #--------------------------------------------------------------------------
  alias :extender_setup_events :setup_events
  #--------------------------------------------------------------------------
  # * Event Setup
  #--------------------------------------------------------------------------
  def setup_events
    extender_setup_events
    @each_events = {0=>$game_player}.merge(@events)
  end
end

#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  This base class handles characters. It retains basic information, such as 
# coordinates and graphics, shared by all characters.
#==============================================================================

class Game_CharacterBase
  #--------------------------------------------------------------------------
  # * alias
  #--------------------------------------------------------------------------
  alias :extender_initialize          :initialize
  alias :extender_init_public_members :init_public_members
  alias :extender_update              :update
  #--------------------------------------------------------------------------
  # * Public instance variable
  #--------------------------------------------------------------------------
  attr_reader :rect
  #--------------------------------------------------------------------------
  # * Event Handling
  #--------------------------------------------------------------------------
  include Handler::Behaviour
  #--------------------------------------------------------------------------
  # * Object initialize
  #--------------------------------------------------------------------------
  def initialize
    extender_initialize
    @rect = Rect.new(0,0,0,0)
  end
  #--------------------------------------------------------------------------
  # * Initialize Public Member Variables
  #--------------------------------------------------------------------------
  def init_public_members
    extender_init_public_members
    setup_eHandler
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    extender_update
    update_eHandler
  end
end

#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class handles events. Functions include event page switching via
# condition determinants and running parallel process events. Used within the
# Game_Map class.
#==============================================================================

class Game_Event
  #--------------------------------------------------------------------------
  # * Alias
  #--------------------------------------------------------------------------
  alias :extender_conditions_met?  :conditions_met?
  #--------------------------------------------------------------------------
  # * Determine if Event Page Conditions Are Met
  #--------------------------------------------------------------------------
  def conditions_met?(page)
    value = extender_conditions_met?(page)
    first = first_is_trigger?(page)
    return value unless first
    return value && first.()
  end
  #--------------------------------------------------------------------------
  # * Determine if the first command is a Trigger
  #--------------------------------------------------------------------------
  def first_is_trigger?(page)
    return false unless page || page.list || page.list[0]
    return false unless page.list[0].code == 355
    index = 0
    script = page.list[index].parameters[0] + "\n"
    while page.list[index].code == 655
      index += 1
      script += page.list[index].parameters[0] + "\n"
    end
    if script =~ /^(trigger|listener)/
      potential_trigger = eval(script, $game_map.interpreter.get_binding)
      return potential_trigger if potential_trigger.is_a?(Proc)
    end
    return false
  end
end

#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
#  This sprite is used to display characters. It observes an instance of the
# Game_Character class and automatically changes sprite state.
#==============================================================================

class Sprite_Character
  #--------------------------------------------------------------------------
  # * Alias
  #--------------------------------------------------------------------------
  alias :extender_update      :update
  alias :extender_initialize  :initialize
  #--------------------------------------------------------------------------
  # * Object initialization
  #--------------------------------------------------------------------------
  def initialize(viewport, character = nil)
    extender_initialize(viewport, character)
    set_rect
  end
  #--------------------------------------------------------------------------
  # * Set rect to dynamic layer
  #--------------------------------------------------------------------------
  def set_rect
    if character
      x_rect, y_rect = self.x-self.ox, self.y-self.oy
      w_rect, h_rect = self.src_rect.width, self.src_rect.height
      character.rect.set(x_rect, y_rect, w_rect, h_rect)
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    extender_update
    set_rect
  end
end

#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc. It's used
# within the Scene_Map class.
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # * Public instance variable
  #--------------------------------------------------------------------------
  attr_reader :tilemap
end

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  An interpreter for executing event commands. This class is used within the
# Game_Map, Game_Troop, and Game_Event classes.
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Alias
  #--------------------------------------------------------------------------
  alias extender_command_101 command_101
  alias extender_command_111 command_111
  alias extender_command_105 command_105
  alias extender_command_355 command_355 
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  class << self
    #--------------------------------------------------------------------------
    # * Public instances variables
    #--------------------------------------------------------------------------
    attr_accessor :current_id
    attr_accessor :current_map_id
  end
  #--------------------------------------------------------------------------
  # * Show Text
  #--------------------------------------------------------------------------
  def command_101
    $game_message.call_event = @id
    extender_command_101
  end
  #--------------------------------------------------------------------------
  # * Show Scrolling Text
  #--------------------------------------------------------------------------
  def command_105
    $game_message.call_event = @id
    extender_command_105
  end
  #--------------------------------------------------------------------------
  # * Append Interpreter
  #--------------------------------------------------------------------------
  def append_interpreter(map_id, id, page_id)
    map = load_data(sprintf("Data/Map%03d.rvdata2", map_id))
    return unless map
    event = map.events[id]
    return unless event
    page = event.pages[page_id-1]
    return unless page
    list = page.list
    child = Game_Interpreter.new(@depth + 1)
    child.setup(list, same_map? ? @id : 0)
    child.run
  end
  #--------------------------------------------------------------------------
  # * Conditional Branch
  #--------------------------------------------------------------------------
  def command_111
    Game_Interpreter.current_id = @id
    Game_Interpreter.current_map_id = @map_id
    extender_command_111
  end
  #--------------------------------------------------------------------------
  # * Script
  #--------------------------------------------------------------------------
  def command_355
    Game_Interpreter.current_id = @id
    Game_Interpreter.current_map_id = @map_id
    extender_command_355
  end
  #--------------------------------------------------------------------------
  # * Add command API
  #--------------------------------------------------------------------------
  include_commands
  #--------------------------------------------------------------------------
  # * Get Binding
  #--------------------------------------------------------------------------
  def get_binding; binding; end
end

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
# Data of save manager
#==============================================================================

module DataManager
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  class << self
    #--------------------------------------------------------------------------
    # * Alias
    #--------------------------------------------------------------------------
    alias extender_create_game_objects create_game_objects
    alias extender_make_save_contents make_save_contents
    alias extender_extract_save_contents extract_save_contents
    #--------------------------------------------------------------------------
    # * Creates the objects of the game
    #--------------------------------------------------------------------------
    def create_game_objects
      extender_create_game_objects
      $game_self_vars = Hash.new
    end
    #--------------------------------------------------------------------------
    # * Saves the contents of the game
    #--------------------------------------------------------------------------
    def make_save_contents
      contents = extender_make_save_contents
      contents[:self_vars] = $game_self_vars
      contents
    end
    #--------------------------------------------------------------------------
    # * Load a save
    #--------------------------------------------------------------------------
    def extract_save_contents(contents)
      extender_extract_save_contents(contents)
      $game_self_vars = contents[:self_vars]
    end
  end
end