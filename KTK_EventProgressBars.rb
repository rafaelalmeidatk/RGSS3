#==============================================================================
# KTK - Event Progress Bars
# Criado por Fogomax
#------------------------------------------------------------------------------
# Permite que os eventos tenham barras de progresso
#------------------------------------------------------------------------------
# ● Instruções
#
#    Utilize no Chamar Script as seguintes funções:
#
#      -  create_event_bar(ID do Evento, Estilo, Valor Inicial, Valor Máximo, YC)
#          Sendo:
#           ID do Evento: o evento alvo que irá receber a barra
#           Estilo: estilo da barra a ser criada, veja os estilos na configuração
#           Valor Inicial: valor inicial da barra
#           Valor Máximo: valor máximo da barra
#           YC: Correção no eixo Y. Caso o valor não seja informado, será usado
#           o especificado nas configurações.
#
#          Exemplo:
#           create_event_bar(4, 'Barra_Conquista', 0, 100)
#            A função cria uma barra no evento de ID 4 com o estilo identificado
#            por "Barra_Conquista". O valor inicial será de 0 e ela pode chegar
#            até 100. Como não informamos a correção no eixo Y, será usado o
#            padrão.
#
#
#      -  set_bar_value(ID do Evento, Novo Valor)
#          Sendo:
#           ID do Evento: o evento alvo que irá ter o valor da barra alterada
#           Novo Valor: O novo valor da barra
#
#          Exemplo:
#           set_bar_value(4, 40)
#            A função irá alterar o valor da barra do evento de ID 4 para 40.
#
#
#      - increase_bar_value(ID do Evento, Valor de Incremento)
#          Sendo:
#           ID do Evento: o evento alvo que irá ter o valor da barra incrementada
#           Valor de Incremento: Valor a ser adicionado ao valor atual da barra
#
#          Exemplo:
#           increase_bar_value(4, 10)
#            A função irá incrementar em 10 o valor da barra do evento de ID 4.
#
#
#      -  delete_bar(ID do Evento)
#          Sendo:
#           ID do Evento: o evento alvo que irá ter sua barra deletada
#
#          Exemplo:
#           delete_bar(4)
#            A função irá deletar a barra do evento de ID 4.
#
#------------------------------------------------------------------------------
# ● Dicas e observações:
#
#    O comando "create_event_bar" irá criar uma nova barra, porém se outra já
#    existir ela será apagada.
#
#    Os comandos "set_bar_value","increase_bar_value" e "delete_bar" não serão
#    executados caso não exista uma barra criada no evento alvo. 
#
#    Você pode alterar a correção do eixo Y da barra para deixa-la na altura
#    desejada. Como a barra é colocada em baixo do evento por padrão, valores
#    negativos irão fazer ela ir para cima, e valores positivos irão fazer ela
#    ir para baixo.
#==============================================================================

module KTK_EventPBars
  #============================================================================
  # Início da configuração
  #============================================================================
  
  # Switch que desativa temporariamente todas as barras
  Switch_Visible = 1
  
  # Correção padrão no eixo Y
  Y_Correction = 5
  
  # Estilos de barras, siga os exemplos para criar as suas
  Bars_Styles = {'HP' => [true, # Usar imagens para as barras? Sim: true | Não: false
                          "HP_Back", # Imagem de fundo da barra
                          "HP_Front", # Imagem de frente da barra
                          Color.new(0, 0, 0), # Cor de fundo da barra
                          Color.new(204, 0, 0), # Cor de frente da barra
                          42, # Largura da barra
                          5 # Altura da barra
                          ],
                          
                 'MP' => [false, # Sem imagens
                          nil, # Como não usamos imagens não especificamos elas
                          nil, # "nil" é a mesma coisa que nada
                          Color.new(0, 0, 0), # O formato de cores é RGB
                          Color.new(0, 128, 255),
                          50, # Nossa barra terá 50px de largura e 5px de altura
                          5 # O último valor não precisa de virgula
                          ], # Caso esse estilo seja o último, não coloque vírgula
                          
                 'PG' => [true, # Exemplo de barra com imagens
                          "bp", # O formato das imagens é PNG
                          "bpF", # Elas devem estar na pasta Pictures
                          nil, # Como usamos imagens não especificamos as cores
                          nil,
                          nil, # Também não precisamos especificar os tamanhos das imagens
                          nil,
                          ] # Esse é o ultimo estilo de exemplo, não colocamos a vírgula
                }
                
  #============================================================================
  # Fim da configuração
  #============================================================================
end

