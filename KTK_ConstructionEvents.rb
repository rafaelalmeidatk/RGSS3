#==============================================================================
# KTK - Construction Events (v2.5)
# Criado por Fogomax (06/01/2015)
#------------------------------------------------------------------------------
# O script permite colocar eventos no mapa por meio do personagem. Muito 
# útil em construções e coisas relacionadas.
#------------------------------------------------------------------------------
# Como usar: http://www.mundorpgmaker.com.br/topic/108691-ktk-construction-events
#==============================================================================
 
module KTK_COEV
  #----------------------------------------------------------------------------
  # Início das configurações
  #----------------------------------------------------------------------------
  
  # Mapa com os eventos disponíveis
  Tools_Map = 1
  
  # Permitir a construção somente dentro de região estipulada?
  # True: sim | False: não
  Enable_Region = true
  
  # Por padrão, os eventos de construção terão o incremento de cursor liberado?
  # True: sim | False: não
  Dft_Enable_Increment = false
  
  # Por padrão, os eventos de construção terão quanto de incremento no cursor?
  Dft_Increment = 1
  
  # Tecla para ligar/desligar o incremento no cursor:
  Increment_Key = :Y
  
  # Ao abrir o menu/sair da cena do mapa (Scene_Map):
  # 1: Continuar no modo de construção
  # 2: Cancelar o modo de construção (recomendado)
  On_Change_Scene = 2
  
  # Ao trocar de mapa
  # 1: Continuar no modo de construção
  # 2: Cancelar o modo de construção (recomendado)
  On_Change_Map = 2
  
  # Mostrar a previsão do evento? Atenção: esse recurso só está disponível para
  # eventos na qual o nome do gráfico não contenha o comando $
  # True: sim | False: não
  Event_Preview = true
  
  # Opacidade da previsão que se alternará
  Event_Preview_Opacity = [200, 255]
  
  # Ativar grade para mostrar onde será possivel fazer a construção?
  # True: sim | False: não
  Enable_Grid = true
  
  # Tamanho de visão da grade (em tiles)
  Grid_Range = 2
  
  # Não exibir os tiles de construções proibidos na grade?
  # True: sim | False: não
  Remove_Deny_Grid = false
  
  # Cor de construção liberada
  Grid_Allow = Color.new(0, 170, 0, 125) # Verde
  
  # Cor de construção proibida
  Grid_Deny = Color.new(120, 0, 0, 125) # Vermelho
  
  # Negar construção contra evento com as prioridades:
  # 0 = Abaixo do jogador
  # 1 = Mesma do jogador
  # 2 = Acima do jogador
  Event_Pass = [0, 1, 2]
  
  #----------------------------------------------------------------------------
  # Fim das configurações
  #----------------------------------------------------------------------------
end
 
