=begin
 Event Extender 5
 Skip Title
 ===============================================================================
 http://www.biloucorp.com
 ===============================================================================
 By Grim and Nuki
=end

#==============================================================================
# ** SkipCommands
#------------------------------------------------------------------------------
#  API of the module
#==============================================================================

module SkipCommands
  #--------------------------------------------------------------------------
  # * Start new Game from the RMVXAce Editor
  #--------------------------------------------------------------------------
  def start_new_game
    DataManager.setup_new_game
  end
  #--------------------------------------------------------------------------
  # * Go to title Screen
  #--------------------------------------------------------------------------
  def goto_title_screen
    SceneManager.call(Scene_Title)
  end
  #--------------------------------------------------------------------------
  # * Go to Load Screen
  #--------------------------------------------------------------------------
  def goto_load_screen
    SceneManager.call(Scene_Load)
  end
  #--------------------------------------------------------------------------
  # * Include
  #--------------------------------------------------------------------------
  append_commands
end

#==============================================================================
# ** RPG
#------------------------------------------------------------------------------
#  Standard Definition
#==============================================================================

module RPG
  #==============================================================================
  # ** RPG::Skip_Title
  #------------------------------------------------------------------------------
  #  Skip_Title Informations
  #==============================================================================
  class Skip_Title
    #--------------------------------------------------------------------------
    # * Object Initialize
    #--------------------------------------------------------------------------
    def initialize
      @standard_mode = true
      @coords = [0,0]
      @map_id = 0
      @i_h = 0
      @i_v = 0
    end
    #--------------------------------------------------------------------------
    # * Public instances variables
    #--------------------------------------------------------------------------
    attr_accessor :standard_mode
    attr_accessor :coords
    attr_accessor :map_id
    attr_accessor :i_h
    attr_accessor :i_v
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
    # * Alias
    #--------------------------------------------------------------------------
    alias :skip_ee_init :init
    #--------------------------------------------------------------------------
    # * Initialize Module
    #--------------------------------------------------------------------------
    def init
      create_skip_rvdata
      skip_ee_init
    end
    #--------------------------------------------------------------------------
    # * Create Skip Title Infos
    #--------------------------------------------------------------------------
    def create_skip_rvdata
      return if !$TEST && !$EDITOR
      file = $EDITOR ? '../Data/SkipTitle.rvdata2' : 'Data/SkipTitle.rvdata2'
      return if File.exists?(file)
      save_data(RPG::Skip_Title.new, file)
    end
  end
end

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
    alias :skip_ee_run :run
    #--------------------------------------------------------------------------
    # * Map exists?
    #--------------------------------------------------------------------------
    def map_exists?(id)
      File.exists?(sprintf("Data/Map%03d.rvdata2", id))
    end
    #--------------------------------------------------------------------------
    # * Execute
    #--------------------------------------------------------------------------
    def run
      if $EDITOR
        skip_ee_run
      else
        skip_title = load_skip_info
        if skip_title.standard_mode
          skip_ee_run
        else
          unless map_exists?(skip_title.map_id)
            skip_ee_run
          else
            DataManager.init
            Audio.setup_midi if use_midi?
            DataManager.create_game_objects
            $game_party.setup_starting_members
            $game_map.setup(skip_title.map_id)
            $game_map.autoplay
            $game_player.moveto(*skip_title.coords)
            $game_player.refresh
            @scene = Scene_Map.new
            @scene.main while @scene
          end
        end
      end
    end
    #--------------------------------------------------------------------------
    # * Load Skip Info
    #--------------------------------------------------------------------------
    def load_skip_info
      file = $EDITOR ? '../Data/SkipTitle.rvdata2' : 'Data/SkipTitle.rvdata2'
      File.exists?(file) ? load_data(file) : RPG::Skip_Title.new
    end
  end
end

