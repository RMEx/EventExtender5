=begin
 Event Extender 5
 Database Module
 ===============================================================================
 http://www.biloucorp.com
 ===============================================================================
 By Nuki, Raho, Zangther, Grim, Joke and Hiino
 
 Inspiration : Avygeil
=end

#==============================================================================
# ** Types
#------------------------------------------------------------------------------
# Implements the Type System
#==============================================================================

module Types
  #--------------------------------------------------------------------------
  # * Singleton
  #--------------------------------------------------------------------------
  extend self
  #--------------------------------------------------------------------------
  # * Type Enum
  #--------------------------------------------------------------------------
  def enum
    {
      string:           [:to_s,       ""      ],
      integer:          [:to_i,       0       ],
      float:            [:to_f,       0.0     ],
      boolean:          [:to_bool,    false   ],
      polymorphic:      [:nothing,    nil     ]
    }
  end
  #==============================================================================
  # ** Handler
  #------------------------------------------------------------------------------
  # Implements the Type System
  #==============================================================================
  module Handler
    #--------------------------------------------------------------------------
    # * String representation
    #--------------------------------------------------------------------------
    def string(field_name)
      @first_string ||= field_name
      handle_field(:string, field_name.to_sym)
    end
    #--------------------------------------------------------------------------
    # * Integer representation
    #--------------------------------------------------------------------------
    def integer(field_name)
      handle_field(:integer, field_name.to_sym)
    end
    #--------------------------------------------------------------------------
    # * Floating point number representation
    #--------------------------------------------------------------------------
    def float(field_name)
      handle_field(:float, field_name.to_sym)
    end
    #--------------------------------------------------------------------------
    # * Boolean representation
    #--------------------------------------------------------------------------
    def boolean(field_name)
      handle_field(:boolean, field_name.to_sym)
    end
    #--------------------------------------------------------------------------
    # * Polymorphic type representation
    #--------------------------------------------------------------------------
    def polymorphic(field_name)
      handle_field(:polymorphic, field_name.to_sym)
    end
  end
end

#==============================================================================
# ** Database
#------------------------------------------------------------------------------
# Representation of an Abstract Database
#==============================================================================

