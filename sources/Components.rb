=begin
 Event Extender 5
 Components Module
 GUI and other
 ===============================================================================
 http://www.biloucorp.com
 ===============================================================================
 By Hiino, Nuki, Grim, Joke
 Thanks to ZEUS81, Zangther, XHTMLBoy
=end

#==============================================================================
# ** GUI
#------------------------------------------------------------------------------
# Collection of Graphical User tools
#==============================================================================

module GUI
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  class << self
    #--------------------------------------------------------------------------
    # * Build Bitmap GUI
    #--------------------------------------------------------------------------
    def create_gui_bitmap(w, h, title, a=1, h_title = 32)
      bmp = Bitmap.new(w, h)
      bmp.font.name = "Arial"
      bmp.font.shadow = false
      bmp.font.outline = false
      bmp.font.bold = true
      bmp.font.size = 15
      bmp.fill_rect(0, 0, w, h, Color.new(32, 95, 140))
      bmp.fill_rect(2, h_title, w-4, h-h_title-2, Color.new(*([255])*3, 200))
      x = (a == 0) ? 8 : 0
      bmp.draw_text(x, 0, w, h_title, title, a)
      bmp
    end
    #--------------------------------------------------------------------------
    # * Build Bitmap GUI
    #--------------------------------------------------------------------------
    def create_box_bitmap(w, h, title, decal=0, a=0)
      bmp = Bitmap.new(w, h)
      bmp.font.name = "Arial"
      bmp.font.color = Color.new(32, 95, 140)
      bmp.font.shadow = false
      bmp.font.outline = false
      bmp.font.bold = false
      bmp.font.size = 15
      bmp.fill_rect(0, 0, w, h, Color.new(32, 95, 140))
      bmp.fill_rect(2, 2, w-4, h-4, Color.new(*([255])*3, 200))
      bmp.draw_text(2+decal,2,w-(4-decal), h-4, title, a)
      bmp
    end
    #--------------------------------------------------------------------------
    # * Build Bitmap GUI
    #--------------------------------------------------------------------------
    def create_blank_bitmap(w, h, title, decal=0, a=0)
      bmp = Bitmap.new(w, h)
      bmp.font.name = "Arial"
      bmp.font.color = Color.new(32, 95, 140)
      bmp.font.shadow = false
      bmp.font.outline = false
      bmp.font.bold = false
      bmp.font.size = 15
      bmp.draw_text(decal,0,w-(decal), h-4, title, a)
      bmp
    end
    #--------------------------------------------------------------------------
    # * Build Bitmap button
    #--------------------------------------------------------------------------
    def create_beveled_bitmap(w, h)
      bmp = Bitmap.new(w, h)
      bmp.font.name = "Arial"
      bmp.font.shadow = false
      bmp.font.outline = false
      bmp.font.bold = false
      bmp.font.size = 15
      bmp.fill_rect(0,0,w, h, Color.new(0, 52, 89))
      bmp.fill_rect(1,1,w-3, h-3, Color.new(72, 135, 180))
      bmp.fill_rect(2,2,w-4, h-4, Color.new(32, 95, 140))
      bmp
    end
    #--------------------------------------------------------------------------
    # * Create Title
    #--------------------------------------------------------------------------
    def create_title(t)
      title = Sprite.new
      title.bitmap = Bitmap.new(Graphics.width, 16)
      title.bitmap.font.name = "Arial"
      title.bitmap.font.shadow = false
      title.bitmap.font.outline = false
      title.bitmap.font.bold = true
      title.bitmap.font.size = 15
      title.bitmap.fill_rect(0,0,Graphics.width, 16, Color.new(255,255,255))
      title.bitmap.fill_rect(0,0,Graphics.width, 15, Color.new(32, 95, 140))
      title.bitmap.draw_text(10,0,Graphics.width-10, 16, t)
      title
    end
    #--------------------------------------------------------------------------
    # * Create Empty Square
    #--------------------------------------------------------------------------
    def create_empty_square
      bmp = Bitmap.new(32,32)
      bmp.fill_rect(0,0,32,32,Color.new(0,0,128))
      bmp.fill_rect(16,0,16,16,Color.new(0,0,65))
      bmp.fill_rect(0,16,16,16,Color.new(0,0,65))
      return bmp
    end
    #--------------------------------------------------------------------------
    # * Create Button
    #--------------------------------------------------------------------------
    def create_button(x, y, w, h, t, vp=nil)
      temp_drop = Sprite.new(vp)
      temp_drop.bitmap = Bitmap.new(w, h)
      temp_drop.bitmap.fill_rect(0, 0, w, h, Color.new(32, 95, 140))
      temp_drop.bitmap.font.name = "Arial"
      temp_drop.bitmap.font.shadow = false
      temp_drop.bitmap.font.outline = false
      temp_drop.bitmap.font.bold = true
      temp_drop.bitmap.font.size = 12
      temp_drop.bitmap.draw_text(0, 0, w, h, t, 1)
      temp_drop.x, temp_drop.y = x, y
      return temp_drop
    end
    #--------------------------------------------------------------------------
    # * Create Alert Box
    #--------------------------------------------------------------------------
    def alert(title, message)
      Win32API::MessageBox.(RGSSHWND, message, title, 305)
    end
  end
  #==============================================================================
  # ** Updater
  #------------------------------------------------------------------------------
  # API for Automatic Update
  #==============================================================================
  module Updater
    def update
      return unless @visible
      instance_variables.each do |varname|
        ivar = instance_variable_get(varname)
        ivar.update if ivar.respond_to?(:update)
      end
    end
  end
  #==============================================================================
  # ** Display_Manager
  #------------------------------------------------------------------------------
  # API for Visible/Dispose
  #==============================================================================
  module Display_Manager
    #--------------------------------------------------------------------------
    # * Visible mutator
    #--------------------------------------------------------------------------
    def visible=(v)
      @visible = v
      super(v) if self.class.ancestors[1].methods.include?(:visible=)
      instance_variables.each do |varname|
        ivar = instance_variable_get(varname)
        ivar.visible = v if ivar.respond_to?(:visible=)
      end
    end
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def dispose
      unless @disposed
        @disposed = true
        instance_variables.each do |varname|
          ivar = instance_variable_get(varname)
          ivar.dispose if ivar.respond_to?(:dispose)
        end
      end
    end
  end
  #==============================================================================
  # ** Tone Manager
  #------------------------------------------------------------------------------
  # In Game Tone Change
  #==============================================================================
  class Eval_Ingame
    #--------------------------------------------------------------------------
    # * Include
    #--------------------------------------------------------------------------
    include Display_Manager
    include Updater
    attr_reader :visible
    #--------------------------------------------------------------------------
    # * Object Initialize
    #--------------------------------------------------------------------------
    def initialize
      @visible = true
      create_block
      create_textarea
      create_buttons
    end
    #--------------------------------------------------------------------------
    # * Create Block
    #--------------------------------------------------------------------------
    def create_block
      @block = Sprite.new
      title = Vocab.eval_ingame
      @block.bitmap =GUI::create_gui_bitmap(Graphics.width-20,46,title,0,20)
      @block.x, @block.y = 10, Graphics.height - 54
      @block.z = 1000
    end
    #--------------------------------------------------------------------------
    # * Create Text Area
    #--------------------------------------------------------------------------
    def create_textarea
      @area = KeyField.new(14, @block.y+21, Graphics.width-158, "", 19)
      @area.set_z(1100)
    end
    #--------------------------------------------------------------------------
    # * Create Buttons
    #--------------------------------------------------------------------------
    def create_buttons
      @buttonA = Sprite.new
      @buttonA.x, @buttonA.y = Graphics.width-74, @block.y+22
      @buttonB = Sprite.new
      @buttonB.x, @buttonB.y = Graphics.width-136, @block.y+22
      @buttonA.bitmap = Bitmap.new(60, 20)
      @buttonA.bitmap.fill_rect(0, 0, 100, 20, Color.new(32, 95, 140))
      @buttonA.bitmap.font.name = "Arial"
      @buttonA.bitmap.font.shadow = false
      @buttonA.bitmap.font.outline = false
      @buttonA.bitmap.font.color = Color.new(255,255,255)
      @buttonA.bitmap.font.bold = true
      @buttonA.bitmap.font.size = 14
      @buttonB.bitmap = @buttonA.bitmap.clone
      @buttonA.bitmap.draw_text(0,0, 60, 20, Vocab.eval_run, 1)
      @buttonB.bitmap.draw_text(0,0, 60, 20, Vocab.eval_make, 1)
      @buttonA.z = 1000
      @buttonB.z = 1000
    end
    #--------------------------------------------------------------------------
    # * visible
    #--------------------------------------------------------------------------
    def visible=(v)
      super(v)
      if v
        @area.active = true
        @area.set_text("")
      else
        @area.active = false
      end
    end
    #--------------------------------------------------------------------------
    # * Update
    #--------------------------------------------------------------------------
    def update
      return unless @visible
      super
      if @buttonB.rect.trigger?(:mouse_left)
        rpg_command = RPG::EventCommand.new(355, 0, [@area.value])
        Clipboard.push_command(rpg_command)
        msgbox(Vocab.eval_copied)
      end
      if @buttonA.rect.trigger?(:mouse_left) || Keyboard.trigger?(:enter)
        begin
          eval(@area.value, $game_map.interpreter.get_binding)
          $game_map.need_refresh = true
        rescue Exception => exc
          msgbox(Vocab.eval_error + "\n" + exc.to_s)
        end
      end
    end
  end
  #==============================================================================
  # ** Tone Manager
  #------------------------------------------------------------------------------
  # In Game Tone Change
  #==============================================================================
  class Tone_Manager
    #--------------------------------------------------------------------------
    # * Include
    #--------------------------------------------------------------------------
    include Display_Manager
    include Updater
    attr_reader :visible, :x, :y, :in_transfert
    #--------------------------------------------------------------------------
    # * Object Initialize
    #--------------------------------------------------------------------------
    def initialize
      @x = @y = 10
      @tone = $game_map.screen.tone.dup
      @in_transfert = false
      @visible = true
      create_rect
      create_block
      create_tracks
      create_textbox
      create_checkbox
      create_timebox
      create_buttons
    end
    #--------------------------------------------------------------------------
    # * Create Rect
    #--------------------------------------------------------------------------
    def create_rect
      @rect = Rect.new(@x, @y, 224, 32)
    end
    #--------------------------------------------------------------------------
    # * Create Block
    #--------------------------------------------------------------------------
    def create_block
      @block = Sprite.new
      @block.bitmap = GUI::create_gui_bitmap(224, 200, Vocab.tone_manager)
      @block.x, @block.y = @x, @y
    end
    #--------------------------------------------------------------------------
    # * Create Tracks
    #--------------------------------------------------------------------------
    def create_tracks
      r, v, b, g = 255+@tone.red, 255+@tone.green, 255+@tone.blue, @tone.gray
      bg = Color.new(32,95,140,50)
      args_a = [@x+12, @x+42, 140, 8, r.to_i, 0, 510, 100, bg, Color.new(116,0,0)]
      @red = Horz_Trackbar.new(*args_a)
      args_a[1] += 18
      args_a[4] = v.to_i
      args_a[9] = Color.new(76,143,67)
      @green = Horz_Trackbar.new(*args_a)
      args_a[1] += 18
      args_a[4] = b.to_i
      args_a[9] = Color.new(24,62,148)
      @blue = Horz_Trackbar.new(*args_a)
      args_a[1] += 18
      args_a[4] = g.to_i
      args_a[6] = 255
      args_a[9] = Color.new(146,146,146)
      @gray = Horz_Trackbar.new(*args_a)
    end
    #--------------------------------------------------------------------------
    # * X
    #--------------------------------------------------------------------------
    def x=(v)
      @x = v
      @rect.x = @x
      @block.x = @x
      @red.x = @green.x= @blue.x = @gray.x = @x+12
      @r_text.x = @v_text.x = @b_text.x = @g_text.x = @x+160
      @check.x = @x+12
      @duration.x = @x+13
      @buttonA.x = @x+7
      @buttonB.x = @x+116
    end
    #--------------------------------------------------------------------------
    # * Y
    #--------------------------------------------------------------------------
    def y=(v)
      @y = v
      @rect.y = @y
      @block.y = @y
      @red.y = @y+42
      @green.y = @y+60
      @blue.y = @y+78
      @gray.y = @y+96
      @r_text.y = @y+38
      @v_text.y = @y+57
      @b_text.y = @y+76
      @g_text.y = @y+93
      @check.y = @y+120
      @duration.y = @y+141
      @buttonA.y = @y+173
      @buttonB.y = @y+173
    end
    #--------------------------------------------------------------------------
    # * Create Textbox
    #--------------------------------------------------------------------------
    def create_textbox
      @r_text = IntField.new(@x+160, @y+38, 50, @tone.red, 14, (-255..255))
      @v_text = IntField.new(@x+160, @y+57, 50, @tone.green, 14, (-255..255))
      @b_text = IntField.new(@x+160, @y+76, 50, @tone.blue, 14, (-255..255))
      @g_text = IntField.new(@x+160, @y+93, 50, @tone.gray, 14, (0..255))
    end
    #--------------------------------------------------------------------------
    # * Create Checkbox
    #--------------------------------------------------------------------------
    def create_checkbox
      @check = Checkbox.new(@x+12, @y+120, true)
      @block.bitmap.font.color = Color.new(32, 95, 140)
      @block.bitmap.font.bold = false
      @block.bitmap.draw_text(36, 120, 150, 16, Vocab::tone_wait)
    end
    #--------------------------------------------------------------------------
    # * Create Timebox
    #--------------------------------------------------------------------------
    def create_timebox
      @block.bitmap.fill_rect(12, 140, 60, 18, Color.new(200,200,200))
      @block.bitmap.fill_rect(13, 141, 58, 16, Color.new(255,255,255))
      @duration = IntField.new(@x+13, @y+141, 58, 0, 14, (0..600))
      @block.bitmap.draw_text(74, 141, 150, 16, Vocab::tone_duration)
    end
    #--------------------------------------------------------------------------
    # * Create Buttons
    #--------------------------------------------------------------------------
    def create_buttons
      @buttonA = Sprite.new
      @buttonA.z = 100
      @buttonA.x, @buttonA.y = @x+7, @y+173
      @buttonA.bitmap = Bitmap.new(100, 22)
      @buttonA.bitmap.fill_rect(0, 0, 100, 22, Color.new(32, 95, 140))
      @buttonA.bitmap.font.name = "Arial"
      @buttonA.bitmap.font.shadow = false
      @buttonA.bitmap.font.outline = false
      @buttonA.bitmap.font.color = Color.new(255,255,255)
      @buttonA.bitmap.font.bold = true
      @buttonA.bitmap.font.size = 14
      @buttonB = Sprite.new
      @buttonB.x, @buttonB.y = @x+116, @y+173
      @buttonB.z = 100
      @buttonB.bitmap = @buttonA.bitmap.clone
      @buttonA.bitmap.draw_text(0, 0, 100, 22, Vocab.tone_try, 1)
      @buttonB.bitmap.draw_text(0, 0, 100, 22, Vocab.tone_generate, 1)
    end
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def dispose
      super
      $game_map.screen.tone.set(@tone)
    end
    #--------------------------------------------------------------------------
    # * visible
    #--------------------------------------------------------------------------
    def visible=(v)
      super(v)
      if v
        @tone = $game_map.screen.tone.dup
        @r_text.set_text(@tone.red.to_i.to_s)
        @v_text.set_text(@tone.green.to_i.to_s)
        @b_text.set_text(@tone.blue.to_i.to_s)
        @g_text.set_text(@tone.gray.to_i.to_s)
        r, v, b, g = 255+@tone.red, 255+@tone.green, 255+@tone.blue, @tone.gray
        @red.index, @green.index, @blue.index = r, v, b
        @gray.index = g
      else
        $game_map.screen.tone.set(@tone)
      end
    end
    #--------------------------------------------------------------------------
    # * Update
    #--------------------------------------------------------------------------
    def update
      return unless @visible
      super
      update_drag
      @in_transfert = $game_map.screen.tone_duration > 0
      @red.active = @green.active = @gray.active = @blue.active = false
      if @in_transfert
        @r_text.active = @v_text.active = @g_text.active = @b_text.active = false 
      end
      if !@in_transfert
        @red.active = @green.active = @gray.active = @blue.active = true
        [[@red, @r_text], [@green, @v_text], 
          [@blue, @b_text], [@gray, @g_text]].each do |couple|
            if couple[1].active
              f = (couple[1].min == 0) ? 0 : 255
              v = f + couple[1].value
              couple[0].index = v
            else
              if couple[0].clicked
                f = (couple[1].min == 0) ? 0 : 255
                v = couple[0].index - f
                couple[1].set_text(v.to_s)
              end
            end
          end
          r,v,b,g = @r_text.value, @v_text.value, @b_text.value, @g_text.value
          $game_map.screen.tone.set(Tone.new(r, v, b, g))
        end
        if @buttonA.rect.trigger?(:mouse_left)
          r,v,b,g = @r_text.value, @v_text.value, @b_text.value, @g_text.value
          $game_map.screen.tone.set(@tone)
          $game_map.screen.start_tone_change(Tone.new(r, v, b, g),@duration.value)
        end
        if @buttonB.rect.trigger?(:mouse_left)
          r, v, b, g = @r_text.value, @v_text.value, @b_text.value, @g_text.value
          tone, time, check = Tone.new(r, v, b, g), @duration.value, @check.value
          rpg_command = RPG::EventCommand.new(223, 0, [tone, time, check])
          Clipboard.push_command(rpg_command)
          msgbox(Vocab.tone_copied)
        end
    end
    #--------------------------------------------------------------------------
    # * Update Drag
    #--------------------------------------------------------------------------
    def update_drag
      if @rect.trigger?(:mouse_left)
        @old_x, @old_y = Mouse.x-@x, Mouse.y-@y
        @clicked = true
      end
      if @clicked && Mouse.press?(:mouse_left)
        n_x = [[(Mouse.x - @old_x), 0].max, Graphics.width-224].min
        n_y = [[(Mouse.y - @old_y), 1].max, Graphics.height-32].min
        self.x, self.y = n_x, n_y
        tone = $game_map.screen.tone
      else
        @clicked = false
      end
    end
  end
  #==============================================================================
  # ** Checkbox
  #------------------------------------------------------------------------------
  #  Checkbox
  #==============================================================================
  class Checkbox < Sprite
    #--------------------------------------------------------------------------
    # * Public instance variable
    #--------------------------------------------------------------------------
    attr_accessor :value
    #--------------------------------------------------------------------------
    # * Object initialize
    #--------------------------------------------------------------------------
    def initialize(x, y, default = false, z=100, vp=nil)
      super(vp)
      self.x, self.y, self.z = x, y, z
      @value = default
      self.bitmap = Bitmap.new(16, 16)
      empty_box
      draw_choice if @value
    end
    #--------------------------------------------------------------------------
    # * Empty Box
    #--------------------------------------------------------------------------
    def empty_box
      self.bitmap.clear
      self.bitmap.font.size = 16
      self.bitmap.font.outline = false
      self.bitmap.font.bold = true
      self.bitmap.font.shadow = false
      self.bitmap.font.color = Color.new(140, 140, 140)
      self.bitmap.fill_rect(0, 0, 16, 16, Color.new(140,140,140))
      self.bitmap.fill_rect(1, 1, 14, 14, Color.new(255,255,255))
    end
    #--------------------------------------------------------------------------
    # * Draw choice
    #--------------------------------------------------------------------------
    def draw_choice
      self.bitmap.draw_text(0, 0, 16, 13, "X", 1)
    end
    def update
      if self.rect.trigger?(:mouse_left)
        @value = !@value
        draw_choice if @value
        empty_box unless @value
      end
    end
  end
  #==============================================================================
  # ** KeyField
  #------------------------------------------------------------------------------
  #  Textbox representation
  #==============================================================================
  class KeyField < Sprite
    #--------------------------------------------------------------------------
    # * Include
    #--------------------------------------------------------------------------
    include Display_Manager
    #--------------------------------------------------------------------------
    # * Public Instance Variables
    #--------------------------------------------------------------------------
    attr_accessor :active
    alias :new_x= :x=
    alias :new_y= :y=
    #--------------------------------------------------------------------------
    # * Object initialize
    #--------------------------------------------------------------------------
    def initialize(x, y, w, t="", t_size=14, viewport = nil)
      @disposed = false
      @x, @y, @w = x, y, w
      @textstart = @count = 0
      @font_size = t_size
      @h = @font_size + 2
      @active = false
      @inner_w = @w-2
      @inner_h = @h-2
      @text = t
      @raw_text = @text.dup
      @old_text = ""
      @cut = 0
      @cursor = t.length
      super(viewport)
      create_sprite_rect
      create_cursor
      @max_char = @inner_w/@factor -1
      create_select_rects
      @selecting = false
      reset_selection
      update_graphics
    end
    #--------------------------------------------------------------------------
    # * Create rect
    #--------------------------------------------------------------------------
    def create_sprite_rect
      self.new_x, self.new_y = @x, @y
      @sprite_text = Sprite.new(self.viewport)
      @sprite_text.x, @sprite_text.y = @x+1, @y+1
      create_bitmap
    end
    #--------------------------------------------------------------------------
    # * Create Bitmap
    #--------------------------------------------------------------------------
    def create_bitmap
      self.bitmap = Bitmap.new(@w, @h)
      @sprite_text.bitmap = Bitmap.new(@inner_w, @inner_h)
      @sprite_text.bitmap.font.outline = false
      @sprite_text.bitmap.font.shadow = false
      @sprite_text.bitmap.font.color = Color.new(0,0,0)
      @sprite_text.bitmap.font.size = @font_size
      rect = @sprite_text.bitmap.text_size("M")
      @factor = rect.width
    end
    #--------------------------------------------------------------------------
    # * X
    #--------------------------------------------------------------------------
    def x=(n_x)
      @x = n_x
      self.new_x = n_x
      @sprite_text.x = @x+1
      @select_rects.each.with_index do |r, i|
        r.x = @x + 1 + @factor*i
      end
    end
    #--------------------------------------------------------------------------
    # * Y
    #--------------------------------------------------------------------------
    def y=(n_y)
      @y = n_y
      self.new_y = n_y
      @sprite_text.y = @y+1
      @cursor_sprite.y = @y+1
      @select_rects.each.with_index do |r, i|
        r.y = @y + 1
      end
    end
    #--------------------------------------------------------------------------
    # * Create select rects
    #--------------------------------------------------------------------------
    def create_select_rects
      @select_rects = Array.new(@max_char + 1) { |i| create_char_rect(i) }
    end
    #--------------------------------------------------------------------------
    # * Create char rect
    #--------------------------------------------------------------------------
    def create_char_rect(i)
      spr_char_rect = Sprite.new(self.viewport)
      spr_char_rect.x = @x + 1 + @factor*i
      spr_char_rect.y = @y + 1
      create_char_bitmap(spr_char_rect)
      spr_char_rect.opacity = 0
      return spr_char_rect
    end
    #--------------------------------------------------------------------------
    # * Create char bitmap
    #--------------------------------------------------------------------------
    def create_char_bitmap(spr)
      spr.bitmap = Bitmap.new(@factor, @inner_h)
      spr.bitmap.fill_rect(spr.bitmap.rect, Color.new(51,153,255))
    end
    #--------------------------------------------------------------------------
    # * Create Cursor
    #--------------------------------------------------------------------------
    def create_cursor
      @cursor_sprite = Sprite.new(self.viewport)
      @cursor_sprite.bitmap = Bitmap.new(1, @font_size)
      @cursor_sprite.bitmap.fill_rect(0, 1, 1, @font_size-2, Color.new(0,0,0))
      @cursor_sprite.x = @x + 1
      @cursor_sprite.y = @y + 1
    end
    #--------------------------------------------------------------------------
    # * frame update
    #--------------------------------------------------------------------------
    def update
      update_count
      update_active
      update_capture
      update_copy
      update_cut
      update_paste
      update_selection
      update_graphics
    end
    #--------------------------------------------------------------------------
    # * Update cut
    #--------------------------------------------------------------------------   
    def update_cut
      return unless @active
      if Keyboard.ctrl?(:x)
        Clipboard.push_text(copy_text)
        insert_char("")
        move_cursor_left
      end
    end
    #--------------------------------------------------------------------------
    # * Update copy
    #--------------------------------------------------------------------------   
    def update_copy
      return unless @active
      if Keyboard.ctrl?(:c)
        Clipboard.push_text(copy_text)
      end
    end
    #--------------------------------------------------------------------------
    # * Copy text
    #--------------------------------------------------------------------------   
    def copy_text
      if @start_selection > @end_selection
        return @raw_text[@end_selection...@start_selection] 
      end
      return @raw_text if @start_selection == @end_selection
      return @raw_text[@start_selection...@end_selection]
    end
    #--------------------------------------------------------------------------
    # * Update count
    #--------------------------------------------------------------------------
    def update_count
      @count += 1
      @count %= 60
    end
    #--------------------------------------------------------------------------
    # * Update Active
    #--------------------------------------------------------------------------
    def update_active
      @active = false if Mouse.trigger?(:mouse_left)
      @active = true if self.rect.trigger?(:mouse_left)
    end
    #--------------------------------------------------------------------------
    # * Update capture
    #--------------------------------------------------------------------------
    def update_capture
      return unless @active
      klist = {
        left:      [:move_cursor_left, :fix_cursor, :reset_selection], 
        right:     [:move_cursor_right, :fix_cursor, :reset_selection], 
        backspace: [:delete_char_before],
        delete:    [:delete_char_after]
      }
      relocate_cursor if Mouse.trigger?(:mouse_left)
      ch = get_char
      insert_char(ch) unless ch.empty?
      klist.each do |k, m|
        c = Keyboard.time(k) % [1, 24 - Keyboard.time(k) / 2].max == 0
        if (Keyboard.press?(k) && c) || Keyboard.repeat?(k)
          m.each{|exec|self.send(exec)}
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Update paste
    #--------------------------------------------------------------------------   
    def update_paste
      return unless @active
      if Keyboard.ctrl?(:v)
        str = Clipboard.get_text
        insert_text(str)
      end
    end
    #--------------------------------------------------------------------------
    # * Update selection
    #--------------------------------------------------------------------------
    def update_selection
      update_select_state
      update_select_cursor
      update_select_graphics
    end
    #--------------------------------------------------------------------------
    # * Update selecting state
    #--------------------------------------------------------------------------
    def update_select_state
      if @active
        if Mouse.trigger?(:mouse_left)
          @selecting = true
          @start_selection = @end_selection = @cursor
        end
        if Mouse.release?(:mouse_left)
          @selecting = false
        end
      else
        reset_selection
      end
    end
    #--------------------------------------------------------------------------
    # * Update cursor while selecting
    #--------------------------------------------------------------------------
    def update_select_cursor
      if @selecting
        relocate_cursor
        @end_selection = @cursor
      end
    end
    #--------------------------------------------------------------------------
    # * Update selection graphics
    #--------------------------------------------------------------------------
    def update_select_graphics
      @select_rects.each do |rect|
        rect.opacity = 0
      end
      return unless @active
      if @start_selection > @end_selection
        (@end_selection...@start_selection).each do |i|
          if is_displayed?(i)
            @select_rects[i - @textstart].opacity = 100
          end
        end
      elsif @start_selection < @end_selection
        (@start_selection...@end_selection).each do |i|
          if is_displayed?(i)
            @select_rects[i - @textstart].opacity = 100
          end
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Is the character at @raw_text[pos] displayed?
    #--------------------------------------------------------------------------
    def is_displayed?(pos)
      pos >= @textstart && pos <= @textstart + @max_char
    end
    #--------------------------------------------------------------------------
    # * Reset selection
    #--------------------------------------------------------------------------
    def reset_selection
      @start_selection = @end_selection = 0
    end    
    #--------------------------------------------------------------------------
    # * Update the graphics
    #--------------------------------------------------------------------------
    def update_graphics
      update_textstart
      update_cursor_graphics
      update_text
      update_text_graphics
    end
    #--------------------------------------------------------------------------
    # * Update visible text start point
    #--------------------------------------------------------------------------    
    def update_textstart
      if @textstart > @cursor
        @textstart = @cursor
      elsif @textstart < @cursor - @max_char - 1
        @textstart = @cursor - @max_char - 1
      end
      fix_textstart
    end
    #--------------------------------------------------------------------------
    # * Update cursor display
    #--------------------------------------------------------------------------
    def update_cursor_graphics
      if @active
        @cursor_sprite.visible = @count >= 30 || (Keyboard.press?(:left) || Keyboard.press?(:right))
        @cursor_sprite.x = @x + ((@cursor - @textstart) * @factor) + 2
      else
        @cursor_sprite.visible = false
      end
    end
    #--------------------------------------------------------------------------
    # * Update Text
    #--------------------------------------------------------------------------
    def update_text
      if @raw_text.length > @max_char
        if (@textstart + @max_char) < @raw_text.length
          @text = @raw_text.dup[@textstart..(@textstart+@max_char)]
        else
          @text = @raw_text.dup[(-1-@max_char)..-1]
        end
      else
        @text = @raw_text.dup
      end
    end
    #--------------------------------------------------------------------------
    # * update text display
    #--------------------------------------------------------------------------
    def update_text_graphics
      if @old_text != @text
        @sprite_text.bitmap.clear
        @sprite_text.bitmap.draw_text(0, 0, @inner_w, @inner_h, @text)
        @old_text = @text.dup
      end
    end
    #--------------------------------------------------------------------------
    # * Delete character
    #--------------------------------------------------------------------------
    def delete_char_before
      if @start_selection == @end_selection
        if @cursor > 0
          @raw_text[@cursor-1] = ""
          move_cursor_left
        end
      else
        insert_char("")
        move_cursor_left
      end
    end
    #--------------------------------------------------------------------------
    # * Delete character
    #--------------------------------------------------------------------------
    def delete_char_after
      if @start_selection == @end_selection
        if @raw_text[@cursor]
          @raw_text[@cursor] = ""
        end
      else
        insert_char("")
        move_cursor_left
      end
    end
    #--------------------------------------------------------------------------
    # * Insert character
    #--------------------------------------------------------------------------
    def insert_char(ch)
      if @start_selection > @end_selection
        @raw_text[@end_selection...@start_selection] = ch
        @cursor = @end_selection
      elsif @start_selection == @end_selection
        @raw_text.insert(@cursor, ch)
      else
        @raw_text[@start_selection...@end_selection] = ch
        @cursor = @start_selection
      end
      reset_selection
      move_cursor_right
    end
    #--------------------------------------------------------------------------
    # * Insert text
    #--------------------------------------------------------------------------
    def insert_text(text)
      text.each_char do |ch|
        insert_char(ch)
      end
    end
    #--------------------------------------------------------------------------
    # * Set cursor position according to the mouse
    #--------------------------------------------------------------------------
    def relocate_cursor
      return unless @active
      set_cursor(@textstart + 1 + (Mouse.x - self.rect.x - 1 - @factor/2)/@factor)
    end        
    #--------------------------------------------------------------------------
    # * Set cursor
    #--------------------------------------------------------------------------
    def set_cursor(pos)
      @cursor = pos
      fix_cursor
    end
    #--------------------------------------------------------------------------
    # * Fix cursor
    #--------------------------------------------------------------------------
    def fix_cursor
      @cursor = [[0, @cursor].max, @raw_text.length].min
    end
    #--------------------------------------------------------------------------
    # * Fix start of displayed text
    #--------------------------------------------------------------------------
    def fix_textstart
      f = [[0, @textstart].max, [0, (@raw_text.length-@max_char-1)].max].min
      @textstart = f
    end
    #--------------------------------------------------------------------------
    # * Move cursor to the left
    #--------------------------------------------------------------------------
    def move_cursor_left
      @cursor -= 1
    end
    #--------------------------------------------------------------------------
    # * Move cursor to the right
    #--------------------------------------------------------------------------
    def move_cursor_right
      @cursor += 1
    end
    #--------------------------------------------------------------------------
    # * Set new value to the text
    #--------------------------------------------------------------------------
    def set_text(text)
      @raw_text = text
      @cursor = @textstart = @raw_text.length
      update_graphics
    end
    #--------------------------------------------------------------------------
    # * get char
    #--------------------------------------------------------------------------
    def get_char
      Keyboard.letter
    end
    #--------------------------------------------------------------------------
    # * Set Z
    #--------------------------------------------------------------------------
    def set_z(v)
      self.z = v
      i = 1
      instance_variables.each do |varname|
        ivar = instance_variable_get(varname)
        ivar.z = v+i if ivar.respond_to?(:z)
        i += 1
      end
    end
    #--------------------------------------------------------------------------
    # * Get Value
    #--------------------------------------------------------------------------
    def value
      @raw_text
    end
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def disposed?; @disposed; end
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def visible=(v)
      super(v)
      @select_rects.each do |i|
        i.visible = v
      end
      reset_selection
    end
  end
  #==============================================================================
  # ** IntField
  #------------------------------------------------------------------------------
  #  Textbox representation
  #==============================================================================
  class IntField < KeyField
    #--------------------------------------------------------------------------
    # * Object initialize
    #--------------------------------------------------------------------------
    def initialize(x, y, w, t=0, t_size = 14, range=-1, viewport = nil)
      @range =  (range.is_a?(Range)) ? range : false
      t = ([[@range.min, t.to_i].max, @range.max].min).to_i.to_s if @range
      super(x, y, w, t.to_s, t_size, viewport)
    end
    #--------------------------------------------------------------------------
    # * get char
    #--------------------------------------------------------------------------
    def get_char
      letter = super
      num = ["-","+","0","1","2","3","4","5", "6", "7", "8", "9"]
      return "" if !num.include?(letter)
      t = (letter == "+" || letter == "-") 
      t2 = (@raw_text[0] != "+" || @raw_text[0] != "-")
      return "" if @cursor != 0 &&  t && t2
      return letter
    end
    #--------------------------------------------------------------------------
    # * get Value
    #--------------------------------------------------------------------------
    def value
      @raw_text.to_i
    end
    #--------------------------------------------------------------------------
    # * Fix int value
    #--------------------------------------------------------------------------
    def fix_value(int)
      int = int.to_s
      if int != "-" && int != "+" && int != "" && int != " " && @range
        if int.to_i > @range.max
          return @range.max.to_s
        elsif int.to_i < @range.min
          return @range.min.to_s
        end
      end
      return int.to_s
    end
    #--------------------------------------------------------------------------
    # * Fix @raw_text value
    #--------------------------------------------------------------------------
    def fix_raw_text
      fixed_raw_text = fix_value(@raw_text)
      set_text(fixed_raw_text) if fixed_raw_text != @raw_text
    end
    #--------------------------------------------------------------------------
    # * Set new value to the text
    #--------------------------------------------------------------------------
    def set_text(int)
      int = fix_value(int)
      super(int)
    end
    #--------------------------------------------------------------------------
    # * Update
    #--------------------------------------------------------------------------
    def update
      fix_raw_text
      super
    end
    #--------------------------------------------------------------------------
    # * min
    #--------------------------------------------------------------------------
    def min; return (@range.is_a?(Range)) ? @range.min : 0; end
    #--------------------------------------------------------------------------
    # * Update C/C
    #--------------------------------------------------------------------------
    def update_cc
      
    end
  end
  #==============================================================================
  # ** FloatField
  #------------------------------------------------------------------------------
  #  Textbox representation
  #==============================================================================
  class FloatField < KeyField
    #--------------------------------------------------------------------------
    # * get char
    #--------------------------------------------------------------------------
    def get_char
      letter = super
      num = [".","-","+","0","1","2","3","4","5", "6", "7", "8", "9"]
      return "" if !num.include?(letter)
      t = (letter == "+" || letter == "-") 
      t2 = (@raw_text[0] != "+" || @raw_text[0] != "-")
      return "" if @cursor != 0 &&  t && t2
      return "" if letter == "." && @raw_text.include?(".")
      return letter
    end
    #--------------------------------------------------------------------------
    # * Set new value to the text
    #--------------------------------------------------------------------------
    def set_text(f)
      f = f.to_f.to_s
      super(f)
    end
    #--------------------------------------------------------------------------
    # * get Value
    #--------------------------------------------------------------------------
    def value
      @raw_text.to_f
    end
  end
  #==============================================================================
  # ** Scrollable
  #------------------------------------------------------------------------------
  # Scrollable representation
  #==============================================================================
  class Scrollable
    #--------------------------------------------------------------------------
    # * Constants
    #--------------------------------------------------------------------------
    BLACK = Color.new(*[0]*3)
    WHITE = Color.new(*[255]*3)
    #--------------------------------------------------------------------------
    # * Public Instance Variable
    #--------------------------------------------------------------------------
    attr_reader :disposed, :index, :clicked, :visible
    attr_accessor :active
    #--------------------------------------------------------------------------
    # * Include
    #--------------------------------------------------------------------------
    include Display_Manager
    #--------------------------------------------------------------------------
    # * Object Initialize
    #--------------------------------------------------------------------------
    def initialize(x, y, w, h, z, bg = WHITE, ft = BLACK, vp=nil)
      @index = 0
      @active = true
      @vp = vp
      @x, @y, @w, @h, @z = x, y, w, h, z
      @bgcolor, @frontcolor = bg, ft
      @visible = true
      @disposed = false
      @old_x = @old_y = 0
      @clicked = false
      create_bgbox
    end
    #--------------------------------------------------------------------------
    # * Create Background Box
    #--------------------------------------------------------------------------
    def create_bgbox
      @sprite_bg = Sprite.new(@vp)
      @sprite_bg.bitmap = Bitmap.new(@w, @h)
      @sprite_bg.bitmap.fill_rect(0, 0, @w, @h, @bgcolor)
      @sprite_bg.x, @sprite_bg.y, @sprite_bg.z = @x, @y, @z
    end
    #--------------------------------------------------------------------------
    # * Update
    #--------------------------------------------------------------------------
    def update
      return if @disposed || !@visible || !@active
      @clicked = true if @sprite_button.rect.trigger?(:mouse_left)
      if @clicked && Mouse.click?(:mouse_left)
        update_track
      else
        @clicked = false
      end
      update_position 
    end
    #--------------------------------------------------------------------------
    # * Alias
    #--------------------------------------------------------------------------
    alias :disposed? :disposed
  end
  #==============================================================================
  # ** TrackBar
  #------------------------------------------------------------------------------
  # Trackbar representation
  #==============================================================================
  class Trackbar < Scrollable
    #--------------------------------------------------------------------------
    # * Public Instance Variable
    #--------------------------------------------------------------------------
    attr_reader :x, :y
    #--------------------------------------------------------------------------
    # * Object Initialize
    #--------------------------------------------------------------------------
    def initialize(x, y, w, h,val, min, max, z=100, b = WHITE, f = BLACK, v=nil)
      super(x, y, w, h, z, b, f, v)
      @min, @max = min, max
      @total_data = max-min
      self.index = val
      create_button
    end
    #--------------------------------------------------------------------------
    # * X
    #--------------------------------------------------------------------------
    def x=(n_x)
      @x = n_x
      @sprite_bg.x = n_x
      @sprite_button.x = n_x
      update_position
    end
    #--------------------------------------------------------------------------
    # * y
    #--------------------------------------------------------------------------
    def y=(n_y)
      @y = n_y
      @sprite_bg.y = n_y
      @sprite_button.y = n_y
      update_position
    end
    #--------------------------------------------------------------------------
    # * Index Accessor
    #--------------------------------------------------------------------------
    def index=(v)
      @index = [[v, @min].max, @max].min
    end
    #--------------------------------------------------------------------------
    # * Update
    #--------------------------------------------------------------------------
    def update
      super
      if @active && @sprite_bg.opacity != 255
        @sprite_bg.opacity = 255
        @sprite_button.opacity = 255
      end
      if !@active && @sprite_bg.opacity != 120
        @sprite_bg.opacity = 120
        @sprite_button.opacity = 120
      end
    end
  end
  #==============================================================================
  # ** Vert_TrackBar
  #------------------------------------------------------------------------------
  # Vert Trackbar representation
  #==============================================================================
  class Vert_Trackbar < Trackbar
    #--------------------------------------------------------------------------
    # * Create button
    #--------------------------------------------------------------------------
    def create_button
      @sprite_button = Sprite.new(@vp)
      @sprite_button.bitmap = Bitmap.new(@w, @w)
      @sprite_button.bitmap.fill_rect(0, 0, @w, @w, @frontcolor)
      @sprite_button.x, @sprite_button.y, @sprite_button.z = @x, @y, @z+1
    end
    #--------------------------------------------------------------------------
    # * Update Position
    #--------------------------------------------------------------------------
    def update_position
      total_h = @h - @w
      @sprite_button.y = @y + @index*total_h/@total_data
    end
    #--------------------------------------------------------------------------
    # * Update Track
    #--------------------------------------------------------------------------
    def update_track
      f = (Mouse.y-@sprite_button.y)/2
      self.index += f
    end
  end 
  #==============================================================================
  # ** Horz_TrackBar
  #------------------------------------------------------------------------------
  # Horizontal Trackbar representation
  #==============================================================================
  class Horz_Trackbar < Trackbar
    #--------------------------------------------------------------------------
    # * Create button
    #--------------------------------------------------------------------------
    def create_button
      @sprite_button = Sprite.new(@vp)
      @sprite_button.bitmap = Bitmap.new(@h, @h)
      @sprite_button.bitmap.fill_rect(0, 0, @h, @h, @frontcolor)
      @sprite_button.x, @sprite_button.y, @sprite_button.z = @x, @y, @z+1
    end
    #--------------------------------------------------------------------------
    # * Update Position
    #--------------------------------------------------------------------------
    def update_position
      total_w = @w - @h
      @sprite_button.x = @x + @index*total_w/@total_data
    end
    #--------------------------------------------------------------------------
    # * Update Track
    #--------------------------------------------------------------------------
    def update_track
      f = (Mouse.x-@sprite_button.x)/2
      self.index += f
    end
  end 
  #==============================================================================
  # ** Scrollbar
  #------------------------------------------------------------------------------
  # Scrollbar representation
  #==============================================================================
  class Scrollbar
    #--------------------------------------------------------------------------
    # * Public Instance Variable
    #--------------------------------------------------------------------------
    attr_reader :index, :x, :y, :z, :width, :height, :visible, :total
    attr_accessor :max, :min
    #--------------------------------------------------------------------------
    # * Object Initialize
    #--------------------------------------------------------------------------
    def initialize(x, y, min, max)
      @index = 0
      @disposed = false
      @visible = true
      @active = true
      @x, @y, @min, @max = x, y, *[min, max].sort
      @old_x, @old_y = @x, @y
      @old_max, @old_min = @max, @min
      @total = @max-@min
      @z = 100
      create_bg
    end
    #--------------------------------------------------------------------------
    # * Frame Update
    #--------------------------------------------------------------------------
    def update 
      return if !@active || @disposed || @max == @min || !@visible
      update_tracksize
      update_buttons
      update_position
      update_drag
      update_bar_click
    end
    #--------------------------------------------------------------------------
    # * Update Button
    #--------------------------------------------------------------------------
    def update_buttons
      self.index += 2 if @buttonB.rect.click?(:mouse_left)
      self.index -= 2 if @buttonA.rect.click?(:mouse_left)
    end
    #--------------------------------------------------------------------------
    # * Update Track Size
    #--------------------------------------------------------------------------
    def update_tracksize
      if @old_max != @max || @old_min != @min
        @old_max, @old_min = @max, @min
        @total = @max-@min
        @sprite_trackbar.bitmap.dispose
        create_track_bitmap
      end
    end
    #--------------------------------------------------------------------------
    # * Update drag
    #--------------------------------------------------------------------------
    def update_drag
      if @sprite_trackbar.rect.trigger?(:mouse_left)
        @clicked = true
        @old_x, @old_y = Mouse.x-@x, Mouse.y-@y
        @old_index = @index
      end
      if @clicked && Mouse.press?(:mouse_left)
        update_drag_postion
      else
        @clicked = false
      end
    end
    #--------------------------------------------------------------------------
    # * Z mutator
    #--------------------------------------------------------------------------
    def z=(v)
      @z = v
      i = 1
      instance_variables.each do |varname|
        ivar = instance_variable_get(varname)
        ivar.z = v+i if ivar.respond_to?(:z)
        i += 1
      end
    end
    #--------------------------------------------------------------------------
    # * Index mutator
    #--------------------------------------------------------------------------
    def index=(i)
      @index = [[0, i].max, @total].min
    end
    #--------------------------------------------------------------------------
    # * Visible mutator
    #--------------------------------------------------------------------------
    def visible=(v)
      @visible = v
      instance_variables.each do |varname|
        ivar = instance_variable_get(varname)
        ivar.visible = v if ivar.respond_to?(:visible=)
      end
    end
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def dispose
      @disposed = true
      instance_variables.each do |varname|
        ivar = instance_variable_get(varname)
        ivar.dispose if ivar.respond_to?(:dispose)
      end
    end
  end
  #==============================================================================
  # ** Vert_Scrollbar
  #------------------------------------------------------------------------------
  # Scrollbar representation
  #==============================================================================
  class Vert_Scrollbar < Scrollbar
    #--------------------------------------------------------------------------
    # * Object Initialize
    #--------------------------------------------------------------------------
    def initialize(x, y, min, max, height)
      @height = height
      @width = 16
      @content_height = @height - 2*@width
      super(x, y, min, max)
      create_buttons
      create_track
    end
    #--------------------------------------------------------------------------
    # * Create Background
    #--------------------------------------------------------------------------
    def create_bg
      @bg = Sprite.new
      create_bg_bitmap
      @bg.x, @bg.y = x, y + @width
    end
    #--------------------------------------------------------------------------
    # * Create Background Bitmap
    #--------------------------------------------------------------------------
    def create_bg_bitmap
      @bg.bitmap = Bitmap.new(@width, @height-2*@width)
      @bg.bitmap.fill_rect(0, 0, @width, @height-2*@width, Color.new(174, 192, 205))
    end
    #--------------------------------------------------------------------------
    # * Create Buttons
    #--------------------------------------------------------------------------
    def create_buttons
      @buttonA = Sprite.new
      @buttonA.bitmap = Bitmap.new(@width, @width)
      @buttonA.bitmap.fill_rect(0, 0, @width, @width, Color.new(0, 52, 89))
      @buttonA.bitmap.font.outline = false
      @buttonA.bitmap.font.color = Color.new(174, 192, 205)
      @buttonA.bitmap.font.size = 10
      @buttonA.x, @buttonA.y = @x, @y
      @buttonB = Sprite.new
      @buttonB.bitmap = @buttonA.bitmap.clone
      @buttonB.x, @buttonB.y = @x, @y + @height - @width
      @buttonA.bitmap.draw_text(0,0,@width,@width, "▲", 1)
      @buttonB.bitmap.draw_text(0,0,@width,@width, "▼", 1)
    end
    #--------------------------------------------------------------------------
    # * Create Trackbar
    #--------------------------------------------------------------------------
    def create_track
      @sprite_trackbar = Sprite.new
      create_track_bitmap
      @sprite_trackbar.x, @sprite_trackbar.y = @x, @y+@width
    end
    #--------------------------------------------------------------------------
    # * Create Trackbar Bitmap
    #--------------------------------------------------------------------------
    def create_track_bitmap
      h = @content_height*@min/@max + 1
      @sprite_trackbar.bitmap = GUI::create_beveled_bitmap(@width, h)
    end
    #--------------------------------------------------------------------------
    # * Update Position
    #--------------------------------------------------------------------------
    def update_position
      @sprite_trackbar.y = @y + @width + @index*@content_height/@max
    end
    #--------------------------------------------------------------------------
    # * Update Drag Position
    #--------------------------------------------------------------------------
    def update_drag_postion
      self.index = @old_index + (Mouse.y-@old_y-@y)*@max/@content_height
    end
    #--------------------------------------------------------------------------
    # * Update Drag Position
    #--------------------------------------------------------------------------
    def update_bar_click
      if @bg.rect.hover? && !@sprite_trackbar.rect.hover?
        @bar_clicked = true if Mouse.trigger?(:mouse_left)
        if @bar_clicked && Mouse.repeat?(:mouse_left)
          f = Mouse.y < @sprite_trackbar.y ? -1 : 1
          self.index += f*@min
        end
      else
        @bar_clicked = false
      end
    end
    #--------------------------------------------------------------------------
    # * X
    #--------------------------------------------------------------------------
    def x=(v)
      @x = v
      @bg.x = v
      @buttonA.x = v
      @buttonB.x = v
      @sprite_trackbar.x = v
      update_position
    end
    #--------------------------------------------------------------------------
    # * Y
    #--------------------------------------------------------------------------
    def y=(v)
      @y = v
      @bg.y = v + @width
      @buttonA.y = v
      @buttonB.y = v + @height - @width
      update_position
    end
    #--------------------------------------------------------------------------
    # * Height
    #--------------------------------------------------------------------------
    def height=(v)
      @height = v
      @content_height = v - 2*@width
      @buttonB.y = @y + v - @width
      @bg.bitmap.dispose
      create_bg_bitmap
      @sprite_trackbar.bitmap.dispose
      create_track_bitmap
    end
  end
  #==============================================================================
  # ** Horz_Scrollbar
  #------------------------------------------------------------------------------
  # Scrollbar representation
  #==============================================================================
  class Horz_Scrollbar < Scrollbar
    #--------------------------------------------------------------------------
    # * Object Initialize
    #--------------------------------------------------------------------------
    def initialize(x, y, min, max, width)
      @height = 16
      @width = width
      @content_width = @width - 2*@height
      super(x, y, min, max)
      create_buttons
      create_track
    end
    #--------------------------------------------------------------------------
    # * Create Background
    #--------------------------------------------------------------------------
    def create_bg
      @bg = Sprite.new
      create_bg_bitmap
      @bg.x, @bg.y = x + @height, y
    end
    #--------------------------------------------------------------------------
    # * Create Background Bitmap
    #--------------------------------------------------------------------------
    def create_bg_bitmap
      @bg.bitmap = Bitmap.new(@width-2*@height, @height)
      @bg.bitmap.fill_rect(0, 0, @width-2*@height, @height, Color.new(174, 192, 205))
    end
    #--------------------------------------------------------------------------
    # * Create Buttons
    #--------------------------------------------------------------------------
    def create_buttons
      @buttonA = Sprite.new
      @buttonA.bitmap = Bitmap.new(@height, @height)
      @buttonA.bitmap.fill_rect(0, 0, @height, @height, Color.new(0, 52, 89))
      @buttonA.bitmap.font.outline = false
      @buttonA.bitmap.font.color = Color.new(174, 192, 205)
      @buttonA.bitmap.font.size = 14
      @buttonA.x, @buttonA.y = @x, @y
      @buttonB = Sprite.new
      @buttonB.bitmap = @buttonA.bitmap.clone
      @buttonB.x, @buttonB.y = @x + @width - @height, @y
      @buttonA.bitmap.draw_text(0,0,@height,@height, "◄", 1)
      @buttonB.bitmap.draw_text(0,0,@height,@height, "►", 1)
    end
    #--------------------------------------------------------------------------
    # * Create Trackbar
    #--------------------------------------------------------------------------
    def create_track
      @sprite_trackbar = Sprite.new
      create_track_bitmap
      @sprite_trackbar.x, @sprite_trackbar.y = @x+@height, @y
    end
    #--------------------------------------------------------------------------
    # * Create Trackbar Bitmap
    #--------------------------------------------------------------------------
    def create_track_bitmap
      w = @content_width*@min/@max + 1
      @sprite_trackbar.bitmap = GUI::create_beveled_bitmap(w, @height)
    end
    #--------------------------------------------------------------------------
    # * Update Position
    #--------------------------------------------------------------------------
    def update_position
      @sprite_trackbar.x = @x + @height + @index.to_f*@content_width/@max
    end
    #--------------------------------------------------------------------------
    # * Update Drag Position
    #--------------------------------------------------------------------------
    def update_drag_postion
      self.index = @old_index + (Mouse.x-@old_x-@x)*@max/@content_width
    end
    #--------------------------------------------------------------------------
    # * Update Drag Position
    #--------------------------------------------------------------------------
    def update_bar_click
      if @bg.rect.hover? && !@sprite_trackbar.rect.hover?
        @bar_clicked = true if Mouse.trigger?(:mouse_left)
        if @bar_clicked && Mouse.repeat?(:mouse_left)
          f = Mouse.x < @sprite_trackbar.x ? -1 : 1
          self.index += f*@min
        end
      else
        @bar_clicked = false
      end
    end
    #--------------------------------------------------------------------------
    # * X
    #--------------------------------------------------------------------------
    def x=(v)
      @x = v
      @bg.x = v + @height
      @buttonA.x = v
      @buttonB.x = v + @width - @height
      update_position
    end
    #--------------------------------------------------------------------------
    # * Y
    #--------------------------------------------------------------------------
    def y=(v)
      @y = v
      @bg.y = v
      @buttonA.y = v
      @buttonB.y = v
      @sprite_trackbar.y = v
      update_position
    end
    #--------------------------------------------------------------------------
    # * Width
    #--------------------------------------------------------------------------
    def width=(v)
      @width = v
      @content_width = v - 2*@height
      @buttonB.x = @x + v - @height
      @bg.bitmap.dispose
      create_bg_bitmap
      @sprite_trackbar.bitmap.dispose
      create_track_bitmap
    end
  end
  #==============================================================================
  # ** Scrollable_Viewport
  #------------------------------------------------------------------------------
  # Scrollable viewport
  #==============================================================================
  class Scrollable_Viewport < ::Viewport
    #--------------------------------------------------------------------------
    # * Public instance variable
    #--------------------------------------------------------------------------
    attr_accessor :horizontal, :vertical
    #--------------------------------------------------------------------------
    # * Object Initialize
    #--------------------------------------------------------------------------
    def initialize(*args)
      super(*args)
      x_vert = self.rect.x + self.rect.width - 16
      y_horz = self.rect.y + self.rect.height - 16
      c_h, c_w = calc_height, calc_width
      @bg = Sprite.new
      @bg.x, @bg.y = self.rect.x, y_horz
      @bg.bitmap = Bitmap.new(width, 16)
      @bg.bitmap.fill_rect(0,0,width, 16, Color.new(32, 95, 140))
      @bg.visible = false
      @vertical = Vert_Scrollbar.new(x_vert, self.rect.y, true_height, c_h, true_height)
      @horizontal = Horz_Scrollbar.new(self.rect.x, y_horz, true_width, c_w, true_width)
      @vertical.visible = @horizontal.visible = false
      @old_h, @old_w = c_h, c_w
      @old_th, @old_tw = rect.height, rect.width
    end
    #--------------------------------------------------------------------------
    # * True Height
    #--------------------------------------------------------------------------
    def true_height
      f = (@horizontal && @horizontal.visible) ? 16 : 0
      rect.height - f
    end
    #--------------------------------------------------------------------------
    # * True Width
    #--------------------------------------------------------------------------
    def true_width
      f = (@vertical && @vertical.visible) ? 16 : 0
      rect.width - f
    end
    #--------------------------------------------------------------------------
    # * Calcul height space
    #--------------------------------------------------------------------------
    def calc_height
      return rect.height if @elts.empty?
      visible_e = @elts.select{|a|a.visible if a.respond_to?(:visible)}
      v = visible_e.max{|a, b| (a.y + a.rect.height) <=> (b.y + b.rect.height)}
      [(v.y+v.rect.height), true_height].max
    end
    #--------------------------------------------------------------------------
    # * Calcul height space
    #--------------------------------------------------------------------------
    def calc_width
      return rect.width if @elts.empty?
      visible_e = @elts.select{|a|a.visible if a.respond_to?(:visible)}
      v = visible_e.max{|a, b| (a.x + a.rect.width) <=> (b.x + b.rect.width)}
      [(v.x+v.rect.width), true_width].max
    end
    #--------------------------------------------------------------------------
    # * Visible
    #--------------------------------------------------------------------------
    def visible=(v)
      super(v)
      @vertical.visible = @horizontal.visible = v
    end
    #--------------------------------------------------------------------------
    # * Update
    #--------------------------------------------------------------------------
    def update
      super
      update_scroll
      update_size
    end
    #--------------------------------------------------------------------------
    # * Update scrolling
    #--------------------------------------------------------------------------
    def update_scroll
      @vertical.update
      @horizontal.update
      self.ox = @horizontal.index
      self.oy = @vertical.index
    end
    #--------------------------------------------------------------------------
    # * dispose
    #--------------------------------------------------------------------------
    def dispose
      super
      @horizontal.dispose
      @vertical.dispose
      @bg.dispose
    end
    #--------------------------------------------------------------------------
    # * Update o
    #--------------------------------------------------------------------------
    def o(x,y)
      @horizontal.index = x
      @vertical.index = y
    end
    #--------------------------------------------------------------------------
    # * Update Size
    #--------------------------------------------------------------------------
    def update_size
      if @old_h != calc_height || @old_w != calc_width || @old_th != height || @old_tw != width
        @old_th, @old_tw = rect.height, rect.width
        x_vert = self.rect.x + self.rect.width - 16
        y_horz = self.rect.y + self.rect.height - 16
        @vertical.x, @vertical.y = x_vert, rect.y
        @horizontal.x, @horizontal.y = rect.x, y_horz
        @bg.x, @bg.y = rect.x, y_horz
        @vertical.min, @horizontal.min = true_height, true_width
        @vertical.max, @horizontal.max = calc_height, calc_width
        @old_h, @old_w = calc_height, calc_width
        @vertical.visible = true_height < calc_height
        @horizontal.visible = true_width < calc_width
        if @vertical.visible && @horizontal.visible
          @vertical.height = rect.height - 16
          @horizontal.width = rect.width - 16
          @bg.visible = true
        else
          @vertical.height = rect.height
          @horizontal.width = rect.width
          @bg.visible = false
        end
      end
    end
  end
  
  #==============================================================================
  # ** Scrollable_Map
  #------------------------------------------------------------------------------
  #  Scrollable Map definition
  #==============================================================================
  class Scrollable_Map
    #--------------------------------------------------------------------------
    # * Public Instances Variables
    #--------------------------------------------------------------------------
    attr_accessor :map_id
    #--------------------------------------------------------------------------
    # * Load tileset from id
    #--------------------------------------------------------------------------
    def get_tileset(i)
      f = $EDITOR ? "../Data/Tilesets.rvdata2" : "Data/Tilesets.rvdata2"
      load_data(f)[i]
    end
    #--------------------------------------------------------------------------
    # * Object Initialize
    #--------------------------------------------------------------------------
    def initialize(map_id, x, y, w=544, h=416, grid=true, events=true, cursor=false)
      refresh(map_id, x, y, w, h, grid, events, cursor)
    end
    #--------------------------------------------------------------------------
    # * Create Grid
    #--------------------------------------------------------------------------
    def create_grid
      @grid_plane = Plane.new(@tile_viewport)
      @grid_plane.bitmap = Bitmap.new(32, 32)
      @grid_plane.bitmap.fill_rect(31, 0, 32, 32, Color.new(*([0]*3), 200))
      @grid_plane.bitmap.fill_rect(0, 31, 31, 31, Color.new(*([0]*3), 200))
      @grid_plane.visible = @grid
      @grid_plane.z = 0xffffff8
    end
    #--------------------------------------------------------------------------
    # * Create Events
    #--------------------------------------------------------------------------
    def create_events
      @events_plane = Plane.new(@tile_viewport)
      @events_plane.bitmap = Bitmap.new(@map.width*32, @map.height*32)
      @map.events.each do |key, ev|
        x, y = ev.x*32, ev.y*32
        c = Color.new(255, 0, 0, 120)
        @events_plane.bitmap.fill_rect(x, y, 31, 31, c)
      end
      @events_plane.visible = @events
      @events_plane.z = 0xffffff9
    end
    #--------------------------------------------------------------------------
    # * Create Cursor
    #--------------------------------------------------------------------------
    def create_cursor
      @sprite_cursor = Sprite.new(@tile_viewport)
      @sprite_cursor.bitmap = Bitmap.new(31,31)
      @sprite_cursor.bitmap.fill_rect(0, 0, 31, 31, Color.new(0,255,0,120))
      @sprite_cursor.x = @sprite_cursor.y = 0
      @sprite_cursor.visible = @cursor
      @sprite_cursor.z = 0xffffffb
    end
    #--------------------------------------------------------------------------
    # * Create Viewport
    #--------------------------------------------------------------------------
    def create_viewport
      @tile_viewport = GUI::Scrollable_Viewport.new(@x, @y, @width, @height)
      @plane_bg = Plane.new(@tile_viewport)
      @plane_bg.bitmap = GUI::create_empty_square
    end
    #--------------------------------------------------------------------------
    # * Create Tilemap
    #--------------------------------------------------------------------------
    def create_tilemap
      @tilemap = Tilemap.new(@tile_viewport)
      @tilemap.map_data = @map.data
      load_tileset
    end
    #--------------------------------------------------------------------------
    # * Load tileset
    #--------------------------------------------------------------------------
    def load_tileset
      @tileset = get_tileset(@map.tileset_id)
      @tileset.tileset_names.each_with_index do |name, i|
        f = $EDITOR ? "../Graphics/Tilesets/" : "Graphics/Tilesets/"
        b = File.exists?(f+name) ? Cache.load_bitmap(f, name) : Cache.tileset(name)
        @tilemap.bitmaps[i] = b
      end
      @tilemap.flags = @tileset.flags
    end
    #--------------------------------------------------------------------------
    # * Frame Update
    #--------------------------------------------------------------------------
    def update
      @tile_viewport.update
      @tilemap.update
      @plane_bg.ox = @tilemap.ox
      @plane_bg.oy = @tilemap.oy
      if @grid
        @grid_plane.ox = @tilemap.ox
        @grid_plane.oy = @tilemap.oy
      end
      if @events
        @events_plane.ox = @tilemap.ox
        @events_plane.oy = @tilemap.oy
      end
      update_cursor if @cursor
    end
    #--------------------------------------------------------------------------
    # * Update Cursor
    #--------------------------------------------------------------------------
    def update_cursor
      if @tile_viewport.rect.hover?
        x = ((Mouse.x - @x + @tile_viewport.ox)/32)*32
        y = ((Mouse.y - @y + @tile_viewport.oy)/32)*32
        @sprite_cursor.x = [[0, x].max, ((@map.width-1)*32)].min
        @sprite_cursor.y = [[0, y].max, ((@map.height-1)*32)].min
      end
    end
    #--------------------------------------------------------------------------
    # * Get X coords
    #--------------------------------------------------------------------------
    def x_square
      (@sprite_cursor.x)/32
    end
    #--------------------------------------------------------------------------
    # * Get Y coords
    #--------------------------------------------------------------------------
    def y_square
      (@sprite_cursor.y)/32
    end
    #--------------------------------------------------------------------------
    # * rebuild
    #--------------------------------------------------------------------------
    def refresh(map_id, x, y, w=544, h=416, grid=true, events=true, cursor=false)
      @map_id = map_id
      map = $EDITOR ? "../Data/Map%03d.rvdata2" : "Data/Map%03d.rvdata2"
      @map = load_data(sprintf(map, @map_id))
      @x, @y = x, y
      @width, @height = w, h
      @grid, @events, @cursor = grid, events, cursor
      create_viewport
      create_tilemap
      create_grid
      create_events
      create_cursor
    end
    #--------------------------------------------------------------------------
    # * rebuild
    #--------------------------------------------------------------------------
    def rebuild(map_id, x, y, w=544, h=416, grid=true, events=true, cursor=false)
      partiel_dispose
      refresh(map_id, x, y, w, h, grid, events, cursor)
    end
    #--------------------------------------------------------------------------
    # * partiel dispose
    #--------------------------------------------------------------------------
    def partiel_dispose
      @events_plane.dispose
      @grid_plane.dispose
      @sprite_cursor.dispose
      @tilemap.dispose
      @plane_bg.dispose
      @tile_viewport.dispose
    end
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def dispose
      partiel_dispose
    end
  end
