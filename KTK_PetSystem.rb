#==============================================================================
# KTK - Pet System
# Criado por Fogomax
#------------------------------------------------------------------------------
# Dá vida a um mascote que segue o jogador em sua jornada, fornecendo ajuda
# com habilidades únicas e atributos bônus.
#==============================================================================
 
module KTK_PS
  #----------------------------------------------------------------------------
  # Início da configuração
  #----------------------------------------------------------------------------
  # Observação:
  # Sim: true | Não: false
  #----------------------------------------------------------------------------
  
  # Exibir opção de mascote no menu principal?
  Pet_Menu = true
  
  # Ativar habilidades do mascote?
  Enable_Pet_Skills = true
  
  # Utilizar uma switch para determinar se as habiliades podem ser acessadas?
  Enable_Pet_SS = true
  
  # Se existir uma switch para determinar se as habiliades podem ser acessadas,
  # qual seu ID?
  Enable_Pet_SS_ID = 1
  
  # Permitir que o jogador ative/desative o mascote?
  Enable_Pet_Visibility = true
  
  # Utilizar uma switch para determinar se o jogador pode ativar/desativar o
  # mascote?
  Enable_Pet_VS = true
  
  # Se existir uma switch para determinar se o jogador pode ativar/desativar o
  # mascote, qual seu ID?
  Enable_Pet_VS_ID = 1
  
  # Ganhar EXP por batalha?
  Enable_EXP_Battle = true
  
  # Exibir mensagem de ganho de EXP na batalha?
  Show_EXP_Message = true
  
  # Exibir mensagem ao evoluir?
  Show_Evo_Message = true
  
  # Exibir mensagem ao mudar de estágio?
  Show_Stage_Message = true
  
  # Textos para uso no script
  Pet_Vocab = [ "Mascote", # Texto a ser inserido no menu
  
                "Nível",        # Nível
                "Estágio",      # Estágio
                "Experiência",  # Experiência
                
                "Mascote",      # Texto no título da cena
                "Habilidades",  # Texto para o título da janela de habilidades
                "Status bônus", # Texto para o título da janela de status bônus
                "(Sem habilidades)", # Texto para quando não tiver habilidades
                                     # disponíveis
                "Mostrar mascote", # Texto para deixar o mascote visível
                "Ocultar mascote", # Texto para deixar o mascote invisível
                
                "%s ganhou %s pontos de experiência!",  # Texto para o ganho de
                                                        # EXP na batalha. O
                                                        # primeiro símbolo
                                                        # representa o nome do
                                                        # mascote e o segundo
                                                        # representa o valor de
                                                        # EXP adquirido.
                                                        
                "%s evoluiu para o nível %s!", # Texto para a evolução do mascote.
                                               # O primeiro símbolo representa o
                                               # nome do mascote e o segundo o
                                               # novo nível.
                
                "%s chegou ao estágio %s!"  # Texto para a mudança de estágio do
                                            # mascote. O primeiro símbolo representa
                                            # o nome do mascote e o segundo o
                                            # novo estágio.
  ]
  
  # Nome dos atributos
  Atributes_Name = ["HP Máx.",      # HP Máximo
                    "MP Máx.",      # MP Máximo
                    "Ataque",       # Ataque
                    "Defesa",       # Defesa
                    "Atq. Mágico",  # Ataque Mágico
                    "Def. Mágica",  # Defesa Mágica
                    "Agilidade",    # Agilidade
                    "Sorte"         # Sorte
  ]
  
    #--------------------------------------------------------------------------
    # Configuração do mascote
    #--------------------------------------------------------------------------
    
    # Nome inicial
    Initial_Name = "Espírito"
    
    # Nível inicial
    Initial_Level = 1
    
    # O mascote poderá se mexer livremente?
    Random_Move = true
    
    # Número de tiles máximos que o mascote pode ir para longe do jogador
    Max_Tile_Range = 6
    
    # Número de tiles para efetuar o teletransporte do mascote para o jogador
    # Isso é utilizado quando o mascote está muito longe do jogador, quando
    # ele estiver preso, por exemplo
    Tile_Teleport = 7
    
    # Habilidades iniciais. As habilidade são eventos comuns que são ativados
    # pelo menus de habilidades. Caso ativadas, coloque aqui o ID das serem
    # dadas inicialmente.
    # Exemplo:
    #   Initial_Skills = [1, 3, 4]
    Initial_Skills = []
    
    # Estágio inicial
    Initial_Stage = 0
    
    # Configuração dos estágios, leia com atenção
    Stages_Info = [
                    [0, # Nível necessário para alcançar o estágio
                    "!Flame", # Arquivo gráfico do mascote nesse estágio
                    5, # Index no arquivo gráfico do mascote
                    nil, # Caso o nome do pet mudará ao mudar de estágio, escreva
                         # aqui entre aspas duplas. Caso contrário, deixe
                         # como "nil" (sem as aspas)
                    :bonus_inicial, # Coloque após dois pontos o
                                    # nome dos bônus de status a serem dados no
                                    # estágio. Os status bônus são configurados
                                    # logo abaixo, depois da configuração dos
                                    # estágios.
                    []  # Habilidades a se ganhar no estágio, caso não ganhe
                        # nenhuma, deixe em branco.
                    ],
                    
                    [10,
                    "Spiritual",
                    4,
                    "Fada da vida",
                    :bonus1,
                    [1]
                    ],
                    
                    [20,
                    "Animal",
                    5,
                    "Cavalo",
                    :bonus2,
                    [2]
                    ],
                    
                    [30,
                    "Animal",
                    4,
                    nil,
                    :bonus3,
                    []
                    ],
                    
                    [50,
                    "Animal",
                    4,
                    nil,
                    :bonus_ultimate,
                    []
                    ]
    ]
    
    # Configuração dos bônus de status
    # Os valores são somados aos já existentes e não são acumulados entre estágios
    # Ordem dos status:
    # HP Max., MP Max., Atq., Def., Atq. Mágico, Def. Mágica, Agilidade e Sorte
    Bonus_Info = {:bonus_inicial =>   [10, 5, 1, 1, 1, 1, 0, 0],
                  :bonus1 =>          [50, 30, 5, 5, 5, 5, 5, 5],
                  :bonus2 =>          [100, 50, 15, 10, 15, 10, 10, 10],
                  :bonus3 =>          [150, 100, 25, 20, 25, 20, 20, 20],
                  :bonus_ultimate =>  [300, 250, 50, 40, 50, 40, 30, 30]
    }
    
    
    #--------------------------------------------------------------------------
    # Configuração da linha de experiência
    #--------------------------------------------------------------------------
    
    # A experiência necessária deve ser especificada para cada nível, começando
    # do nível 0, até um nível antes do máximo
    EXP = [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100,          # Níveis 0 ao 9
            110, 120, 130, 140, 150, 160, 170, 180, 190, 200, # Níveis 10 ao 19
            210, 220, 230, 240, 250, 260, 270, 280, 290, 300, # Níveis 20 ao 29
            310, 320, 330, 340, 350, 360, 370, 380, 390, 400, # Níveis 30 ao 39
            410, 420, 430, 440, 450, 460, 470, 480, 490       # Níveis 40 ao 49
    ]
    
    # Número de experiência recebida por nível, o número recebido é aleatório
    # dentro dos especificado abaixo. Para um resultado exato coloque os mesmos
    # números
    Random_EXP = [2, 8]
    
  #----------------------------------------------------------------------------
  # Fim da configuração
  #----------------------------------------------------------------------------