module Database
  
  #==============================================================================
  # ** Entry_Viewer
  #------------------------------------------------------------------------------
  # Representation of an Entry
  #==============================================================================
  
  class Entry_Viewer
    #--------------------------------------------------------------------------
    # * Public instance Variables
    #--------------------------------------------------------------------------
    attr_reader :visible, :disposed, :inputs, :primary_key
    alias :disposed? :disposed
    alias :visible?  :visible
    #--------------------------------------------------------------------------
    # * Object Initialize
    #--------------------------------------------------------------------------
    def initialize(table, pk, x, y, w, vp = nil)
      @disposed = false
      @visible = true
      @width = w
      @x, @y = x, y
      @viewport = vp
      @table, @primary_key = table, pk
      @instance = Database.tables[@table][@primary_key]
      create_block
    end
    #--------------------------------------------------------------------------
    # * Create Field Blocks
    #--------------------------------------------------------------------------
    def create_block
      @fields_sprites = {}
      @inputs = {}
      y = @y
      Object.const_get(@table).fields.each do |name, type|
        temp_sprite = Sprite.new(@viewport)
        title = name.to_s + " : "+type.to_s
        title += " - Primary Key" if name == Object.const_get(@table).get_primary_key
        temp_sprite.bitmap = GUI::create_gui_bitmap(@width, 44, title, 0, 18)
        temp_sprite.x, temp_sprite.y = @x, y
        temp_sprite.opacity = 100 if name == Object.const_get(@table).get_primary_key
        value = @instance.send(name)
        input = case type
        when :boolean
          GUI::Checkbox.new(@x+4, y+22, value, 100, @viewport)
        when :integer
          GUI::IntField.new(@x+2, y+22, @width-6, value, 16, -1, @viewport)
        when :float
          GUI::FloatField.new(@x+2, y+22, @width-6, value.to_s, 16, @viewport)
        else
          GUI::KeyField.new(@x+2, y+22, @width-6, value.to_s, 16, @viewport)
        end
        @fields_sprites[name] = temp_sprite
        @inputs[name] = input
        y += 48
      end
    end
    #--------------------------------------------------------------------------
    # * Dispose
    #--------------------------------------------------------------------------
    def dispose
      @disposed = true
      @fields_sprites.values.collect!(&:dispose)
      @inputs.values.collect!(&:dispose)
    end
    #--------------------------------------------------------------------------
    # * Visible
    #--------------------------------------------------------------------------
    def visible=(v)
      @visible = v
      @fields_sprites.values.each{|x|x.visible = v}
      @inputs.values.each{|x|x.visible = v}
    end
    #--------------------------------------------------------------------------
    # * Update
    #--------------------------------------------------------------------------
    def update
      return if @disposed || !@visible
      @inputs.each do |k,x|
        x.update if k != Object.const_get(@table).get_primary_key
      end
    end
  end  
  
  #==============================================================================
  # ** Table
  #------------------------------------------------------------------------------
  # Representation of an Abstract Table
  #==============================================================================  
  
  class Table
    #--------------------------------------------------------------------------
    # * Append Type system
    #--------------------------------------------------------------------------
    extend Types::Handler
    #--------------------------------------------------------------------------
    # * Singleton
    #--------------------------------------------------------------------------
    class << self
      #--------------------------------------------------------------------------
      # * Public instance variables
      #--------------------------------------------------------------------------
      attr_accessor :fields, :classname, :first_string
      #--------------------------------------------------------------------------
      # * Get Path
      #--------------------------------------------------------------------------
      def path
        $EDITOR ? "../Database/" : "Database/"
      end
      #--------------------------------------------------------------------------
      # * Get RVDATA Path
      #--------------------------------------------------------------------------
      def rvpath
        $EDITOR ? "../Data/EEDatabase.rvdata2" : "Data/EEDatabase.rvdata2"
      end
      #--------------------------------------------------------------------------
      # * Field handling
      #--------------------------------------------------------------------------
      def handle_field(type, name)
        @classname    ||= self.to_s.to_sym
        @fields       ||= Hash.new 
        @fields[name] = type
        instance_variable_set("@#{name}".to_sym, Types.enum[type][1])
        send(:attr_accessor, name)
      end
      #--------------------------------------------------------------------------
      # * Get Primary Key
      #--------------------------------------------------------------------------
      def get_primary_key; @primary_key; end
      #--------------------------------------------------------------------------
      # * Define Primary Key
      #--------------------------------------------------------------------------
      def primary_key(field)
        unless @fields.has_key?(field)
          raise(ArgumentError, "Field doesn't exists")
        end
        @primary_key = field
        Database.tables[@classname] ||= Hash.new
        create_dir if $TEST
      end
      #--------------------------------------------------------------------------
      # * Create Dir
      #--------------------------------------------------------------------------
      def create_dir
        Dir.mkdir(path, 0777) unless Dir.exists?(path)
        create_layout unless File.exists?(Database::Table.path+"#{@classname}.csv")
      end
      #--------------------------------------------------------------------------
      # * Create Layout
      #--------------------------------------------------------------------------
      def create_layout
        layout = @fields.keys.join(";") << "\n"
        File.open(Database::Table.path+"#{@classname}.csv", "w+") {|f| f.write(layout) }
      end
      #--------------------------------------------------------------------------
      # * Insert
      #--------------------------------------------------------------------------
      def insert(args)
        data = File.read(args).split("\n")
        return if data[1..-1].empty?
        data.collect!{|x|x.split(";")}
        names = data[0].collect(&:to_sym)
        data[1..-1].each do |line|
          h = Hash.new
          raise "#{@classname} : #{Vocab.table_error}" unless line.length == @fields.length
          line.each.with_index do |row, i|
            type = @fields[names[i]]
            v = case type
            when :polymorphic
              begin
                eval(row)
              rescue Exception => exc
                nil
              end
            when :boolean
              begin
                eval(row)
              rescue Exception => exc
                false
              end
            else
              row.send(Types.enum[type][0])
            end
            h[names[i]] = v
          end
          self.send(:new, h)
        end
      end
      #--------------------------------------------------------------------------
      # * Privatisation
      #--------------------------------------------------------------------------
      private :create_dir, :create_dir, :new
    end
    #--------------------------------------------------------------------------
    # * Object initialize
    #--------------------------------------------------------------------------
    def initialize(args)
      args.each do |key, value|
        type = self.class.fields[key]
        insertion = Types.enum[type][1]
        flag = value.respond_to?(Types.enum[type][0])
        insertion = value.send(Types.enum[type][0]) if flag
        instance_variable_set("@#{key}".to_sym, insertion)
      end
      Database.tables[self.class.classname] ||= Hash.new
      index = send(self.class.get_primary_key)
      Database.tables[self.class.classname][index] = self
    end
  end
  #--------------------------------------------------------------------------
  # * Singleton of Database
  #--------------------------------------------------------------------------
  class << self
    #--------------------------------------------------------------------------
    # * Public instance variables
    #--------------------------------------------------------------------------
    attr_accessor :tables
    #--------------------------------------------------------------------------
    # * API for tables
    #--------------------------------------------------------------------------
    Database.tables = Hash.new
    #--------------------------------------------------------------------------
    # * Method Missing
    #--------------------------------------------------------------------------
    def method_missing(method, *args)
      tables[method] || (raise(NoMethodError))
    end
    #--------------------------------------------------------------------------
    # * Rebuild Table File
    #--------------------------------------------------------------------------
    def rebuild(table)
      fields = Object.const_get(table).fields
      layout = fields.keys.join(";") << "\n"
      File.open(Database::Table.path+"#{table.to_s}.csv", "w+") {|f| f.write(layout) }
      Database.tables[table] = {}
      save_data(Database.tables,Database::Table.rvpath) 
    end
    #--------------------------------------------------------------------------
    # * Rebuild Table File (with entries)
    #--------------------------------------------------------------------------
    def rebuild_with_entries(table)
      fields = Object.const_get(table).fields
      layout = fields.keys.join(";") << "\n"
      Database.tables[table].each do |key, value|
        row = []
        fields.each{|k,v|row << value.send(k)}  
        row = row.join(';') << "\n"
        layout += row
      end
      File.open(Database::Table.path+"#{table.to_s}.csv", "w+") {|f| f.write(layout) }
      save_data(Database.tables,Database::Table.rvpath) 
    end
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
    alias :ee_init :init
    #--------------------------------------------------------------------------
    # * Initialize Module
    #--------------------------------------------------------------------------
    def init
      create_db_rvdata if $TEST
      Database.tables = load_data(Database::Table.rvpath)
      ee_init
    end
    #--------------------------------------------------------------------------
    # * Create RVDATA from csv
    #--------------------------------------------------------------------------
    def create_db_rvdata
      if Dir.exists?(Database::Table.path)
        tables = Database.tables.keys.collect(&:to_s)
        tables.each do |f|
          if File.exists?(Database::Table.path+"#{f}.csv")
            klass = Object.const_get(f)
            klass.insert(Database::Table.path+"/#{f}.csv")
          end
        end
      end
      save_data(Database.tables,Database::Table.rvpath) 
    end
  end