#==============================================================================
# Game_Map
#==============================================================================
class Game_Map
  attr_accessor :consev_grids, :grid_enabled, :ktk_ce_sprite_preview
  attr_reader :map_w, :map_h, :map_id, :actual_c_event
  
  #----------------------------------------------------------------------------
  # Alias method: setup
  #----------------------------------------------------------------------------
  alias ktk_co_ev_setup setup
  def setup(*a, &b)
    @consev_grids ||= []
    ktk_co_ev_setup(*a, &b)
    @map_w = @map.width
    @map_h = @map.height
    ce = $game_player.construction_event_enabled
    $game_player.disable_ktk_ce_grid if KTK_COEV::On_Change_Map == 2 && ce
  end
  
  #----------------------------------------------------------------------------
  # Alias method: initialize
  #----------------------------------------------------------------------------
  alias ktk_co_ev_initialize initialize
  def initialize(*a, &b)
    ktk_co_ev_initialize(*a, &b)
    @grid_enabled = false
    @ktk_ce_sprite_preview = Cons_Ev_Preview.new(nil, nil)
    @ktk_ce_saved_events = []
  end
  
  def ktk_ce_load_event(event_id)
    temp_map = load_data(sprintf("Data/Map%03d.rvdata2", KTK_COEV::Tools_Map))
    temp_map.events.each do |i, event|
      if event.id == event_id
        max_event_id = nil
        @events.values.each {|cevent|
          max_event_id = cevent.id if max_event_id == nil
          if cevent.id >= max_event_id
            max_event_id = cevent.id
          end
        }
        event.id = max_event_id + 1
        @write_event = event
        @actual_c_event = Game_Event.new(@map_id, event)
      end
    end
  end
  
  def ktk_ce_load_event_by_name(event_name)
    temp_map = load_data(sprintf("Data/Map%03d.rvdata2", KTK_COEV::Tools_Map))
    temp_map.events.each do |i, event|
      if event.name == event_name
        max_event_id = nil
        @events.values.each {|cevent|
          max_event_id = cevent.id if max_event_id == nil
          if cevent.id >= max_event_id
            max_event_id = cevent.id
          end
        }
        event.id = max_event_id + 1
        @write_event = event
        @actual_c_event = Game_Event.new(@map_id, event)
      end
    end
  end
  
  def ktk_add_const_events(s_event, x, y)
    new_event = s_event
    @events[new_event.id] = new_event
    @events[new_event.id].moveto(x.to_i, y.to_i)
    event = @write_event
    event.x = x.to_i
    event.y = y.to_i
    @ktk_ce_saved_events.push([event, @map_id])
    SceneManager.scene.spriteset.refresh_characters
  end
  
  alias ktk_ce_setup_events setup_events
  def setup_events(*a, &b)
    ktk_ce_setup_events(*a, &b)
    @ktk_ce_saved_events.each {|event, map_id|
      @events[event.id] = Game_Event.new(@map_id, event) if @map_id == map_id
    }
  end
end
 
#==============================================================================
# DataManager
#==============================================================================
class << DataManager
  #--------------------------------------------------------------------------
  # Alias method: save_game_without_rescue
  #--------------------------------------------------------------------------
  alias ktk_ce_save_game_without_rescue save_game_without_rescue
  def save_game_without_rescue(*a, &b)
    $game_map.ktk_ce_sprite_preview = nil
    ktk_ce_save_game_without_rescue(*a, &b)
  end
end
 
#==============================================================================
# Scene_Base
#==============================================================================
class Scene_Base
  #----------------------------------------------------------------------------
  # Alias method: start
  #----------------------------------------------------------------------------
  alias ktk_ce_b_start start
  def start(*a, &b)
    if SceneManager.scene_is?(Scene_Map)
      ce = $game_player.construction_event_enabled
      $game_player.disable_ktk_ce_grid if KTK_COEV::On_Change_Scene == 2 && ce
    end
    ktk_ce_b_start(*a, &b)
  end
end
 
