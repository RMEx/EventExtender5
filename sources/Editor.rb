=begin
 Event Extender 5
 Custom Editor
 ===============================================================================
 http://www.biloucorp.com
 ===============================================================================
 By Grim and Nuki
=end

#==============================================================================
# ** SceneManager
#------------------------------------------------------------------------------
#  This module manages scene transitions. For example, it can handle
# hierarchical structures such as calling the item screen from the main menu
# or returning from the item screen to the main menu.
#==============================================================================

module SceneManager
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  class << self
    #--------------------------------------------------------------------------
    # * Alias
    #--------------------------------------------------------------------------
    alias :extender_first_scene_class :first_scene_class
    #--------------------------------------------------------------------------
    # * Get First Scene Class
    #--------------------------------------------------------------------------
    def first_scene_class
      $EDITOR ? Scene_Editor_Main : extender_first_scene_class
    end
  end
end

#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
# The instance of this class is referenced by $game_temp.
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :current_cmd, :current_cat
end


#==============================================================================
# ** Scene_Editor_Main
#------------------------------------------------------------------------------
#  Main of the Editor
#==============================================================================

class Scene_Editor_Main < Scene_Base
  #--------------------------------------------------------------------------
  # * Object Initialize
  #--------------------------------------------------------------------------
  def start
    @handler = Hash.new
    create_blank_bg
    create_title
    create_viewport
    make_handler_list
    set_handler(:exit, Vocab.exit){SceneManager.exit}
    draw_list
  end
  #--------------------------------------------------------------------------
  # * Make Handler List
  #--------------------------------------------------------------------------
  def make_handler_list
    set_handler(:e_db, Vocab.extend_db){SceneManager.call(Scene_Tables)}
    set_handler(:skip_title, Vocab.skip_title){SceneManager.call(Scene_SkipTitle)}
    set_handler(:generate_cmd, Vocab.generate_cmd){SceneManager.call(Scene_Cat_List)}
    set_handler(:generate_event, Vocab.generate_event){msgbox("todo")}
    set_handler(:eventprinter, Vocab.exp_event){SceneManager.call(Scene_Printer)}
    set_handler(:eventimporter, Vocab.imp_event){msgbox("todo")}
  end
  #--------------------------------------------------------------------------
  # * Draw list of handler
  #--------------------------------------------------------------------------
  def draw_list
    @handler_sprite = Hash.new
    y = 16
    g_w = Graphics.width
    f = (y + ((@handler.length * 32) + 8))
    w = (f > @viewport.height) ? (g_w - 32 -16) : (g_w - 32)
    @handler.each do |key, val|
      spr = Sprite.new(@viewport)
      spr.bitmap = GUI.create_beveled_bitmap(w, 32)
      spr.bitmap.draw_text(0,0,w,32, val[0], 1)
      spr.x = 16
      spr.y = y
      spr.opacity = 200
      @handler_sprite[key] = spr
      y += 32+8
    end
  end
  #--------------------------------------------------------------------------
  # * Create Viewport
  #--------------------------------------------------------------------------
  def create_viewport
    @viewport = GUI::Scrollable_Viewport.new(0, 16, Graphics.width, Graphics.height-16)
  end
  #--------------------------------------------------------------------------
  # * Set Handler
  #--------------------------------------------------------------------------
  def set_handler(key, title, &block)
    @handler[key.to_sym] = [title, block]
  end
  #--------------------------------------------------------------------------
  # * Create Title
  #--------------------------------------------------------------------------
  def create_title
    @title = GUI.create_title("Event Extender Editor V#{Informations::VERSION}")
  end
  #--------------------------------------------------------------------------
  # * Update Sprites
  #--------------------------------------------------------------------------
  def update_sprites
    @handler_sprite.each do |key, val|
      val.opacity = (val.rect.hover?) ? 255 : 200
      @handler[key][1].() if val.rect.trigger?(:mouse_left)
    end
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    @viewport.update
    update_sprites
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    @handler_sprite.each{|k,v|v.dispose}
    @title.dispose
  end