#==============================================================================
# Event_KTKBar
#==============================================================================
class Event_KTKBar < Sprite
  include KTK_EventPBars
  attr_accessor :value, :max_value, :style, :y_correction
  
  def initialize(char, style, value, maxvalue, y_correction)
    super(nil)
    @char = char
    @style = style
    @y_correction = y_correction
    @value = value
    @max_value = maxvalue
    @value_rate = (@value.to_f) / @max_value
    @back_image = Bars_Styles[@style][0] ? Cache.picture(Bars_Styles[@style][1]) : nil
    @front_image = Bars_Styles[@style][0] ? Cache.picture(Bars_Styles[@style][2]) : nil
    @back_color = Bars_Styles[@style][3]
    @front_color = Bars_Styles[@style][4]
    @bar_width = Bars_Styles[@style][0] ? @back_image.width : Bars_Styles[@style][5]
    @bar_height = Bars_Styles[@style][0] ? @back_image.height : Bars_Styles[@style][6]
    self.bitmap = Bitmap.new(@bar_width, @bar_height)
    self.ox = @bar_width / 2
    self.x = @char.screen_x
    self.y = @char.screen_y + @y_correction
    self.z = 50
    draw_background
    set_value(@value)
  end
  
  def draw_background
    if Bars_Styles[@style][0]
      rect = @back_image.rect
      self.bitmap.blt(0, 0, @back_image, rect)
    else
      self.bitmap.fill_rect(0, 0, @bar_width, @bar_height, Bars_Styles[@style][3])
    end
  end
  
  def set_value(new_value)
    self.bitmap.clear
    draw_background
    @value_rate = (new_value.to_f) / @max_value
    m = Bars_Styles[@style][0] ? 0 : 2
    fill = ((self.width - m) * @value_rate).to_i
    if Bars_Styles[@style][0]
      rect = Rect.new(0, 0, fill, @front_image.width)
      self.bitmap.blt(0, 0, @front_image, rect)
    else
      self.bitmap.fill_rect(1, 1, fill, @bar_height - 2, Bars_Styles[@style][4])
    end
    @value = new_value
    self.x = @char.screen_x
    self.y = @char.screen_y + @y_correction
  end
  
  def increase_value(value)
    (@value + value) >= @max_value ? @value = @max_value : @value += value
    set_value(@value)
  end
  
  def dispose
    $game_map.events_bars.delete(self) if $game_map.events_bars.include?(self)
    super
  end
end

#==============================================================================
# Game_Map
#==============================================================================
class Game_Map
  attr_accessor :events_bars
  
  alias ktk_event_bars_setup setup
  def setup(*a, &b)
    @events_bars ||= []
    ktk_event_bars_setup(*a, &b)
  end
end

#==============================================================================
# Game_Event
#==============================================================================
class Game_Event
  attr_accessor :bar_created, :event_bar, :bar_value, :bar_max_value, :y_correction
  
  alias ktk_event_bars_initialize initialize
  def initialize(*a, &b)
    @bar_created = false
    @event_bar = nil
    ktk_event_bars_initialize(*a, &b)
  end
  
  def create_bar(style, value, maxvalue, y_correction)
    delete_bar if @bar_created
    @event_bar = Event_KTKBar.new(self, style, value, maxvalue, y_correction)
    $game_map.events_bars.push(@event_bar)
    @bar_value = value
    @bar_max_value = maxvalue
    @bar_created = true
    @y_correction = y_correction
  end
  
  def set_bar_value(new_value)
    return unless @bar_created
    @event_bar.set_value(new_value)
  end
  
  def increase_bar_value(value)
    return unless @bar_created
    @event_bar.increase_value(value)
  end
  
  def delete_bar
    return unless @bar_created
    @event_bar.dispose
    @bar_created = false
  end
end

#==============================================================================
# Spriteset_Map
#==============================================================================
class Spriteset_Map
  alias ktk_event_bars_initialize initialize
  def initialize
    ktk_event_bars_initialize
    for event in $game_map.events.values
      if event.bar_created
        eb = event.event_bar
        event.create_bar(eb.style, eb.value, eb.max_value, eb.y_correction) 
      end
    end
  end
  
  alias ktk_event_bars_update update
  def update(*a, &b)
    ktk_event_bars_update(*a, &b)
    $game_map.events_bars.each{|bar| bar.update}
  end
  
  alias ktk_event_bars_dispose dispose
  def dispose(*a, &b)
    ktk_event_bars_dispose(*a, &b)
    $game_map.events_bars.each{|bar| bar.dispose}
  end
end

#==============================================================================
# Game_Interpreter
#==============================================================================
class Game_Interpreter
  def create_event_bar(event_id, style, value, maxvalue, y_correction=KTK_EventPBars::Y_Correction)
    $game_map.events[event_id].create_bar(style, value, maxvalue, y_correction)
  end
  
  def set_bar_value(event_id, new_value)
    $game_map.events[event_id].set_bar_value(new_value)
  end
  
  def increase_bar_value(event_id, value)
    $game_map.events[event_id].increase_bar_value(value)
  end
  
  def delete_bar(event_id)
    $game_map.events[event_id].delete_bar
  end
end