end
 
#==============================================================================
# KTK_Pet
#==============================================================================
class KTK_Pet
  include KTK_PS
  
  attr_accessor :name, :character, :level, :stage, :exp, :next_exp, :display,
                :skills, :skills_enabled
  
  def initialize
    @name = Initial_Name
    @character = Game_Character.new
    c_n = Stages_Info[Initial_Stage][1]
    c_i = Stages_Info[Initial_Stage][2]
    @character.set_graphic(c_n, c_i)
    @level = Initial_Level
    @stage = Initial_Stage
    @exp = 0
    @next_exp = EXP[@level]
    @skills = Initial_Skills
    @skills_enabled = true
    @display = false
    @move_tick = 0
    @move_tick_max = rand(180)
  end
  
  def update
    @character.update
    @character.move_speed = $game_player.real_move_speed
    @character.transparent = $game_player.transparent
    @character.walk_anime = $game_player.walk_anime
    @character.step_anime = $game_player.step_anime
    @character.direction_fix = $game_player.direction_fix
    @character.opacity = $game_player.opacity
    @character.blend_type = $game_player.blend_type
    @character.transparent = @display ? false : true unless $game_player.transparent
    
    if check_distance(@character.x, @character.y) >= Tile_Teleport
      move_to_player
    end
    
    if Random_Move
      return unless @display
      if @move_tick >= @move_tick_max
        if check_distance(@character.x, @character.y) >= Max_Tile_Range
          @character.move_toward_character($game_player)
        else
          @character.move_random
        end
        @move_tick_max = rand(180) while @move_tick_max < 60
        @move_tick = 0
      else
        @move_tick += 1
      end
    end
  end
  
  def reset_move_tick
    @move_tick = 0
  end
  
  def move_to_player
    @character.moveto($game_player.x, $game_player.y)
  end
  
  def remove
    @display = false
  end
  
  def show
    @display = true
  end
  
  def check_distance(x, y)
    dt = ((x - $game_player.x) * (x - $game_player.x))
    dt += ((y - $game_player.y ) * (y - $game_player.y ))
    dt = Math.sqrt(dt.abs)
  end
  
  def learn_skill(id)
    @skills.push(id)
  end
  
  def get_exp(exp)
    @exp += exp
    check_level_up
  end
  
  def get_level(value, show_message = true)
    @level += value
    $game_message.add(sprintf(Pet_Vocab[11], @name, @level)) if show_message
    @exp >= @next_exp ? check_level_up : check_stage
  end
  
  def check_level_up
    if @exp >= @next_exp
      @level += 1
      check_stage
      exp = @exp
      next_exp = @next_exp
      @exp = 0
      @next_exp = EXP[@level]
      $game_message.add(sprintf(Pet_Vocab[11], @name, @level))
      if exp > next_exp
        diference = exp - next_exp
        get_exp(diference)
      end
    end
  end
  
  def check_stage
    while @level >= Stages_Info[@stage + 1][0]
      @stage += 1
      $game_message.add(sprintf(Pet_Vocab[12], @name, @stage)) if Show_Stage_Message
      $game_party.members.each {|actor|
        actor.remove_pet_bonus
        actor.apply_pet_bonus
      }
      c_n = Stages_Info[@stage][1]
      c_i = Stages_Info[@stage][2]
      @character.set_graphic(c_n, c_i)
      @name = Stages_Info[@stage][3] unless Stages_Info[@stage][3] == nil
      Stages_Info[@stage][5].each {|id|
        @skills.push(id)
      }
    end
  end