#==============================================================================
# ** SkipTitle_Map
#------------------------------------------------------------------------------
#  SkipTitle_Map
#==============================================================================
class SkipTitle_Map < GUI::Scrollable_Map
  #--------------------------------------------------------------------------
  # * Create Selector
  #--------------------------------------------------------------------------
  def create_selector
    @selector.dispose if @selector
    @selector = Sprite.new(@tile_viewport)
    @selector.bitmap = Bitmap.new(31,31)
    @selector.bitmap.fill_rect(0, 0, 31, 31, Color.new(0,0,0))
    @selector.bitmap.fill_rect(2, 2, 27, 27, Color.new(255,255,255, 200))
    @selector.bitmap.font.outline = false
    @selector.bitmap.font.size = 26
    @selector.bitmap.font.color = Color.new(255,0,0)
    @selector.bitmap.font.bold = true
    @selector.bitmap.draw_text(2,2,27,27, "S", 1)
    @selector.z = 0xfffffff
    @selector.visible = false
  end
  #--------------------------------------------------------------------------
  # * Recenter Camera
  #--------------------------------------------------------------------------
  def recenter_cam
    return unless Scene_SkipTitle.infos.map_id == @map_id
    x, y = *Scene_SkipTitle.infos.coords
    w = (2*(Graphics.width/3)-16)/32
    x = [0, [x, @map.width - w].min].max
    y = [0, [y, @map.height - ((416-16)/32)].min].max
    scroll_x = (x + @map.width) % @map.width
    scroll_y = (y + @map.height) % @map.height
    @tile_viewport.o(scroll_x*32, scroll_y*32)
  end
  #--------------------------------------------------------------------------
  # * Create Blank Plane
  #--------------------------------------------------------------------------
  def create_blank_plane
    @blank_plane.dispose if @blank_plane
    @blank_plane = Plane.new(@tile_viewport)
    @blank_plane.bitmap = Bitmap.new(500,500)
    @blank_plane.bitmap.fill_rect(0,0,500,500,Color.new(255,255,255))
    @blank_plane.opacity = 100
    @blank_plane.z = 0xffffffa
  end
  #--------------------------------------------------------------------------
  # * Object Initialize
  #--------------------------------------------------------------------------
  def initialize(id)
    @i = 0
    w = Graphics.width/3
    super(id, w, 34, 2*w, 416,true, false,true) 
    create_blank_plane
    create_selector
  end
  #--------------------------------------------------------------------------
  # * ReBuild Process
  #--------------------------------------------------------------------------
  def rebuild(id)
    @i = 0
    w = Graphics.width/3
    super(id, w, 34, 2*w, 416,true, false,true)
    create_blank_plane
    create_selector
  end
  #--------------------------------------------------------------------------
  # * Update process
  #--------------------------------------------------------------------------
  def update
    super
    update_selector
    update_click
    if @i < 24
      recenter_cam
      @i += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Update Selector
  #--------------------------------------------------------------------------
  def update_selector
    if Scene_SkipTitle.infos.map_id == @map_id
      @selector.visible = true
      @selector.x = Scene_SkipTitle.infos.coords[0] *32
      @selector.y = Scene_SkipTitle.infos.coords[1] *32
    else
      @selector.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # * Update click
  #--------------------------------------------------------------------------
  def update_click
    if Rect.new(@x, @y, @tile_viewport.true_width, @tile_viewport.true_height).hover?
      if Mouse.trigger?(:mouse_left)
        Scene_SkipTitle.infos.map_id = @map_id
        Scene_SkipTitle.infos.coords = [x_square, y_square]
        Scene_SkipTitle.infos.i_h = @tile_viewport.horizontal.index
        Scene_SkipTitle.infos.i_v = @tile_viewport.vertical.index
        save_data(Scene_SkipTitle.infos, '../Data/SkipTitle.rvdata2')
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @selector.dispose
  end
end

#==============================================================================
# ** Scene_Tables
#------------------------------------------------------------------------------
#  Table list
#==============================================================================