end

#==============================================================================
# ** Scene_Tables
#------------------------------------------------------------------------------
#  Table list
#==============================================================================

class Scene_Tables < Scene_Base
  #--------------------------------------------------------------------------
  # * Object Initialize
  #--------------------------------------------------------------------------
  def start
    super
    if $EDITOR
      create_blank_bg
    else
      create_background
    end
    create_block
    create_viewport
    create_table_list
  end
  #--------------------------------------------------------------------------
  # * Create BGBlock
  #--------------------------------------------------------------------------
  def create_block
    @background = Sprite.new
    @background.bitmap = GUI::create_gui_bitmap(Graphics.width, Graphics.height, Vocab.table_list)
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
  end
  #--------------------------------------------------------------------------
  # * Create Viewport
  #--------------------------------------------------------------------------
  def create_viewport
    @viewport = GUI::Scrollable_Viewport.new(2, 32, Graphics.width-4, Graphics.height-34)
  end
  #--------------------------------------------------------------------------
  # * Create Table List
  #--------------------------------------------------------------------------
  def create_table_list
    if Database.tables.length == 0
      create_empty_box
      return
    end
    create_tables_modules
  end
  #--------------------------------------------------------------------------
  # * Create Tables Modules
  #--------------------------------------------------------------------------
  def create_tables_modules
    @sprite_tables = Hash.new
    @drop_tables = Hash.new
    @add_rows = Hash.new
    @entries = Hash.new
    f = (Database.tables.length * (54+16))
    w = (f > @viewport.height) ? @viewport.width - 32 : @viewport.width - 16
    x = 8
    i = 0
    Database.tables.keys.sort.each do |key|
      temp_spr = Sprite.new(@viewport)
      temp_spr.bitmap = GUI::create_gui_bitmap(w, 54, key.to_s, 0, 22)
      temp_spr.bitmap.font.bold = false
      len = Database.tables[key].length
      str = len.to_s + " " + Vocab.entries(len)
      temp_spr.bitmap.draw_text(0, 0, w-2, 22, str, 2)
      temp_spr.x = x
      temp_spr.y = 16 + (i* (54+16))
      @sprite_tables[key] = temp_spr
      @add_rows[key] = GUI::create_button(x + 106, temp_spr.y+24, 100, 26, Vocab.add_row, @viewport)
      @entries[key] = GUI::create_button(x + 4, temp_spr.y+24, 100, 26, Vocab.entries(len), @viewport)
      @drop_tables[key] = GUI::create_button(x + w - 100 - 4, temp_spr.y+24, 100, 26, Vocab.empty, @viewport)
      if len == 0
        @entries[key].opacity = 120 
        @drop_tables[key].opacity = 120
      end
      i += 1
      @viewport.update
    end
  end
  #--------------------------------------------------------------------------
  # * Create Empty Box
  #--------------------------------------------------------------------------
  def create_empty_box
    @empty_box = Sprite.new(@viewport)
    @empty_box.bitmap = GUI::create_gui_bitmap(Graphics.width-8, 38, "", 1, 2)
    @empty_box.x, @empty_box.y = 2, 16
    @empty_box.bitmap.font.color = Color.new(32, 95, 140)
    @empty_box.bitmap.draw_text(2, 2, Graphics.width-10, 36, Vocab.table_empty, 1)
  end
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    super
    update_drop
    update_add
    update_entries
    @viewport.update
    if Keyboard.any?(:trigger?, :esc, Configuration::KEY_DATABASE)
      $game_system.menu_disabled = $game_temp.menu_disabled
      SceneManager.return 
    end
  end
  #--------------------------------------------------------------------------
  # * Update entries processing
  #--------------------------------------------------------------------------
  def update_entries
    f = @entries.keys.find do |key|
      len = Database.tables[key].length
      @entries[key].rect.trigger?(:mouse_left) && len > 0
    end
    if f
      $game_temp.current_table = f
      $game_temp.current_entry = Database.send(f).first[0]
      SceneManager.call(Scene_Entries)
    end
  end
  #--------------------------------------------------------------------------
  # * Update add processing
  #--------------------------------------------------------------------------
  def update_add
    f = @add_rows.keys.find do |key|
      @add_rows[key].rect.trigger?(:mouse_left)
    end
    if f
      $game_temp.current_table = f
      $game_temp.current_entry = nil
      SceneManager.call(Scene_Add_Entry)
    end
  end
  #--------------------------------------------------------------------------
  # * Update drop processing
  #--------------------------------------------------------------------------
  def update_drop
    f = @drop_tables.keys.find do |key|
      len = Database.tables[key].length
      @drop_tables[key].rect.trigger?(:mouse_left) && len > 0
    end
    if f
      dialog = GUI::alert(Vocab.warning, Vocab.empty_db(f.to_s))
      if dialog == 1
        if File.exists?(Database::Table.path+"#{f.to_s}.csv")
          Database.rebuild(f)
          SceneManager.goto(Scene_Tables)
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    @background.dispose
    @background_sprite.dispose if @background_sprite
    @viewport.dispose
    if @empty_box
       @empty_box.dispose 
    else
      @sprite_tables.values.collect!(&:dispose)
      @drop_tables.values.collect!(&:dispose)
      @add_rows.values.collect!(&:dispose)
      @entries.values.collect!(&:dispose)
    end
  end