end
 
#==============================================================================
# Game_CharacterBase
#==============================================================================
class Game_CharacterBase
  attr_accessor :move_speed, :walk_anime, :step_anime, :direction_fix,
                :opacity, :blend_type
end
 
#==============================================================================
# Game_Player
#==============================================================================
class Game_Player
  #----------------------------------------------------------------------------
  # Alias method: initialize
  #----------------------------------------------------------------------------
  alias ktk_ps_initialize initialize
  def initialize(*a, &b)
    ktk_ps_initialize(*a, &b)
  end
  
  #----------------------------------------------------------------------------
  # Alias method: update
  #----------------------------------------------------------------------------
  alias ktk_ps_update update
  def update(*a, &b)
    ktk_ps_update(*a, &b)
    $game_party.members.each {|actor|
      actor.apply_pet_bonus unless actor.pet_bonus_app
    }
  end
  
  #----------------------------------------------------------------------------
  # Alias method: move_straight
  #----------------------------------------------------------------------------
  alias ktk_ps_move_straight move_straight
  def move_straight(*a, &b)
    $game_pet.character.move_toward_character($game_player) if $game_pet.display
    $game_pet.reset_move_tick
    ktk_ps_move_straight(*a, &b)
  end
end
 
#==============================================================================
# Game_Actor
#==============================================================================
class Game_Actor
  attr_accessor :pet_bonus_app
  
  #----------------------------------------------------------------------------
  # Alias method: initialize
  #----------------------------------------------------------------------------
  alias ktk_ps_initialize initialize
  def initialize(*a, &b)
    ktk_ps_initialize(*a, &b)
    @pet_bonus_app = false
  end
  
  def apply_pet_bonus
    8.times{|i|
      add_param(i, KTK_PS::Bonus_Info[KTK_PS::Stages_Info[$game_pet.stage][4]][i])
    }
    @pet_bonus_app = true
  end
  
  def remove_pet_bonus
    8.times{|i|
      add_param(i, KTK_PS::Bonus_Info[KTK_PS::Stages_Info[$game_pet.stage - 1][4]][i] * -1)
    }
  end
end
 
