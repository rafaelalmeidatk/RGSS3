#==============================================================================
# New Member Display
# Criado por Fogomax
#------------------------------------------------------------------------------
# Quando um novo membro entrar na equipe, exibe um alerta visual
#------------------------------------------------------------------------------
# ● Como utilizar:
#  Ative a switch que ativa/desativa o script.
#  Coloque uma cor no herói usando "<color_nm: x>" nas notas (Banco de dados).
#  Troque "x" por um número nas configurações, na qual está se especificando uma
#  cor.
#  Quando um membro novo ser adicionado o aviso será aberto automaticamente.
#  Configure corretamente o script abaixo.
#==============================================================================

module NMDisplay
  #============================================================================
  # Início da configuração
  #============================================================================
  
  # Switch que ativa/desativa os avisos
  Switch_At = 1
  
  # Tempo em frames para o aviso ficar aberto
  Tempo_J = 280
  
  # Som a ser reproduzido quando o aviso for aberto
  Som_Av = "Audio/SE/Evasion2"
  
  # Texto ao ser exibido no título da mensagem, caso use imagem a mensagem não
  # será mostrada
  Texto_Msg = "Novo personagem conquistado!"
  
  # Usar imagem ao invés de janelas?
  # True: sim | False: não
  Usar_I = false
  
  # Nome da imagem (pasta Pictures)
  Nome_Imagem = 'nmdisplay_img.png'
  
  # Especificar localização dos objetos, não necessário caso não use imagem
  #
  # Legenda:
  #  Centro - A face e o nome do herói serão posicionados centralmente, tendo
  #  que especificar somente a posição Y dos elementos. Primeiro da imagem, depois
  #  da face e depois do nome
  #
  #  Tudo - Especificar a posição de todos os elementos. Primeiro a posição X e
  #  depois a posição Y. Primeiro da imagem, depois da face e depois do nome
  
  Escolha_Elem = 'Centro' # 'Centro' ou 'Tudo', não retire as aspas
  
  # Caso use 'Centro', a configuração do 'Tudo' não é necessária, e vice-versa
  Localizacao_Elem = {'Centro' => [61, 181, 300],
                      'Tudo' => [100, 100, 30, 30, 0, 0] 
  }
  
  # Cores disponíveis, modifique com as que quiser, porém não adicione mais
  # Uso: <color_nm: x>, sendo "x" um número abaixo
  
  Cores = {1 => Color.new(255, 255, 255), # Branco
           2 => Color.new(200, 0, 0),     # Vermelho
           3 => Color.new(240, 240, 0),   # Amarelo
           4 => Color.new(0, 200, 0),     # Verde
           5 => Color.new(0, 160, 255),   # Azul
           6 => Color.new(0, 80, 255),    # Azul escuro
           7 => Color.new(255, 128, 0),   # Laranja
           8 => Color.new(255, 255, 255), # Branco
           9 => Color.new(255, 255, 255), # Branco
           10 => Color.new(255, 255, 255) # Branco
  }
  
  #============================================================================
  # Fim da configuração
  #============================================================================
end

#==============================================================================
# Módulo: RPG
#==============================================================================
module RPG
  class Actor < BaseItem
    def color_nmdisplay
      return @color_nmdisplay unless @color_nmdisplay.nil?
      load_notetag_actor_color_nmdisplay
      return @color_nmdisplay
    end
    
    def load_notetag_actor_color_nmdisplay
      sttag = /<color_nm:\s*(1|2|3|4|5|6|7)>/i
      @color_nmdisplay = self.note =~ sttag ? $1.downcase : ""
      @color_nmdisplay = @color_nmdisplay.to_i
    end
  end
end

