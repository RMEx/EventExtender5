=begin
 Event Extender 5
 Graphics Module
 Access to graphics components
 ===============================================================================
 http://www.biloucorp.com
 ===============================================================================
 By Grim 
=end


#==============================================================================
# ** Marshal implementations in Font & Bitmap.
#------------------------------------------------------------------------------
#  Writed by Yeyinde
#  Improved by Grim (FunkyWork)
#==============================================================================

class Font
  def marshal_dump;end
  def marshal_load(obj);end
end

#==============================================================================
# ** Marshal implementations in Font & Bitmap.
#------------------------------------------------------------------------------
#  Writed by Yeyinde
#  Improved by Grim 
#==============================================================================

class Bitmap
  #--------------------------------------------------------------------------
  # * Marshall dump
  #--------------------------------------------------------------------------
  def _dump(limit)
    data = "rgba"*width*height
    Win32API::RtlMoveMemorySave.call(data,address,data.length)
    [width,height,Zlib::Deflate.deflate(data)].pack("LLa*")
  end
  #--------------------------------------------------------------------------
  # * Marshall load
  #--------------------------------------------------------------------------
  def self._load(str)
    w,h,zdata = str.unpack("LLa*")
    bitmap = new(w,h)
    Win32API::RtlMoveMemoryLoad.call(bitmap.address,Zlib::Inflate.inflate(zdata),w*h*4)
    return bitmap
  end
  #--------------------------------------------------------------------------
  # * Give Memory Adress
  #--------------------------------------------------------------------------
  def address
    buffer,ad="xxxx",object_id*2+16
    Win32API::RtlMoveMemorySave.call(buffer,ad,4)
    ad=buffer.unpack("L")[0]+8
    Win32API::RtlMoveMemorySave.call(buffer,ad,4)
    ad=buffer.unpack("L")[0]+16
    Win32API::RtlMoveMemorySave.call(buffer,ad,4)
    buffer.unpack("L")[0]
  end
  #--------------------------------------------------------------------------
  # * Give Pointer
  #--------------------------------------------------------------------------
  def pointer
    (self.__id__) << 1
  end
end


#==============================================================================
# ** Sprite_Line
#------------------------------------------------------------------------------
# Display Line
#==============================================================================

class Sprite_Line < Sprite
  #--------------------------------------------------------------------------
  # * Private methods
  #--------------------------------------------------------------------------
  private :zoom_x
  private :zoom_y
  private :x 
  private :y
  private :ox
  private :oy
  #--------------------------------------------------------------------------
  # * Public instances variables
  #--------------------------------------------------------------------------
  attr_reader :height
  attr_reader :width
  attr_reader :color
  attr_reader :origin
  attr_reader :destination
  #--------------------------------------------------------------------------
  # * Object Initialize
  #--------------------------------------------------------------------------
  def initialize(xa, ya, xb, yb, len, color, *viewport)
    super(*viewport)
    @width        = len 
    @color        = color
    @origin       = [xa, ya]
    @destination  = [xb, yb]
    calc_origin
    create_bitmap
    change_line_form
  end
  #--------------------------------------------------------------------------
  # * Get Origin
  #--------------------------------------------------------------------------
  def calc_origin
    self.ox       =  @width / 2
    self.x,self.y = *@origin
  end
  #--------------------------------------------------------------------------
  # * Coords
  #--------------------------------------------------------------------------
  def group_coords
    xa, ya  = *@origin
    xb, yb  = *@destination
    return (xa-xb), (ya-yb)
  end
  #--------------------------------------------------------------------------
  # * Height informations
  #--------------------------------------------------------------------------
  def calc_height
    @height =  Math.hypot(*group_coords).to_i
  end
  #--------------------------------------------------------------------------
  # * Build Bitmap
  #--------------------------------------------------------------------------
  def create_bitmap
    self.bitmap = Bitmap.new(@width, 1)
    self.bitmap.fill_rect(0, 0, @width, 1, @color)
  end
  #--------------------------------------------------------------------------
  # * Zoom calculation
  #--------------------------------------------------------------------------
  def process_zoom
    xa, ya = *@origin
    xb, yb = *@destination
    self.zoom_y = @height.to_f
    if xa == xb && yb > ya
      self.angle = 180
    elsif xa == xb
      self.angle = 0
    elsif ya == yb && xb > xa
      self.angle = 90
    elsif ya == yb 
      self.angle = 270
    else
      self.angle  = ((Math.atan2(*group_coords))*(180.0/Math::PI))-180
    end 
  end
  #--------------------------------------------------------------------------
  # * General
  #--------------------------------------------------------------------------
  def change_line_form
    calc_height
    process_zoom
  end
  #--------------------------------------------------------------------------
  # * Dest changement
  #--------------------------------------------------------------------------
  def set_destination(x, y)
    @destination = [x, y]
    change_line_form
  end
  #--------------------------------------------------------------------------
  # * Orig changement
  #--------------------------------------------------------------------------
  def set_origin(x, y)
    @origin       = [x, y]
    self.x,self.y = *@origin
    change_line_form
  end