end

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================

class Scene_Map
  #--------------------------------------------------------------------------
  # * Alias
  #--------------------------------------------------------------------------
  alias :extender_start     :start
  alias :extender_update    :update
  alias :extender_terminate :terminate
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    if $TEST
      @tone_manager = GUI::Tone_Manager.new
      @eval_ingame = GUI::Eval_Ingame.new
      @eval_ingame.visible = @tone_manager.visible = false
    end
    extender_start
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    extender_update
    if $TEST
      if Keyboard.trigger?(:esc) && @eval_ingame.visible
        $game_system.menu_disabled = @old_call_menu
        @eval_ingame.visible = !@eval_ingame.visible
      end
      if Keyboard.trigger?(:esc) && @tone_manager.visible && !@tone_manager.in_transfert
        $game_system.menu_disabled = @old_call_menu
        @tone_manager.visible = !@tone_manager.visible
      end
      if Keyboard.trigger?(Configuration::KEY_TONE_MANAGER) && !@eval_ingame.visible && !@tone_manager.in_transfert
        @old_call_menu = $game_system.menu_disabled
        @tone_manager.visible = !@tone_manager.visible
        if @tone_manager.visible
          $game_system.menu_disabled = true
        else
          $game_system.menu_disabled = @old_call_menu
        end
      end
      if Keyboard.trigger?(Configuration::KEY_INGAME_EVAL) && !@tone_manager.visible 
        @old_call_menu = $game_system.menu_disabled
        @eval_ingame.visible = !@eval_ingame.visible
        if @eval_ingame.visible
          $game_system.menu_disabled = true
        else
          $game_system.menu_disabled = @old_call_menu
        end
      end
      @tone_manager.update
      @eval_ingame.update
    end
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    if $TEST
      @tone_manager.dispose 
      @eval_ingame.dispose
    end
    extender_terminate
  end
end