#==============================================================================
# Game_Party
#==============================================================================
class Game_Party
  #----------------------------------------------------------------------------
  # Alias method: add_actor
  #----------------------------------------------------------------------------
  alias fg_add_actor add_actor
  
  def add_actor(actor_id)
    fg_add_actor(actor_id)
    
    if $game_switches[NMDisplay::Switch_At]
      if NMDisplay::Usar_I
        Audio.se_play(NMDisplay::Som_Av)
        SceneManager.scene.nmdisplay_window_i.show_memberwindow(actor_id)
      else
        Audio.se_play(NMDisplay::Som_Av)
        SceneManager.scene.nmdisplay_window_t.show_memberwindow
        SceneManager.scene.nmdisplay_window_f.show_memberwindow(actor_id)
        SceneManager.scene.nmdisplay_window_n.show_memberwindow(actor_id)
      end
    end
  end
end

#==============================================================================
# Scene_Map
#==============================================================================
class Scene_Map
  #----------------------------------------------------------------------------
  # Attr_accessor: nmdisplay_window
  #----------------------------------------------------------------------------
  attr_accessor :nmdisplay_window_i
  attr_accessor :nmdisplay_window_t
  attr_accessor :nmdisplay_window_f
  attr_accessor :nmdisplay_window_n
  
  #----------------------------------------------------------------------------
  # Alias method: start
  #----------------------------------------------------------------------------
  alias fg_start start
  def start
    fg_start
    @nmdisplay_window_i = WindowNMD_Imagem.new
    @nmdisplay_window_t = WindowNMD_Titulo.new
    @nmdisplay_window_f = WindowNMD_Face.new
    @nmdisplay_window_n = WindowNMD_Nome.new
  end
 
  #----------------------------------------------------------------------------
  # Alias method: update
  #----------------------------------------------------------------------------
  alias fg_update update
  def update
    fg_update
    @nmdisplay_window_i.update
    @nmdisplay_window_t.update
    @nmdisplay_window_f.update
    @nmdisplay_window_n.update
  end
 
  #----------------------------------------------------------------------------
  # Alias method: terminate
  #----------------------------------------------------------------------------
  alias fg_terminate terminate
  def terminate
    fg_terminate
    @nmdisplay_window_i.dispose
    @nmdisplay_window_t.dispose
    @nmdisplay_window_f.dispose
    @nmdisplay_window_n.dispose
  end
end

#==============================================================================
# WindowNMD_Titulo < Window_Base
#==============================================================================
class WindowNMD_Titulo < Window_Base
  def initialize
    super(0,0,0,0)
    self.arrows_visible = false
    @tempo_f = 0
    @fade = false
    self.hide
  end
  
  def show_memberwindow
    @tempo_ab = NMDisplay::Tempo_J
    @tempo_f = 0
    texto_ex = NMDisplay::Texto_Msg
    tt = text_size(texto_ex)
    
    self.width = tt.width + 30
    self.height = 48
    
    @tamanho_janela_max = self.width
    
    self.x = (Graphics.width / 2) - (self.width / 2)
    self.y = ((Graphics.height / 2) - (self.height / 2)) - 81
    
    create_contents
    self.contents.draw_text(0, 0, self.width - 24, tt.height, texto_ex, 1)
    self.show
  end
  
  def update
    super
    @tempo_f += 1
    if @tempo_f == @tempo_ab
      @tempo_f = 0 
      @fade = true
    end
    if @fade
      self.contents_opacity -= 5
      if self.contents_opacity <= 0
        @tempo_f = 0
        self.hide
      end
    end
  end
end

#==============================================================================
# WindowNMD_Face < Window_Base
#==============================================================================
class WindowNMD_Face < Window_Base
  def initialize
    super(0,0,0,0)
    self.arrows_visible = false
    @tempo_f = 0
    @fade = false
    self.hide
  end
  
  def show_memberwindow(actor_id)
    @tempo_ab = NMDisplay::Tempo_J
    @tempo_f = 0
    actor = $data_actors[actor_id]
    @fcn_actor = actor.face_name
    @fci_actor = actor.face_index
    
    self.width = 112
    self.height = 112
    
    self.x = (Graphics.width / 2) - (self.width / 2)
    self.y = ((Graphics.height / 2) - (self.height / 2))
    
    create_contents
    draw_face(@fcn_actor, @fci_actor, 0, 0, true)
    
    self.show
  end
  
  def update
    super
    @tempo_f += 1
    if @tempo_f == @tempo_ab
      @tempo_f = 0 
      @fade = true
    end
    if @fade
      self.contents_opacity -= 5
      if self.contents_opacity <= 0
        @tempo_f = 0
        self.hide
      end
    end
  end