end

#==============================================================================
# ** Scene_Cat_List
#------------------------------------------------------------------------------
#  Category List
#==============================================================================

class Scene_Cat_List < Scene_Base
  #--------------------------------------------------------------------------
  # * Object Initialize
  #--------------------------------------------------------------------------
  def start
    super
    $game_temp.current_cat ||= Command::Description.Category.first[0]
    @current_cat = Command::Description.Category[$game_temp.current_cat]
    @current_cmds = Command::Description.all.select do |m| 
      v = Command::Description.send(m)
      if $game_temp.current_cat == :none
        !v.has_key?(:category) || v[:category] == :none || !Command::Description.Category.keys.include?(v[:category])
      else
        v[:category] == $game_temp.current_cat
      end
    end
    create_blank_bg
    create_title
    create_viewport
    draw_list
    draw_current_module
  end
  #--------------------------------------------------------------------------
  # * Create Viewport
  #--------------------------------------------------------------------------
  def create_viewport
    @viewport = GUI::Scrollable_Viewport.new(0, 16, 232, Graphics.height-16)
    @viewportMod = Viewport.new(232, 16, Graphics.width-232, Graphics.height-16)
  end
  #--------------------------------------------------------------------------
  # * Draw_item List
  #--------------------------------------------------------------------------
  def draw_list
    @cat = Hash.new
    y = 8
    Command::Description.Category.each do |k, s|
      if k != :none
        @cat[k] = Sprite.new(@viewport)
        @cat[k].x = 8
        @cat[k].y = y
        @cat[k].bitmap = GUI.create_beveled_bitmap(200, 32)
        @cat[k].bitmap.draw_text(0,0,200,32, s.name, 1)
        @cat[k].opacity = 200
        y += 32+4
      end
    end
    @cat[:none] = Sprite.new(@viewport)
    @cat[:none].x = 8
    @cat[:none].y = y
    @cat[:none].bitmap = GUI.create_beveled_bitmap(200, 32)
    @cat[:none].bitmap.draw_text(0,0,200,32, Vocab.no_cat, 1)
    @cat[:none].opacity = 200
  end
  #--------------------------------------------------------------------------
  # * Draw Module Info
  #--------------------------------------------------------------------------
  def draw_current_module
    @titleModule = Sprite.new(@viewportMod)
    @titleModule.bitmap = GUI::create_box_bitmap(Graphics.width-232-16, 32, @current_cat.name, 0, 1)
    @titleModule.y = @titleModule.x = 8
    create_desc_module
    @list_command_spr = Sprite.new(@viewportMod)
    @list_command_spr.bitmap = GUI::create_box_bitmap(Graphics.width-232-16, 32, Vocab.command_list, 0, 1)
    @list_command_spr.x = 8
    @list_command_spr.y = 144
    draw_cmd_list
    create_desc_cmd
  end
  #--------------------------------------------------------------------------
  # * Draw CMD List
  #--------------------------------------------------------------------------
  def draw_cmd_list
    @cmd_vp = GUI::Scrollable_Viewport.new(232, 196,  Graphics.width-232-8, Graphics.height-196-64)
    i = 0
    y = 0
    @cmds_spr = {}
    w = (Graphics.width-232-32-16-8)/2
    @current_cmds.each do |k|
      @cmds_spr[k] = Sprite.new(@cmd_vp)
      @cmds_spr[k].bitmap = GUI.create_beveled_bitmap(w, 18)
      @cmds_spr[k].bitmap.draw_text(0,0,w,18, k.to_s, 1)
      @cmds_spr[k].x = (i%2 == 0) ? 8 : w + 16
      @cmds_spr[k].y = y
      @cmds_spr[k].opacity = 200
      unless i%2 == 0
        y += 20
      end
      i += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Create Desc Cmd
  #--------------------------------------------------------------------------
  def create_desc_cmd
    @desc_cmd_vp = GUI::Scrollable_Viewport.new(240, Graphics.height-64, Graphics.width-232-16, 64)
    @desc_cmd_spr = Sprite.new(@desc_cmd_vp)
    @desc_cmd_spr.bitmap = Bitmap.new(1,1)
  end
  #--------------------------------------------------------------------------
  # * Create Desc BMP
  #--------------------------------------------------------------------------
  def create_desc_bmp(m)
    @desc_cmd_spr.bitmap.clear
    bmp = Bitmap.new(1,1)
    bmp.font.name = "Arial"
    bmp.font.color = Color.new(32, 95, 140)
    bmp.font.shadow = false
    bmp.font.outline = false
    bmp.font.bold = false
    bmp.font.size = 15
    t = Command::Description.send(m)[:desc].cut(65)
    h = w = 0
    t.each do |u|
      r = bmp.text_size(u)
      h = [r.height, h].max
      w = [r.width, w].max
    end
    b = Bitmap.new(w, h*t.length)
    b.font = bmp.font
    t.each.with_index do |u, i|
      b.draw_text(0, h*i, w, h, u)
    end
    @desc_cmd_spr.bitmap = b
  end
  #--------------------------------------------------------------------------
  # * Create Desc Module
  #--------------------------------------------------------------------------
  def create_desc_module
    @desc_vp = GUI::Scrollable_Viewport.new(240, 64, Graphics.width-232-16, 80)
    bmp = Bitmap.new(1,1)
    bmp.font.name = "Arial"
    bmp.font.color = Color.new(32, 95, 140)
    bmp.font.shadow = false
    bmp.font.outline = false
    bmp.font.bold = false
    bmp.font.size = 15
    t = @current_cat.desc.cut(65)
    h = w = 0
    t.each do |u|
      r = bmp.text_size(u)
      h = [r.height, h].max
      w = [r.width, w].max
    end
    b = Bitmap.new(w, h*t.length)
    b.font = bmp.font
    t.each.with_index do |u, i|
      b.draw_text(0, h*i, w, h, u)
    end
    @sprite_desc = Sprite.new(@desc_vp)
    @sprite_desc.bitmap = b
  end
  #--------------------------------------------------------------------------
  # * Create Title
  #--------------------------------------------------------------------------
  def create_title
    @title = GUI.create_title(Vocab.cat_list)
  end
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_esc
    update_cat
    update_cmd
    @viewport.update
    @desc_vp.update
    @cmd_vp.update
    @desc_cmd_vp.update
  end
  #--------------------------------------------------------------------------
  # * Update cat
  #--------------------------------------------------------------------------
  def update_cat
    @cat.each do |key, val|
      val.opacity = (val.rect.hover?) ? 255 : 200
      if val.rect.trigger?(:mouse_left)
        $game_temp.current_cat = key 
        SceneManager.goto(Scene_Cat_List)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update cmd
  #--------------------------------------------------------------------------
  def update_cmd
    @cmds_spr.each do |key, val|
      if val.rect.hover?
        val.opacity = 255
        create_desc_bmp(key)
        @desc_cmd_vp.vertical.index = 0
      else
        val.opacity = 200
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update esc
  #--------------------------------------------------------------------------
  def update_esc
    SceneManager.return if Keyboard.trigger?(:esc)
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    @title.dispose
    @cmds_spr.each{|k,v|v.dispose}
    @cat.each{|k,v|v.dispose}
    @list_command_spr.dispose
    @sprite_desc.dispose
    @cmd_vp.dispose
    @desc_vp.dispose
    @viewport.dispose
    @viewportMod.dispose
    @titleModule.dispose
    @desc_cmd_spr.dispose
    @desc_cmd_vp.dispose
  end
end