end

#==============================================================================
# ** Game_Picture
#------------------------------------------------------------------------------
#  This class handles pictures. It is created only when a picture of a specific
# number is required internally for the Game_Pictures class.
#==============================================================================

class Game_Picture
  #--------------------------------------------------------------------------
  # * Alias
  #--------------------------------------------------------------------------
  alias :ee_gfx_initialize  :initialize
  alias :ee_gfx_show        :show
  alias :ee_gfx_update      :update
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor  :number                   # picture index
  attr_accessor  :name                     # filename
  attr_accessor  :origin                   # starting point
  attr_accessor  :x                        # x-coordinate
  attr_accessor  :y                        # y-coordinate
  attr_accessor  :zoom_x                   # x directional zoom rate
  attr_accessor  :zoom_y                   # y directional zoom rate
  attr_accessor  :opacity                  # opacity level
  attr_accessor  :blend_type               # blend method
  attr_accessor  :tone                     # color tone
  attr_accessor  :angle                    # rotation angle
  attr_accessor  :pin
  attr_accessor  :shake
  attr_accessor  :mirror
  attr_accessor  :wave_amp
  attr_accessor  :wave_speed
  attr_accessor  :target_x, :target_y, :target_zoom_x, :target_zoom_y
  attr_accessor  :target_opacity
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(number)
    ee_gfx_initialize(number)
    clear_effects
  end
  #--------------------------------------------------------------------------
  # * Clear effects
  #--------------------------------------------------------------------------
  def clear_effects
    @mirror = false
    @wave_amp = @wave_speed = 0
    @pin = false
    clear_shake
  end
  #--------------------------------------------------------------------------
  # * Show Picture
  #--------------------------------------------------------------------------
  def show(name, origin, x, y, zoom_x, zoom_y, opacity, blend_type)
    ee_gfx_show(name, origin, x, y, zoom_x, zoom_y, opacity, blend_type)
    clear_effects
  end
  #--------------------------------------------------------------------------
  # * Clear Shake
  #--------------------------------------------------------------------------
  def clear_shake
    @shake_power = 0
    @shake_speed = 0
    @shake_duration = 0
    @shake_direction = 1
    @shake = 0
  end
  #--------------------------------------------------------------------------
  # * Start Shaking
  #     power: intensity
  #     speed: speed
  #--------------------------------------------------------------------------
  def start_shake(power, speed, duration)
    @shake_power = power
    @shake_speed = speed
    @shake_duration = duration
  end
  #--------------------------------------------------------------------------
  # * Update Shake
  #--------------------------------------------------------------------------
  def update_shake
    if @shake_duration > 0 || @shake != 0
      delta = (@shake_power * @shake_speed * @shake_direction) / 10.0
      if @shake_duration <= 1 && @shake * (@shake + delta) < 0
        @shake = 0
      else
        @shake += delta
      end
      @shake_direction = -1 if @shake > @shake_power * 2
      @shake_direction = 1 if @shake < - @shake_power * 2
      @shake_duration -= 1
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    ee_gfx_update
    update_shake
  end
end

#==============================================================================
# ** Sprite_Picture
#------------------------------------------------------------------------------
#  This sprite is used to display pictures. It observes an instance of the
# Game_Picture class and automatically changes sprite states.
#==============================================================================