end

#==============================================================================
# ** Scene_Add_Entry
#------------------------------------------------------------------------------
#  Add entry
#==============================================================================

class Scene_Add_Entry < Scene_Base
  #--------------------------------------------------------------------------
  # * Object Initialize
  #--------------------------------------------------------------------------
  def start
    super
    @table = Object.const_get($game_temp.current_table)
    @fields = @table.fields
    if $EDITOR
      create_blank_bg
    else
      create_background
    end
    create_block
    create_viewport
    create_buttons
    create_fields
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
  end
  #--------------------------------------------------------------------------
  # * Create BGBlock
  #--------------------------------------------------------------------------
  def create_block
    s = Vocab.table_add($game_temp.current_table)
    @background = Sprite.new
    @background.bitmap = GUI::create_gui_bitmap(Graphics.width, Graphics.height, s)
  end
  #--------------------------------------------------------------------------
  # * Create Viewport
  #--------------------------------------------------------------------------
  def create_viewport
    w = Graphics.width-180
    @viewport = GUI::Scrollable_Viewport.new(4, 32, w, Graphics.height-34)
  end
  #--------------------------------------------------------------------------
  # * Create Buttons
  #--------------------------------------------------------------------------
  def create_buttons
    x = @viewport.x + @viewport.width + 4
    y = 34
    w = 168
    @save = GUI::create_button(x, y, w, 26, Vocab.save)
    y += 28
    @quit = GUI::create_button(x, y, w, 26, Vocab.quit)
  end
  #--------------------------------------------------------------------------
  # * Create fields
  #--------------------------------------------------------------------------
  def create_fields
    @field_sprite = {}
    @inputs = {}
    w = @viewport.width - 8
    f = 16 + (@fields.length * (66))
    w -= 16 if f > @viewport.height
    x = 4
    y = 16
    @fields.each do |name, type|
      temp_sprite = Sprite.new(@viewport)
      title = name.to_s + " : "+type.to_s
      title += " - Primary Key" if name == @table.get_primary_key
      temp_sprite.bitmap = GUI::create_gui_bitmap(w, 50, title, 0, 22)
      temp_sprite.x, temp_sprite.y = x, y
      input = case type
      when :boolean
        GUI::Checkbox.new(x+4, y+26, true, 100, @viewport)
      when :integer
        GUI::IntField.new(x+2, y+22, w-4, 0, 22, -1, @viewport)
      when :float
        GUI::FloatField.new(x+2, y+22, w-4, "", 22, @viewport)
      else
        GUI::KeyField.new(x+2, y+22, w-4, "", 22, @viewport)
      end
      y += 66
      @inputs[name] = input
      @field_sprite[name] = temp_sprite
      @viewport.update
    end
  end
  #--------------------------------------------------------------------------
  # * Update Processing
  #--------------------------------------------------------------------------
  def update
    super
    update_esc
    update_save
    @inputs.each do |k, v|
      v.update
    end
    @viewport.update
  end
  #--------------------------------------------------------------------------
  # * Update SAVE Processing
  #--------------------------------------------------------------------------
  def update_save
    return unless @save.rect.trigger?(:mouse_left)
    list_value = []
    pk = @inputs[@table.get_primary_key].value
    if Database.tables[@table.to_s.to_sym].keys.find{|x|x==pk}
      msgbox(Vocab.table_not_uniq)
      return
    end
    @fields.each do |name, type|
      v = @inputs[name].value
      v = case type 
      when :polymorphic
        begin
          eval(v)
        rescue Exception => exc
          nil
        end
      else
        v.send(Types.enum[type][0])
      end
      list_value << v
    end
    process_save(list_value)
  end
  #--------------------------------------------------------------------------
  # * Update ESC Processing
  #--------------------------------------------------------------------------
  def update_esc
    if Keyboard.trigger?(:esc) || @quit.rect.trigger?(:mouse_left)
      dialog = GUI::alert(Vocab.warning, Vocab.table_add_quit)
      if dialog == 1
        SceneManager.return
      end
    end
  end
  #--------------------------------------------------------------------------
  # * SAVE Processing
  #--------------------------------------------------------------------------
  def process_save(list)
    unless File.exists?(Database::Table.path+"#{@table.to_s}.csv")
      Database.rebuild($game_temp.current_table)
    end
    str = list.collect(&:to_s).join(";")<<"\n"
    File.open(Database::Table.path+"#{@table.to_s}.csv", "a") {|f| f.write(str) }
    DataManager.create_db_rvdata
    Database.tables = load_data(Database::Table.rvpath)
    msgbox(Vocab.table_saved)
    SceneManager.return
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    @save.dispose
    @quit.dispose
    @background.dispose
    @background_sprite.dispose if @background_sprite
    @inputs.values.collect(&:dispose)
  end