#==============================================================================
# DataManager
#==============================================================================
class << DataManager
  alias ktk_ps_create_game_objects create_game_objects
  def create_game_objects(*a, &b)
    ktk_ps_create_game_objects(*a, &b)
    $game_pet = KTK_Pet.new
  end
  
  alias ktk_ps_make_save_contents make_save_contents
  def make_save_contents(*a, &b)
    contents = ktk_ps_make_save_contents(*a, &b)
    contents[:pet ] = $game_pet
    contents
  end
  
  alias ktk_ps_extract_save_contents extract_save_contents
  def extract_save_contents(contents)
    ktk_ps_extract_save_contents(contents)
    $game_pet = contents[:pet]
  end
end
 
#==============================================================================
# BattleManager
#==============================================================================
class << BattleManager
  #----------------------------------------------------------------------------
  # Alias method: process_victory
  #----------------------------------------------------------------------------
  alias ktk_ps_process_victory process_victory
  def process_victory(*a, &b)
    if KTK_PS::Enable_EXP_Battle
      play_battle_end_me
      replay_bgm_and_bgs
      $game_message.add(sprintf(Vocab::Victory, $game_party.name))
      display_exp
      gain_pet_exp
      gain_gold
      gain_drop_items
      gain_exp
      SceneManager.return
      battle_end(0)
      return true
    else
      ktk_ps_process_victory(*a, &b)
    end
  end
  
  def gain_pet_exp
    exp = KTK_PS::Random_EXP[0] == KTK_PS::Random_EXP[1] ? KTK_PS::Random_EXP[0] : -1
    exp = rand(KTK_PS::Random_EXP[1] + 1) while exp < KTK_PS::Random_EXP[0] if exp < 0
    $game_message.add(sprintf(KTK_PS::Pet_Vocab[10], $game_pet.name, exp.to_s))
    $game_pet.get_exp(exp)
  end
end
 
#==============================================================================
# Scene_Menu
#==============================================================================
class Scene_Menu
  #----------------------------------------------------------------------------
  # Alias method: create_command_window
  #----------------------------------------------------------------------------
  alias ktk_ps_create_command_window create_command_window
  def create_command_window(*a, &b)
    ktk_ps_create_command_window(*a, &b)
    @command_window.set_handler(:pet, method(:command_pet))
  end
  
  def command_pet
    SceneManager.call(Scene_Pet)
  end
end
 
#==============================================================================
# Scene_Map
#==============================================================================
class Scene_Map
  alias ktk_ps_update update
  def update(*a, &b)
    ktk_ps_update(*a, &b)
    $game_pet.update
  end
end
 
#==============================================================================
# Spriteset_Map
#==============================================================================
class Spriteset_Map
  #----------------------------------------------------------------------------
  # Alias method: create_characters
  #----------------------------------------------------------------------------
  alias ktk_ps_create_characters create_characters
  def create_characters(*a, &b)
    ktk_ps_create_characters(*a, &b)
    if $game_pet.display
      @character_sprites.push(Sprite_Character.new(@viewport1, $game_pet.character))
    end
  end
end
 
#==============================================================================
# Window_Command
#==============================================================================
class Window_Command
  #----------------------------------------------------------------------------
  # Alias method: initialize
  #----------------------------------------------------------------------------
  alias ktk_ps_initialize initialize
  def initialize(x, y, ktk_edited = false)
    ktk_edited ? super(x, y, window_width, window_height) : ktk_ps_initialize(x, y)
  end
end
 
#==============================================================================
# Window_MenuCommand
#==============================================================================
class Window_MenuCommand
  #----------------------------------------------------------------------------
  # Alias method: add_main_commands
  #----------------------------------------------------------------------------
  alias ktk_ps_add_main_commands add_main_commands
  def add_main_commands(*a, &b)
    ktk_ps_add_main_commands(*a, &b)
    add_command(KTK_PS::Pet_Vocab[0], :pet) if KTK_PS::Pet_Menu
  end
end
 