class Scene_SkipTitle < Scene_Base
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  class << self
    attr_accessor :infos
    Scene_SkipTitle.infos = SceneManager.load_skip_info
  end
  #--------------------------------------------------------------------------
  # * Object Initialize
  #--------------------------------------------------------------------------
  def start
    super
    @map_buttons = Hash.new
    @maps = Hash[load_data("../Data/MapInfos.rvdata2").sort{|l,r| l<=>r}]
    create_blank_bg
    create_title
    create_grid
    create_map_list
    create_checkbox
    create_end_button
  end
  #--------------------------------------------------------------------------
  # * Get the Current Id
  #--------------------------------------------------------------------------
  def current_id
    @maps[Scene_SkipTitle.infos.map_id] ? Scene_SkipTitle.infos.map_id : @maps.first[0]
  end
  #--------------------------------------------------------------------------
  # * Create Grid
  #--------------------------------------------------------------------------
  def create_grid
    w = Graphics.width/3
    h = Graphics.height
    f = (((2*w).to_f/544.0)*416.0).to_i
    @blank_bg.bitmap.fill_rect(w, 0, 2*w, h, Color.new(*([230]*3)))
    @viewport_list = GUI::Scrollable_Viewport.new(0, 34, w, h-76)
    @chose, @chose_square = Sprite.new, Sprite.new
    @chose.bitmap = GUI::create_box_bitmap(w, 18, Vocab.chose_map_start, 0, 1)
    @chose.y = @chose_square.y = 16
    @chose_square.x = w
    @chose_square.bitmap = GUI::create_box_bitmap(2*w, 18, Vocab.chose_sq_start, 0, 1)
    @scrollmap = SkipTitle_Map.new(current_id)
    @notify_sprite = Sprite.new
    @notify_sprite.x = w
    @notify_sprite.y = 450
    @notify_sprite.bitmap = GUI::create_box_bitmap(2*w, h-466, "")
    @old_x_square = @old_y_square = @old_id = 0
    @w = w
    @chose_std = GUI::create_button(0, h-40, w, 20, Vocab.preserve_title)
  end
  #--------------------------------------------------------------------------
  # * Create Checkbox
  #--------------------------------------------------------------------------
  def create_checkbox
    @checkbox = GUI::Checkbox.new(2, Graphics.height-38, Scene_SkipTitle.infos.standard_mode)
  end
  #--------------------------------------------------------------------------
  # * Create End button
  #--------------------------------------------------------------------------
  def create_end_button
    @end_button = Sprite.new
    @end_button.bitmap = GUI::create_beveled_bitmap(@w, 20)
    @end_button.bitmap.draw_text(0,0,@w,20, Vocab.save_edit, 1)
    @end_button.y = Graphics.height-20
  end
  #--------------------------------------------------------------------------
  # * Create Map List
  #--------------------------------------------------------------------------
  def create_map_list
    y = 0
    vw = @viewport_list.width
    w = (@maps.length * 16) > @viewport_list.height ? vw-16 : vw
    @maps.each do |k, m|
      spr = Sprite.new(@viewport_list)
      spr.bitmap = GUI::create_beveled_bitmap(w, 16)
      text = sprintf(" %03d - "+m.name, k)
      text = (text.length > 33) ? text[0..30]+"..." : text
      spr.bitmap.draw_text(0,0,w,16,text)
      spr.y = y
      y+=16
      @map_buttons[k] = spr
    end
  end
  #--------------------------------------------------------------------------
  # * Create Title
  #--------------------------------------------------------------------------
  def create_title
    @title = GUI.create_title(Vocab.skip_title)
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    super
    @viewport_list.update
    @scrollmap.update
    @checkbox.update
    update_notify
    update_list
    SceneManager.return if Keyboard.trigger?(:esc)
    if @end_button.rect.trigger?(:mouse_left)
      Scene_SkipTitle.infos.standard_mode = @checkbox.value
      save_data(Scene_SkipTitle.infos, '../Data/SkipTitle.rvdata2')
      msgbox(Vocab.modif_ok)
      SceneManager.goto(Scene_Editor_Main)
    end
  end
  #--------------------------------------------------------------------------
  # * Update List
  #--------------------------------------------------------------------------
  def update_list
    @map_buttons.each do |i, button|
      if button.rect.trigger?(:mouse_left) && @viewport_list.rect.hover?
        @scrollmap.rebuild(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Update notes
  #--------------------------------------------------------------------------
  def update_notify
    if @scrollmap.x_square != @old_x_square || @scrollmap.y_square != @old_y_square || @scrollmap.map_id != @old_id
      s = sprintf("Map n° %03d ", @scrollmap.map_id)
      s +=  sprintf(" X : %03d ", @scrollmap.x_square) + sprintf(" Y : %03d", @scrollmap.y_square)
      @notify_sprite.bitmap.clear
      @notify_sprite.bitmap = GUI::create_box_bitmap(2*@w, Graphics.height-450, s, 8)
      @old_x_square, @old_y_square = @scrollmap.x_square, @scrollmap.y_square
      @old_id = @scrollmap.map_id
    end
  end
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    @checkbox.dispose
    @chose.dispose
    @chose_square.dispose
    @chose_std.dispose
    @end_button.dispose
    @map_buttons.collect(&:dispose)
    @notify_sprite.dispose
    @scrollmap.dispose
    @title.dispose
    @viewport_list.dispose
  end
end