#==============================================================================
# Scene_Map
#==============================================================================
class Scene_Map
  attr_accessor :spriteset
  
  #----------------------------------------------------------------------------
  # Alias method: initialize
  #----------------------------------------------------------------------------
  alias ktk_ce_start start
  def start(*a, &b)
    ktk_ce_start(*a, &b)
    @kplayer_last_x = -1
    @kplayer_last_y = -1
    if $game_player.construction_event_enabled
      @spriteset.ktk_ce_cursor.enabled = true
      $game_map.ktk_ce_sprite_preview.enable
    end
  end
  
  #----------------------------------------------------------------------------
  # Alias method: update
  #----------------------------------------------------------------------------
  alias ktk_update update
  def update(*a, &b)
    ktk_update(*a, &b)
    
    if $game_player.construction_event_enabled && Input.trigger?(KTK_COEV::Increment_Key)
      cr = SceneManager.scene.spriteset.ktk_ce_cursor
      unless $game_map.actual_c_event.enable_increment
        cr.deny_cursor_anim = true
        return
      end
      cr.increment_position ? cr.disable_increment_position : cr.enable_increment_position
    end
    
    if $game_player.construction_event_enabled && Input.trigger?(:C)
      event_id = $game_player.construction_event_id
      x = @spriteset.ktk_ce_cursor.cursor_x
      y = @spriteset.ktk_ce_cursor.cursor_y
      
      return if $game_player.moving? || (x == $game_player.x && y == $game_player.y)
      if @spriteset.ktk_ce_cursor.allow_construction
        $game_map.ktk_add_const_events($game_map.actual_c_event, x, y)
        $game_player.disable_ktk_ce_grid
      else
        SceneManager.scene.spriteset.ktk_ce_cursor.deny_cursor_anim = true
      end
    end
    
    if $game_map.grid_enabled
      unless @kplayer_last_x == $game_player.x && @kplayer_last_y == $game_player.y
        @kplayer_last_x = $game_player.x
        @kplayer_last_y = $game_player.y
        SceneManager.scene.spriteset.draw_ktk_ce_grid
      end
    end
  end
  
  #----------------------------------------------------------------------------
  # Alias method: terminate
  #----------------------------------------------------------------------------
  alias ktk_ce_terminate terminate
  def terminate(*a, &b)
    @spriteset.dispose_ktk_ce_grid
    @spriteset.ktk_ce_cursor.disable
    $game_map.ktk_ce_sprite_preview.disable
    ktk_ce_terminate(*a, &b)
  end
end
 
#==============================================================================
# Game_Player
#==============================================================================
class Game_Player
  attr_accessor :construction_event_enabled, :construction_event_id
  
  #----------------------------------------------------------------------------
  # Alias method: initialize
  #----------------------------------------------------------------------------
  alias ktk_ce_initialize initialize
  def initialize(*a, &b)
    ktk_ce_initialize(*a, &b)
    @construction_event_enabled = false
    @construction_event_id = 0
  end
  
  def initialize_ktk_ce_grid(event_id)
    return if event_id == 0
    @construction_event_enabled = true
    @construction_event_id = event_id
    $game_map.grid_enabled = true
    $game_map.ktk_ce_load_event(event_id)
    spriteset = SceneManager.scene.spriteset
    spriteset.draw_ktk_ce_grid
    spriteset.ktk_ce_cursor.enabled = true
    $game_map.ktk_ce_sprite_preview.enable
    $game_map.ktk_ce_sprite_preview.event = $game_map.actual_c_event
  end
  
  def initialize_ktk_ce_grid_by_name(event_name)
    @construction_event_enabled = true
    @construction_event_name = event_name
    $game_map.grid_enabled = true
    $game_map.ktk_ce_load_event_by_name(event_name)
    spriteset = SceneManager.scene.spriteset
    spriteset.draw_ktk_ce_grid
    spriteset.ktk_ce_cursor.enabled = true
    $game_map.ktk_ce_sprite_preview.enable
    $game_map.ktk_ce_sprite_preview.event = $game_map.actual_c_event
  end
  
  def disable_ktk_ce_grid
    @construction_event_enabled = false
    @construction_event_id = 0
    $game_map.grid_enabled = false
    spriteset = SceneManager.scene.spriteset
    spriteset.ktk_ce_cursor.disable_increment_position
    spriteset.ktk_ce_cursor.enabled = false
    spriteset.dispose_ktk_ce_grid
    $game_map.ktk_ce_sprite_preview.event = nil
  end
end
 
#==============================================================================
# Game_Interpreter
#==============================================================================
class Game_Interpreter
  def get_construction_event(event_id)
    $game_player.initialize_ktk_ce_grid(event_id)
  end
  
  def get_construction_event_by_name(event_name)
    $game_player.initialize_ktk_ce_grid_by_name(event_name)
  end
end
 