end

#==============================================================================
# ** Scene_Entries
#------------------------------------------------------------------------------
#  View Entries List
#==============================================================================

class Scene_Entries < Scene_Base
  #--------------------------------------------------------------------------
  # * Object Initialize
  #--------------------------------------------------------------------------
  def start
    super
    @table = Object.const_get($game_temp.current_table)
    @fields = @table.fields
    @entries = Database.tables[$game_temp.current_table]
    if $EDITOR
      create_blank_bg
    else
      create_background
    end
    create_block
    create_viewport
    create_list
  end
  #--------------------------------------------------------------------------
  # * Create Background
  #--------------------------------------------------------------------------
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
  end
  #--------------------------------------------------------------------------
  # * Create BGBlock
  #--------------------------------------------------------------------------
  def create_block
    s = Vocab.table_entries($game_temp.current_table)
    @background = Sprite.new
    @background.bitmap = GUI::create_gui_bitmap(Graphics.width, Graphics.height, s)
  end
  #--------------------------------------------------------------------------
  # * Create Viewport
  #--------------------------------------------------------------------------
  def create_viewport
    w = (Graphics.width-4)/2
    @viewport_list = GUI::Scrollable_Viewport.new(4, 68, w, Graphics.height-72)
    x = @viewport_list.x + @viewport_list.width
    @viewport_elt = GUI::Scrollable_Viewport.new(x, 68, w, Graphics.height-108)
    y = 32+2
    @erase = GUI::create_button(8, y+4, w-4, 26, Vocab.erase_selection)
    @erase_elt = GUI::create_button(w+8, y+4, w-8, 26, Vocab.erase_elt)
    @save_edit = GUI::create_button(w+8, Graphics.height-32, w-8, 26, Vocab.save_edit)
  end
  #--------------------------------------------------------------------------
  # * Create List
  #--------------------------------------------------------------------------
  def create_list
    @entries_box = {}
    @list_checkbox = {}
    y = 8
    fh = y + (@entries.length * (26))
    w = @viewport_list.width - 8
    w -= 16 if fh > @viewport_list.height
    @entries.each do |k,entry|
      i = $game_temp.current_index || 0
      @viewport_list.vertical.index = i
      @viewport_list.vertical.update
      str = k.to_s 
      str += " - #{entry.send(@table.first_string)}" if @table.first_string
      @entries_box[k] = Sprite.new(@viewport_list)
      @entries_box[k].bitmap = GUI::create_box_bitmap(w, 24, str, 20)
      @entries_box[k].x = 4
      @entries_box[k].y = y
      @list_checkbox[k] = GUI::Checkbox.new(8, y+4, false, 100, @viewport_list)
      @viewport_list.update
      y += 26
    end
    @module = Database::Entry_Viewer.new(
      $game_temp.current_table, 
      $game_temp.current_entry, 
      6, 6, ((Graphics.width-4)/2)-32, @viewport_elt
    )
    
  end
  #--------------------------------------------------------------------------
  # * Update Processing
  #--------------------------------------------------------------------------
  def update
    super
    update_module
    process_delete_list if @erase.rect.trigger?(:mouse_left)
    process_delete_elt if @erase_elt.rect.trigger?(:mouse_left)
    process_update if @save_edit.rect.trigger?(:mouse_left)
    @viewport_list.update
    @viewport_elt.update
    @module.update
    @list_checkbox.values.collect!(&:update)
    if Keyboard.trigger?(:esc) 
      $game_temp.current_index = 0
      SceneManager.return 
    end
  end
  #--------------------------------------------------------------------------
  # * Update Module
  #--------------------------------------------------------------------------
  def update_module
    return unless Mouse.trigger?(:mouse_left)
    f = @entries.keys.find do |k|
      @entries_box[k].rect.hover? && !@list_checkbox[k].rect.hover?
    end
    if f
      $game_temp.current_entry = f
      $game_temp.current_index = @viewport_list.vertical.index
      SceneManager.goto(Scene_Entries)
    end
  end
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    @erase.dispose
    @erase_elt.dispose
    @save_edit.dispose
    @module.dispose
    @list_checkbox.values.collect!(&:dispose)
    @entries_box.values.collect!(&:dispose)
    @viewport_elt.dispose
    @viewport_list.dispose
    @background.dispose
    @background_sprite.dispose if @background_sprite
  end
  #--------------------------------------------------------------------------
  # * Save Entries
  #--------------------------------------------------------------------------
  def process_update
    @fields.each do |name, type|
      v = @module.inputs[name].value
      v = case type 
      when :polymorphic
        begin
          eval(v)
        rescue Exception => exc
          nil
        end
      else
        v.send(Types.enum[type][0])
      end
      Database.tables[@table.to_s.to_sym][$game_temp.current_entry].send(name.to_s+"=", v)
    end
    Database.rebuild_with_entries($game_temp.current_table)
    msgbox(Vocab.table_saved)
    SceneManager.goto(Scene_Entries)
  end
  #--------------------------------------------------------------------------
  # * Erase elt
  #--------------------------------------------------------------------------
  def process_delete_elt
    dialog = GUI::alert(Vocab.warning, Vocab.empty_selection(@table.to_s, 1))
    if dialog == 1
      Database.tables[$game_temp.current_table].delete($game_temp.current_entry)
      $game_temp.current_entry = Database.tables[$game_temp.current_table].keys.first
      Database.rebuild_with_entries($game_temp.current_table)
      $game_temp.current_index = @viewport_list.vertical.index
      scene = (Database.tables[$game_temp.current_table].length == 0) ? Scene_Tables : Scene_Entries
      SceneManager.goto(scene)
    end
  end
  #--------------------------------------------------------------------------
  # * Erase List
  #--------------------------------------------------------------------------
  def process_delete_list
    list =   @list_checkbox.select{|key, x| x.value}.keys
    return if !list || list.length == 0
    dialog = GUI::alert(Vocab.warning, Vocab.empty_selection(@table.to_s, list.length))
    if dialog == 1
      list.each{|v| Database.tables[$game_temp.current_table].delete(v)}
      $game_temp.current_entry = Database.tables[$game_temp.current_table].keys.first
      Database.rebuild_with_entries($game_temp.current_table)
      $game_temp.current_index = @viewport_list.vertical.index
      scene = (Database.tables[$game_temp.current_table].length == 0) ? Scene_Tables : Scene_Entries
      SceneManager.goto(scene)
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
  attr_accessor :current_table, :current_entry, :menu_disabled, :current_index
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
  alias :db_extender_update    :update
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    db_extender_update
    if Keyboard.trigger?(Configuration::KEY_DATABASE) && $TEST
      $game_temp.menu_disabled = $game_system.menu_disabled
      SceneManager.call(Scene_Tables) 
    end
  end
end