#==============================================================================
# Scene_Pet
#==============================================================================
class Scene_Pet < Scene_Base
  attr_accessor :dark_background_sprite
  attr_reader :menu_window
  
  def start
    super
    @y_windows_increments = 0
    create_backgrounds
    create_windows
  end
  
  def create_backgrounds
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
    
    @dark_background_sprite = Sprite.new
    @dark_background_sprite.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    color = Color.new(0, 0, 0, 125)
    @dark_background_sprite.bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, color)
    @dark_background_sprite.z = 200
    @dark_background_sprite.visible = false
  end
  
  def create_windows
    @title_window = Window_Pet_Title.new
    @menu_window = Window_Pet_Menu.new
    @menu_window.set_handler(:display, method(:command_display))
    @menu_window.set_handler(:bonus_status, method(:command_bonus_status))
    @menu_window.set_handler(:skills, method(:command_skills))
    @info_window = Window_Pet_Info.new
    
    v = Graphics.width / 2 - (@info_window.width + @menu_window.width) / 2
    @info_window.y = Graphics.height / 2 - @info_window.height / 2
    @info_window.x = v + 3
    @menu_window.y = @info_window.y + @menu_window.height / 4
    @menu_window.x = v + @info_window.width - 3
    @info_window.y += 24
    @menu_window.y += 24
    
    @bonus_window = Window_Pet_Bonus_Status.new
    @skills_title_window = Window_Pet_Skills_Title.new
    @skills_window = Window_Pet_Skills.new
    
    $game_pet.skills.each {|skill|
      @skills_window.set_handler(:run_common_event, method(:command_run_common_event))
    }
  end
  
  def command_display
    $game_pet.display = $game_pet.display ? false : true
    $game_pet.move_to_player
    @menu_window.refresh
    @menu_window.activate
  end
  
  def command_bonus_status
    @bonus_window.open
  end
  
  def command_skills
    @skills_window.open
    @skills_title_window.open
  end
  
  def command_run_common_event
    return if $game_pet.skills[@skills_window.index] == 0
    $game_temp.reserve_common_event($game_pet.skills[@skills_window.index])
    SceneManager.call(Scene_Map)
  end
  
  def update
    super
    if Input.trigger?(:C) || Input.trigger?(:B)
      @bonus_window.close if @bonus_window.open?
    end
    
    if Input.trigger?(:B)
      if @skills_window.open?
        @skills_title_window.close
        @skills_window.close
        return
      end
      return if @bonus_window.open?
      SceneManager.return
    end
  end
  
  def terminate
    super
  end
end
 
#==============================================================================
# Window_Pet_Title
#==============================================================================
class Window_Pet_Title < Window_Base
  def initialize
    super(0, 0, Graphics.width, 48)
    self.arrows_visible = false
    self.contents = Bitmap.new(self.width, self.height)
    self.draw_text(0, 0, self.width - 24, self.height - 24, KTK_PS::Pet_Vocab[4], 1)
  end
  
  def update
    super
  end
 
  def terminate
    super
    self.dispose
  end
end
 
#==============================================================================
# Window_Pet_Info
#==============================================================================
class Window_Pet_Info < Window_Base
  attr_reader :ch
  
  def initialize
    super(0, 0, 0, 54)
    self.width = text_size($game_pet.name).width + 200
    self.x = Graphics.width / 2 - self.width / 2
    self.arrows_visible = false
    cn = KTK_PS::Stages_Info[$game_pet.stage][1]
    ci = KTK_PS::Stages_Info[$game_pet.stage][2]
    bitmap = Cache.character(cn)
    sign = cn[/^[\!\$]./]
    if sign && sign.include?('$')
      cw = bitmap.width / 3
      ch = bitmap.height / 4
    else
      cw = bitmap.width / 12
      ch = bitmap.height / 8
    end
    self.height += ch
    self.contents = Bitmap.new(self.width, self.height + 110)
    self.draw_text(0, 0, self.width - 20, 24, $game_pet.name, 1)
    src_rect = Rect.new((ci%4*3+1)*cw, (ci/4*4)*ch, cw, ch)
    self.contents.blt((self.width - 24) / 2 - cw / 2, 26, bitmap, src_rect)
    @ch = ch
    
    draw_texts
  end
 
  def draw_texts
    pet = $game_pet
    values = [pet.level, pet.stage, pet.exp]
    for i in 0..2
      text = "#{KTK_PS::Pet_Vocab[i + 1]}: #{values[i]}" + (i == 2 ? "/#{$game_pet.next_exp}" : "")
      y = 24 * i + self.height - 24
      self.draw_text(0, y, self.width - 24, 24, text, 1)
    end
    self.height += 72
  end
  
  def update
    super
  end
 
  def terminate
    super
    self.dispose
  end
end
 