#==============================================================================
# Game_Event
#==============================================================================
class Game_Event
  attr_accessor :id, :event
  attr_reader :construction_region_ids, :remove_tile_priority, :remove_event_priority,
              :enable_increment, :increment
  
  #----------------------------------------------------------------------------
  # Alias method: initialize
  #----------------------------------------------------------------------------
  alias ktk_ce_initialize initialize
  def initialize(*a, &b)
    @construction_region_ids ||= []
    @remove_event_priority = false
    @remove_tile_priority = false
    @enable_increment = KTK_COEV::Dft_Enable_Increment
    @increment = KTK_COEV::Dft_Increment
    ktk_ce_initialize(*a, &b)
  end
  
  #----------------------------------------------------------------------------
  # Alias method: setup_page
  #----------------------------------------------------------------------------
  alias ktk_ce_setup_page setup_page
  def setup_page(*a, &b)
    ktk_ce_setup_page(*a, &b)
    ktk_ce_read_commands
  end
  
  def ktk_ce_read_commands
    return if @list.nil?
    for command in @list
      next unless command.code == 108 or command.code == 408
      command_l = command.parameters[0].to_s
      reg = command_l.match(/<construction_region_id=(\d+(?:\s*,\s*\d+)*)>/)
      if reg
        $1.scan(/\d+/).each { |regnum|
          @construction_region_ids.push(regnum.to_i)
        }
      end
      
      @remove_event_priority = true if command_l.include?("<remove_event_priority>")
      @remove_tile_priority = true if command_l.include?("<remove_tile_priority>")
      @enable_increment = true if command_l.include?("<enable_increment>")
      @increment = $1.to_i if command_l.match(/<increment=(\d+)>/)
    end
  end
end
 
#==============================================================================
# Spriteset_Map
#==============================================================================
class Spriteset_Map
  attr_accessor :ktk_ce_cursor
  
  #----------------------------------------------------------------------------
  # Alias method: initialize
  #----------------------------------------------------------------------------
  alias ktk_ce_initialize initialize
  def initialize(*a, &b)
    @ktk_ce_cursor = ConsEv_Cursor.new
    @ktk_ce_cursor.enabled = false
    if $game_map.ktk_ce_sprite_preview.nil?
      $game_map.ktk_ce_sprite_preview = Cons_Ev_Preview.new(nil, nil)
    end
    $game_map.ktk_ce_sprite_preview.cursor = @ktk_ce_cursor
    ktk_ce_initialize(*a, &b)
  end
  
  def draw_ktk_ce_grid
    return unless $game_player.construction_event_enabled
    $game_map.consev_grids.length.times {|i|
      $game_map.consev_grids[0].dispose
    }
    $game_map.map_h.times { |iy|
      $game_map.map_w.times { |ix|
        if ktk_ce_check_distance(ix, iy)
          if ktk_check_all_passages(ix, iy)
            $game_map.consev_grids.push(ConsEv_Grid.new(ix, iy, false))
          else
            unless KTK_COEV::Remove_Deny_Grid
              $game_map.consev_grids.push(ConsEv_Grid.new(ix, iy, true))
            end
          end
        end
      }
    }
  end
  
  def ktk_check_all_passages(x, y)
    if KTK_COEV::Enable_Region
      event = $game_map.actual_c_event
      if event.remove_tile_priority && event.remove_event_priority
        return ktk_check_region_pass(x, y)
      elsif event.remove_tile_priority
        return false unless ktk_check_event_pass(x, y)
        return ktk_check_region_pass(x, y)
      elsif event.remove_event_priority
        return false unless ktk_check_tile_pass(x, y)
        return ktk_check_region_pass(x, y)
      else
        return false unless ktk_check_tile_pass(x, y)
        return false unless ktk_check_event_pass(x, y)
        return ktk_check_region_pass(x, y)
      end
    else
      return false unless ktk_check_tile_pass(x, y)
      return false unless ktk_check_event_pass(x, y)
    end
    
    return true
  end
  
  def ktk_check_tile_pass(x, y)
    [2, 4, 6, 8].each {|dir|
      return false unless $game_player.map_passable?(x, y, dir)
    }
    return true
  end
  
  def ktk_check_event_pass(x, y)
    unless $game_map.events_xy_nt(x, y).empty?
      $game_map.events_xy_nt(x, y).each {|event|
        KTK_COEV::Event_Pass.each {|pass|
          return false if event.priority_type == pass
        }
      }
    end
    return true
  end
  
  def ktk_check_region_pass(x, y)
    final_result = false
    $game_map.actual_c_event.construction_region_ids.each {|id|
      final_result = true if $game_map.region_id(x, y) == id
    }
    return final_result
  end
  
  def dispose_ktk_ce_grid
    $game_map.consev_grids.length.times {|i|
      $game_map.consev_grids[0].dispose
    }
  end
  
  def ktk_ce_check_distance(x, y)
    dt = ((x - $game_player.x) * (x - $game_player.x))
    dt += ((y - $game_player.y ) * (y - $game_player.y ))
    dt = Math.sqrt(dt.abs)
    dt <= KTK_COEV::Grid_Range
  end
  
  #----------------------------------------------------------------------------
  # Alias method: update
  #----------------------------------------------------------------------------
  alias ktk_ce_update update
  def update(*a, &b)
    ktk_ce_update(*a, &b)
    $game_map.consev_grids.each {|grid| grid.update }
    @ktk_ce_cursor.update
    @ktk_ce_cursor.enabled = $game_player.construction_event_enabled
    $game_map.ktk_ce_sprite_preview.update
  end