class Sprite_Picture
  #--------------------------------------------------------------------------
  # * Alias
  #--------------------------------------------------------------------------
  alias ee_gfx_update update
  alias ee_gfx_update_origin update_origin
  #--------------------------------------------------------------------------
  # * Get cache
  #--------------------------------------------------------------------------
  def swap_cache(name)
    if /^(\/Pictures|Pictures)\/(.*)/ =~ name
      return Cache.picture($2)
    end
    if /^(\/Battlers|Battlers)\/(.*)/ =~ name
      return Cache.battler($2, 0)
    end
    if /^(\/Battlebacks1|Battlebacks1)\/(.*)/ =~ name
      return Cache.battleback1($2)
    end
    if /^(\/Battlebacks2|Battlebacks2)\/(.*)/ =~ name
      return Cache.battleback2($2)
    end
    if /^(\/Parallaxes|Parallaxes)\/(.*)/ =~ name
      return Cache.parallax($2)
    end
    if /^(\/Titles1|Titles1)\/(.*)/ =~ name
      return Cache.title1($2)
    end
    if /^(\/Titles2|Titles2)\/(.*)/ =~ name
      return Cache.title2($2)
    end
    return Cache.picture(name)
  end
  #--------------------------------------------------------------------------
  # * Update Transfer Origin Bitmap
  #--------------------------------------------------------------------------
  def update_bitmap
    if @picture.name.empty?
      self.bitmap = nil
    else
      self.bitmap = swap_cache(@picture.name)
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    ee_gfx_update
    self.mirror = !self.mirror if @picture.mirror != self.mirror
    self.wave_amp = @picture.wave_amp if @picture.wave_amp != self.wave_amp
    self.wave_speed = @picture.wave_speed if @picture.wave_speed != self.wave_speed
  end
  #--------------------------------------------------------------------------
  # * Update Position
  #--------------------------------------------------------------------------
  def update_position
    if @picture.pin
      self.x = @picture.x - ($game_map.display_x * 32) + @picture.shake
      self.y = @picture.y - ($game_map.display_y * 32)
    else
      self.x = @picture.x + @picture.shake
      self.y = @picture.y
    end
    self.z = @picture.number
  end
  #--------------------------------------------------------------------------
  # * Update Origin
  #--------------------------------------------------------------------------
  def update_origin
    if @picture.origin.is_a?(Array)
      x, y = @picture.origin
      self.ox, self.oy = x, y
    else
      ee_gfx_update_origin
    end
  end
end  

#==============================================================================
# ** API
#------------------------------------------------------------------------------
#  Insert command
#==============================================================================