#==============================================================================
# Window_Pet_Bonus_Status
#==============================================================================
class Window_Pet_Bonus_Status < Window_Base
  def initialize
    super(Graphics.width / 2 - 136, Graphics.height / 2 - 100, 272, 200)
    self.arrows_visible = false
    self.contents = Bitmap.new(self.width, self.height)
    self.opacity = 0
    self.close
    self.z = 210
    @drawed_texts = false
  end
  
  def open
    super
    self.opacity = 255
    SceneManager.scene.dark_background_sprite.visible = true
  end
  
  def close
    super
    SceneManager.scene.dark_background_sprite.visible = false
    SceneManager.scene.menu_window.activate
  end
 
  def draw_texts
    self.draw_text(0, 0, self.width - 24, 24, "Status bônus", 1)
    
    line_height = 24
    for i in 0..8
      y = i == 0 ? 24 : 19 * i + 24
      self.contents.font.size = 19
      self.draw_text(0, y, self.width - 24, 19, "#{KTK_PS::Atributes_Name[i]}: ", 0)
      x = text_size(KTK_PS::Atributes_Name[i].to_s)
      value = KTK_PS::Bonus_Info[KTK_PS::Stages_Info[$game_pet.stage][4]][i]
      self.draw_text(x.width + 12, y, self.width - 24, 19, value.to_s, 0)
    end
  end
  
  def update
    super
    unless @drawed_texts
      draw_texts unless open?
      @drawed_texts = true
    end
  end
 
  def terminate
    super
    self.dispose
  end
end
 
#==============================================================================
# Window_Pet_Menu
#==============================================================================
class Window_Pet_Menu < Window_Command
  def initialize
    super(0, 0)
    self.x = Graphics.width / 2 - 100
  end
 
  def window_width; return 200; end
  def window_height; return 104; end
  
  def make_command_list
    pet_display_text = $game_pet.display ? KTK_PS::Pet_Vocab[9] : KTK_PS::Pet_Vocab[8]
    if KTK_PS::Enable_Pet_Visibility
      if KTK_PS::Enable_Pet_VS
        add_command(pet_display_text, :display, $game_switches[KTK_PS::Enable_Pet_VS_ID])
      else
        add_command(pet_display_text, :display)
      end
    end
    add_command(KTK_PS::Pet_Vocab[6], :bonus_status)
    if KTK_PS::Enable_Pet_Skills
      if KTK_PS::Enable_Pet_SS
        add_command(KTK_PS::Pet_Vocab[5], :skills, $game_switches[KTK_PS::Enable_Pet_SS_ID])
      else
        add_command(KTK_PS::Pet_Vocab[5], :skills)
      end
    end
  end
  
  def update
    super
  end
 
  def terminate
    super
    self.dispose
  end
end
 
#==============================================================================
# Window_Pet_Skills_Title
#==============================================================================
class Window_Pet_Skills_Title < Window_Base
  def initialize
    super(0, 81, 0, 48)
    self.width = text_size(KTK_PS::Pet_Vocab[5]).width + 48
    self.x = Graphics.width / 2 - self.width / 2
    self.z = 210
    self.arrows_visible = false
    self.contents = Bitmap.new(self.width, self.height)
    self.opacity = 0
    self.close
    @drawed_texts = false
  end
  
  def open
    super
    self.opacity = 255
  end
  
  def draw_texts
    self.draw_text(0, 0, self.width - 24, self.height - 24, KTK_PS::Pet_Vocab[5], 1)
  end
  
  def update
    super
    unless @drawed_texts
      draw_texts unless open?
      @drawed_texts = true
    end
  end
 
  def terminate
    super
    self.dispose
  end
end
 
#==============================================================================
# Window_Pet_Skills
#==============================================================================
class Window_Pet_Skills < Window_Command
  def initialize
    clear_command_list
    super(Graphics.width / 2 - 136, 135, true)
    self.opacity = 0
    self.close
    self.z = 210
    @drawed_texts = false
  end
  
  def window_width; return 272; end
  def window_height; return 200; end
    
  def open
    super
    self.opacity = 255
    SceneManager.scene.dark_background_sprite.visible = true
  end
  
  def close
    super
    SceneManager.scene.dark_background_sprite.visible = false
    SceneManager.scene.menu_window.activate
  end
 
  def draw_texts
    refresh
    select(0) unless $game_pet.skills.empty?
    activate
    if $game_pet.skills.empty?
      self.contents.font.color = Color.new(150, 150, 150)
      self.draw_text(0, 0, self.width - 24, 24, KTK_PS::Pet_Vocab[7], 1)
    end
  end
  
  def make_command_list
    $game_pet.skills.each {|skill|
      name = $data_common_events[skill].name
      add_command(name, :run_common_event)
    }
  end
  
  def update
    super
    unless @drawed_texts
      draw_texts unless open?
      @drawed_texts = true
    end
  end
 
  def terminate
    super
    self.dispose
  end
end