end
 
#==============================================================================
# ConsEv_Grid
#==============================================================================
class ConsEv_Grid < Sprite
  def initialize(x, y, negative = false)
    super(nil)
    @x = x
    @y = y
    @negative = negative
    self.bitmap = Bitmap.new(32, 32)
    self.x = @x * 32
    self.y = @y * 32
    self.z = 900
  end
  
  def update
    self.bitmap.clear
    return unless KTK_COEV::Enable_Grid
    unless @negative
      self.bitmap.fill_rect(0, 0, 32, 32, KTK_COEV::Grid_Allow)
    else
      self.bitmap.fill_rect(0, 0, 32, 32, KTK_COEV::Grid_Deny)
    end
  end
  
  def dispose
    $game_map.consev_grids.delete(self) if $game_map.consev_grids.include?(self)
    super
  end
end
 
#==============================================================================
# ConsEv_Cursor
#==============================================================================
class ConsEv_Cursor < Sprite
  attr_accessor :enabled, :increment_position, :deny_cursor_anim
  attr_reader :cursor_x, :cursor_y, :allow_construction
  
  def initialize
    super(nil)
    @cursor = Cache.picture("cons_cursor.png")
    self.bitmap = Bitmap.new(32, 32)
    self.z = 901
    @frame = 0
    @frame_tick = 0
    @enabled = true
    @cursor_x = 0
    @cursor_y = 0
    @allow_construction = true
    @increment_position = false
    @deny_cursor_anim = false
    @deny_frame = 0
    @deny_tick = 0
  end
  
  def update
    self.bitmap.clear
    return unless @enabled
    
    selfx_p = $game_player.real_x
    selfy_p = $game_player.real_y
    
    increment_amount = $game_map.actual_c_event.increment
    
    case $game_player.direction
    when 2
      selfy_p += @increment_position ? increment_amount : 0
      
      @cursor_x = $game_player.x
      @cursor_y = $game_player.y + 1
      
      self.x = selfx_p * 32
      self.y = (selfy_p * 32) + 32
    when 4
      selfx_p -= @increment_position ? increment_amount : 0
      
      @cursor_x = selfx_p - 1
      @cursor_y = selfy_p
      
      self.x = (selfx_p * 32) - 32
      self.y = selfy_p * 32
    when 6
      selfx_p += @increment_position ? increment_amount : 0
      
      @cursor_x = selfx_p + 1
      @cursor_y = selfy_p
      
      self.x = (selfx_p * 32) + 32
      self.y = selfy_p * 32
    when 8
      selfy_p -= @increment_position ? increment_amount : 0
      
      @cursor_x = selfx_p
      @cursor_y = selfy_p - 1
      
      self.x = selfx_p * 32
      self.y = (selfy_p * 32) - 32
    end
      
    if @frame_tick >= 15
      @frame += 1
      @frame = 0 if @frame >= 2
      @frame_tick = 0
    else
      @frame_tick += 1
    end
    
    if SceneManager.scene.spriteset.ktk_check_all_passages(@cursor_x, @cursor_y)
      @allow_construction = true
    else
      @allow_construction = false
    end
    
    if @deny_cursor_anim
      if (@deny_tick >= 10)
        @deny_frame += 1
        @deny_frame = 0 if @deny_frame >= 2
        @deny_tick = 0
        @deny_cursor_anim = false
      else
        @deny_tick += 1
      end
    end
    
    x = 32 * @frame
    if @deny_cursor_anim
      inverse = @allow_construction ? 32 : 0
      rect = Rect.new(x, inverse, 32, 32)
    else
      rect = @allow_construction ? Rect.new(x, 0, 32, 32) : Rect.new(x, 32, 32, 32)
    end
    
    self.bitmap.blt(0, 0, @cursor, rect)
  end
  
  def enable_increment_position
    @increment_position = true
  end
  
  def disable_increment_position
    @increment_position = false
  end
  
  def disable
    @enabled = false
    self.bitmap.clear
  end
  
  def dispose
    super
  end