module GFXApi
  #--------------------------------------------------------------------------
  # * Private Commands
  #--------------------------------------------------------------------------
  def screen; $game_party.in_battle ? $game_troop.screen : $game_map.screen end
  def pictures; screen.pictures; end
  private :screen, :pictures
  #--------------------------------------------------------------------------
  # * Pictures commands
  #--------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  # * Show a picture
  # Origin : 0 | 1 (0 = Corner High Left, 1 = Center)
  # Blend_type : 0 (normal)
  #--------------------------------------------------------------------------
  def picture_show(id, n, x=0, y=0, ori=0,  z_x=100, z_y=100, op=255, bl=0)
    pictures[id].show(n, ori, x, y, z_x, z_y, op, bl)
  end
  #--------------------------------------------------------------------------
  # * Modify Origin
  # Origin : 0 | 1 (0 = Corner High Left, 1 = Center)
  #--------------------------------------------------------------------------
  def picture_origin(id, *origin)
    origin = origin[0] if origin.length == 1
    pictures[id].origin = origin
  end
  #--------------------------------------------------------------------------
  # * Modify x position
  #--------------------------------------------------------------------------
  def picture_x(id, x=false)
    return pictures[id].x unless x
    pictures[id].x = x
  end
  #--------------------------------------------------------------------------
  # * Modify y position
  #--------------------------------------------------------------------------
  def picture_y(id, y=false)
    return pictures[id].y unless y
    pictures[id].y = y
  end
  #--------------------------------------------------------------------------
  # * Modify position
  #--------------------------------------------------------------------------
  def picture_position(id, x, y)
    picture_x(id, x)
    picture_y(id, y)
  end
  #--------------------------------------------------------------------------
  # * Move picture
  #--------------------------------------------------------------------------
  def picture_move(id, x, y, zoom_x, zoom_y, duration, opacity=-1, blend_type=-1, origin=-1)
    picture = pictures[id]
    opacity = (opacity == -1) ? picture.opacity : opacity
    blend_type = (blend_type == -1) ? picture.blend_type : blend_type
    origin = (origin == -1) ? picture.origin : origin
    picture.move(origin, x, y, zoom_x, zoom_y, opacity, blend_type, duration)
  end
  #--------------------------------------------------------------------------
  # * Modify wave
  #--------------------------------------------------------------------------
  def picture_wave(id, amp, speed)
    pictures[id].wave_amp = amp
    pictures[id].wave_speed = speed
  end
  #--------------------------------------------------------------------------
  # * Apply Mirror
  #--------------------------------------------------------------------------
  def picture_flip(id)
    pictures[id].mirror = !pictures[id].mirror
  end
  #--------------------------------------------------------------------------
  # * Modify Angle
  #--------------------------------------------------------------------------
  def picture_angle(id, angle=false)
    return pictures[id].angle unless angle
    pictures[id].angle = angle%360
  end
  #--------------------------------------------------------------------------
  # * Rotate
  #--------------------------------------------------------------------------
  def picture_rotate(id, speed)
    pictures[id].rotate(speed)
  end
  #--------------------------------------------------------------------------
  # * change Zoom X
  #--------------------------------------------------------------------------
  def picture_zoom_x(id, zoom_x=false)
    return pictures[id].zoom_x unless zoom_x
    pictures[id].zoom_x = zoom_x
  end
  #--------------------------------------------------------------------------
  # * change Zoom Y
  #--------------------------------------------------------------------------
  def picture_zoom_y(id, zoom_y=false)
    return pictures[id].zoom_y unless zoom_y
    pictures[id].zoom_y = zoom_y
  end
  #--------------------------------------------------------------------------
  # * change Zoom
  #--------------------------------------------------------------------------
  def picture_zoom(id, zoom_x, zoom_y = -1)
    zoom_y = zoom_x if zoom_y == -1
    picture_zoom_x(id, zoom_x)
    picture_zoom_y(id, zoom_y)
  end
  #--------------------------------------------------------------------------
  # * change Tone
  #--------------------------------------------------------------------------
  def picture_tone(id, *args)
    case args.length
    when 1; 
      tone = args[0]
      duration = 0
    else
      r, g, b = args[0], args[1], args[2]
      gray = args[3] || 0
      tone = Tone.new(r, g, b, gray)
      duration = args[3] || 0
    end
    pictures[id].start_tone_change(tone, duration)
  end
  #--------------------------------------------------------------------------
  # * Change blend type
  #--------------------------------------------------------------------------
  def picture_blend(id, blend)
    blend_type = 0
    blend_type = blend if [0,1,2].include?(blend)
    pictures[id].blend_type = blend_type
  end
  #--------------------------------------------------------------------------
  # * Pin picture on the map
  #--------------------------------------------------------------------------
  def picture_pin(id)
    pictures[id].pin = true
  end
  #--------------------------------------------------------------------------
  # * Pin picture on the map
  #--------------------------------------------------------------------------
  def picture_detach(id)
    pictures[id].pin = false
  end
  #--------------------------------------------------------------------------
  # * Change Picture Opacity
  #--------------------------------------------------------------------------
  def picture_opacity(id, value)
    pictures[id].opacity = value
  end
  #--------------------------------------------------------------------------
  # * Shake the picture
  #--------------------------------------------------------------------------
  def picture_shake(id, power, speed, duration)
    pictures[id].start_shake(power, speed, duration)
  end
  #--------------------------------------------------------------------------
  # * Erase a picture
  #--------------------------------------------------------------------------
  def picture_erase(id)
    pictures[id].erase
  end
  #--------------------------------------------------------------------------
  # * Load commands
  #--------------------------------------------------------------------------
  append_commands
end