end

#==============================================================================
# WindowNMD_Nome < Window_Base
#==============================================================================
class WindowNMD_Nome < Window_Base
  def initialize
    super(0,0,0,0)
    self.arrows_visible = false
    @tempo_f = 0
    @fade = false
    self.hide
  end
  
  def show_memberwindow(actor_id)
    @tempo_ab = NMDisplay::Tempo_J
    @tempo_f = 0
    actor = $data_actors[actor_id]
    @nome_actor = actor.name
    @cor_actor = actor.color_nmdisplay
    tt = text_size(@nome_actor)
    
    self.width = tt.width + 30
    self.height = 48
    
    self.x = (Graphics.width / 2) - (self.width / 2)
    self.y = (Graphics.height / 2) - (self.height / 2) + 81
    create_contents
    self.contents.font.color = NMDisplay::Cores[@cor_actor]
    self.contents.draw_text(0, 0, self.width - 24, tt.height, @nome_actor, 1)
    
    self.show
  end
  
  def update
    super
    @tempo_f += 1
    if @tempo_f == @tempo_ab
      @tempo_f = 0 
      @fade = true
    end
    if @fade
      self.contents_opacity -= 5
      if self.contents_opacity <= 0
        @tempo_f = 0
        self.hide
      end
    end
  end
end

#==============================================================================
# WindowNMD_Imagem < Window_Base
#==============================================================================
class WindowNMD_Imagem < Window_Base
  def initialize
    super(0,0,0,0)
    self.arrows_visible = false
    self.opacity = 0
    @tempo_f = 0
    @fade = false
    self.hide
  end
  
  def show_memberwindow(actor_id)
    @tempo_ab = NMDisplay::Tempo_J
    @tempo_f = 0
    actor = $data_actors[actor_id]
    @nome_actor = actor.name
    @cor_actor = actor.color_nmdisplay
    @fcn_actor = actor.face_name
    @fci_actor = actor.face_index
    tt = text_size(@nome_actor)
    
    self.width = Graphics.width + 16
    self.height = Graphics.height + 16
    
    self.x = -8
    self.y = -8
    
    create_contents
    
    if NMDisplay::Escolha_Elem == 'Centro'
      pos_var = NMDisplay::Localizacao_Elem['Centro']
      
      imagem_f = Cache.picture(NMDisplay::Nome_Imagem)
      cent_img = (contents.width - imagem_f.width) / 2
      are = imagem_f.rect
      self.contents.blt(cent_img, pos_var[0], imagem_f, are)
      
      pos_face = (contents.width / 2) - 50
      draw_face(@fcn_actor, @fci_actor, pos_face, pos_var[1])
      
      self.contents.font.color = NMDisplay::Cores[@cor_actor]
      self.contents.draw_text(0, pos_var[2], self.width - 24, tt.height, @nome_actor, 1)
    end
    
    if NMDisplay::Escolha_Elem == 'Tudo'
      pos_var = NMDisplay::Localizacao_Elem['Tudo']
      
      imagem_f = Cache.picture(NMDisplay::Nome_Imagem)
      are = imagem_f.rect
      self.contents.blt(pos_var[0], pos_var[1], imagem_f, are)
      
      draw_face(@fcn_actor, @fci_actor, pos_var[2], pos_var[3])
      
      self.contents.font.color = NMDisplay::Cores[@cor_actor]
      self.contents.draw_text(pos_var[4], pos_var[5], self.width - 24, tt.height, @nome_actor, 0)
    end
    
    self.show
  end
  
  def update
    super
    @tempo_f += 1
    if @tempo_f == @tempo_ab
      @tempo_f = 0 
      @fade = true
    end
    if @fade
      self.contents_opacity -= 5
      if self.contents_opacity <= 0
        @tempo_f = 0
        self.hide
      end
    end
  end
end
