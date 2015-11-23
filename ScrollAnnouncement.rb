#==============================================================================
# Scroll Announcement
# Criado por Fogomax, agradecimentos ao Gab!
#------------------------------------------------------------------------------
# Permite a criação de anuncios rolantes
#------------------------------------------------------------------------------
# ● Como utilizar:
#  Em um evento, escreva:
#   "scroll_announ(texto, cor, contorno, italico, index_icone, velocidade)"
#
#  Sendo:
#   texto - Texto a ser exibido
#   cor - ID da cor do texto, siga a tabela nas configurações
#   contorno - Se o texto irá ou não ter contorno
#   italico - Se o texto irá ou não ser em itálico
#   index_icone - ID do ícone a ser exibido. 0 para nenhum.
#   velocidade - Velocidade do texto a ser exibido. 0 para devagar, 1 para normal
#    e 3 para rápido
#
# ● Exemplo:
#  scroll_announ("Olá", 1, true, false, 0, 1)
#
#  Ou seja, o texto a ser exibido será "Olá", de cor branca, com contorno, sem
#  ser em itálico, sem icone e em velocidade normal.
#
# ● Dica:
#  Não deixe o comando sair quebrado na caixa do Chamar Script, caso o texto for
#  grande demais, faça o seguinte:
#
#  t = "Texto grande demais"
#  scroll_announ(t, 1, true, false, 0, 1)
# 
#  Caso o texto ainda saia quebrado, faça o seguinte:
#
#  t =  "Texto grande demais para a janela"
#  t += " do Chamar Script"
#  scroll_announ(t, 1, true, false, 0, 1)
#==============================================================================

module SAnnouncement
  #----------------------------------------------------------------------------
  # Início da configuração
  #----------------------------------------------------------------------------
  
  # Cores disponíveis, se quiser, configure com as suas se quiser
  
  Cores = {1 => Color.new(255, 255, 255), # Branco
           2 => Color.new(200, 0, 0),     # Vermelho
           3 => Color.new(240, 240, 0),   # Amarelo
           4 => Color.new(0, 200, 0),     # Verde
           5 => Color.new(0, 160, 255),   # Azul
           6 => Color.new(0, 80, 255),    # Azul escuro
           7 => Color.new(255, 128, 0)    # Laranja
  }
  
  #----------------------------------------------------------------------------
  # Fim da configuração
  #----------------------------------------------------------------------------
end

#==============================================================================
# WindowAnnouncement < Window_Base
#==============================================================================
class WindowAnnouncement < Window_Base
  def initialize
    super(0, 0, 0, 0)
    self.arrows_visible = false
    self.opacity = 0
    @xpos_texto = 0
    @texto_rev = 0
    @timer_t = 0
    @texto_e = ""
    @index_icone = 0
    @velocidade = 0
    self.hide
  end
  
  def show_window(texto, cor, contorno, italico, index_icone, velocidade)
    return if @showing_text
    
    @showing_text = true
    @texto_e = texto
    @index_icone = index_icone
    
    case velocidade
      when 0
        @velocidade = 10
      when 1
        @velocidade = 5
      when 3
        @velocidade = 2
      else
        @velocidade = 5
    end
    
    @fundo_p = Sprite.new
    @fundo_p.bitmap = Bitmap.new(Graphics.width, 35)
    @fundo_p.bitmap.fill_rect(0, 0, 640, 35, Color.new(0, 0, 0, 155))
    
    self.width = Graphics.width
    self.height = 48
    
    self.x = (Graphics.width / 2) - (self.width / 2)
    self.y = -7
    
    create_contents
    self.contents.font.size = 22
    @xpos_texto = self.width + 20
    tam_texto = text_size(@texto_e).width
    @texto_rev = -tam_texto 
    
    self.contents.font.color = SAnnouncement::Cores[cor]
    self.contents.font.outline = contorno
    self.contents.font.italic = italico
    self.contents.draw_text(@xpos_texto, 0, self.width - 30, self.height - 24, @texto_e)
    self.show
  end
  
  def update
    super
    return unless @showing_text
    
    @timer_t += 1
    if @timer_t == @velocidade
      @timer_t = 0
      @xpos_texto -= 3
      self.contents.clear
      self.contents.draw_text(@xpos_texto, 0, self.width, self.height - 24, @texto_e)
      
      self.contents.clear_rect(0, 0, 24, 24)
      self.contents.clear_rect(contents.width - 24, 0, 24, 24)

      draw_icon(@index_icone, 0, 0)
      draw_icon(@index_icone, contents.width - 24, 0)
      
      if @xpos_texto < @texto_rev
        self.y -= 5
        @fundo_p.opacity -= 25
      end
    end
    
    if @fundo_p.opacity <= 0
      @fundo_p.dispose
      @xpos_texto = 0
      @texto_rev = 0
      @timer_t = 0
      @texto_e = ""
      @index_icone = 0
      @velocidade = 0
      self.hide
      @showing_text = false
    end
  end
end

#==============================================================================
# Scene_Map
#==============================================================================
class Scene_Map
  #----------------------------------------------------------------------------
  # Attr_accessor: announ_window
  #----------------------------------------------------------------------------
  attr_accessor :announ_window
  
  #----------------------------------------------------------------------------
  # Alias method: start
  #----------------------------------------------------------------------------
  alias fg_start start
  def start
    fg_start
    @announ_window = WindowAnnouncement.new
  end
  
  #----------------------------------------------------------------------------
  # Alias method: update
  #----------------------------------------------------------------------------
  alias fg_update update
  def update
    fg_update
    @announ_window.update
  end
  
  #----------------------------------------------------------------------------
  # Alias method: terminate
  #----------------------------------------------------------------------------
  alias fg_terminate terminate
  def terminate
    fg_terminate
    @announ_window.dispose
  end
end

#==============================================================================
# Game_Interpreter
#==============================================================================
class Game_Interpreter
  def scroll_announ(texto, cor, contorno, italico, index_icone, velocidade)
    SceneManager.scene.announ_window.show_window(texto, cor, contorno, italico, index_icone, velocidade)
  end
end