end
 
#==============================================================================
# Cons_Ev_Preview
#==============================================================================
class Cons_Ev_Preview < Sprite
  attr_accessor :cursor, :event
  
  def initialize(cursor, event)
    super(nil)
    @event = event
    @x = x
    @y = y
    @cursor = cursor
    @opacity_tick = 0
    @opacity_frame = 0
    @enabled = false
    self.x = @x * 32
    self.y = @y * 32
    self.z = 990
    self.bitmap = Bitmap.new(1, 1)
  end
  
  def draw_event
    bitmap = Cache.character(@event.character_name)
    sign = @event.character_name[/^[\!\$C]./]
    r = false
    if sign && sign.include?('$')
      cw = bitmap.width / 3
      ch = bitmap.height / 4
      r = true
    else
      cw = bitmap.width / 12
      ch = bitmap.height / 8
    end
    return if r
    n = @event.character_index
    src_rect = Rect.new((n%4*3+1)*cw, (n/4*4)*ch, cw, ch)
    self.bitmap = Bitmap.new(cw, ch)
    o = KTK_COEV::Event_Preview_Opacity
    self.opacity = @opacity_frame == 0 ? o[0] : o[1]
    self.bitmap.blt(0, 0, bitmap, src_rect)
    self.x = @cursor.x + (cw > 32 ? (cw * -1 + 32) : 0)
    self.y = @cursor.y + (ch > 32 ? (ch * -1 + 32) : 0)
  end
  
  def update
    super
    return unless KTK_COEV::Event_Preview
    self.bitmap.clear
    return if @cursor == nil || @event == nil || @enabled == false
    self.x = @cursor.x
    self.y = @cursor.y
    if @opacity_tick >= 15
      @opacity_frame = @opacity_frame == 0 ? 1 : 0
      @opacity_tick = 0
    else
      @opacity_tick += 1
    end
    draw_event
  end
  
  def enable
    @enabled = true
  end
  
  def disable
    @enabled = false
    self.bitmap.clear
  end
  
  def dispose
    super
  end
end
