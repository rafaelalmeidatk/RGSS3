#==============================================================================
# KTK - Move Route
# Criado por Fogomax e Gab! (09/06/2014)
#------------------------------------------------------------------------------
# Permite configurar uma rota de movimento diretamente por scripts ou por eventos
#------------------------------------------------------------------------------
# ● Como Usar
#
#   Você pode usar a função tanto em eventos como em scripts (o uso é
#   recomendado em scripts).
#
#   Para mover o jogador usando parâmetros, você deve usar a seguinte função:
#     KTKMoveRoute.player_move_route_p(move_list, rep)
#
#   Para mover o jogador sem usar parâmetros, você deve usar a segunte função:
#     KTKMoveRoute.player_move_route(move_list, rep)
#
#   Sendo:
#     move_list - Um array com os movimentos (explicação depois das funções)
#     rep - Se o movimento irá se repetir
#
#------------------------------------------------------------------------------
#
#   Para mover um evento usando parâmetros, você deve usar a seguinte função:
#     KTKMoveRoute.event_move_route_p(event_id, move_list, rep)
#
#   Para mover um evento sem usar parâmetros, você deve usar a segunte função:
#     KTKMoveRoute.event_move_route(event_id, move_list, rep)
#
#   Sendo:
#     event_id - ID do evento a ser movimentado
#     move_list - Um array com os movimentos (explicação depois das funções)
#     rep - Se o movimento irá se repetir
#
#------------------------------------------------------------------------------
#
#   Para se criar o array sem parâmetros, faça da seguinte forma:
#
#     array = [c, c, c, c]
#
#   Sendo "c" algum dos comandos listados no final das instruções. Preste
#   atenção, alguns comandos exigem parâmetros, como o "Script". Comandos
#   simples de movimentos não exigem os parâmetros.
#
#
#   Para se criar o array com parâmetros, faça da seguinte forma:
#
#     array = [[c, c, c, c],
#              [p, p, p, p]]
#
#   Sendo "c" algum dos comandos listados no final das instruções e "p" o
#   parâmetro. Todos os parâmetros são respectivos aos comandos, então preste
#   muita atenção nisso. O parâmetro deve ser colocado entre parênteses. Caso
#   você tenha algum comando que não precise de um parâmetro, coloque "0", sem
#   os parênteses.
#
#------------------------------------------------------------------------------
#   Atenção, quando você for usar o comando pelo "Chamar Script", tire o
#   "KTKMoveRoute." do começo do comando. Exemplo:
#
#     KTKMoveRoute.player_move_route(move_list, rep)
#
#     Irá virar:
#
#     player_move_route(move_list, rep)
#   
#------------------------------------------------------------------------------
#
# ● Exemplos:
#
#   array = [1, 1, 3, 4, 0]
#   KTKMoveRoute.player_move_route(array, false)
#
#   O jogador irá andar para baixo duas vezes, andar para a direita, andar para
#   cima e então o movimento irá acabar. Como temos o "KTKMoveRoute." na frente,
#   esse comando será usado em um script.
#
#
#   array = [[1, 1, 3, 45, 0],
#            [0, 0, 0, "$game_variables[5] += 10", 0]]
#   KTKMoveRoute.event_move_route_p(003, array, false)
#
#   O evento de ID 003 irá andar para baixo duas vezes, andar para a direita,
#   aumentar o valor da variável de ID 5 em 10 (45 é o comando para script) e
#   então o movimento irá acabar. Como temos o "KTKMoveRoute." na frente,
#   esse comando será usado em um script.
#------------------------------------------------------------------------------
# ● Lista dos comandos:
#
#   0         # Final da rota de movimento
#   1         # Mover para baixo
#   2         # Mover para esqueda
#   3         # Mover para direita
#   4         # Mover para cima
#   5         # Mover para inferior esquerda
#   6         # Mover para inferior direita
#   7         # Mover para superior esquerda
#   8         # Mover para superior direita
#   9         # Mover aleatóriamente
#   10        # Mover para perto
#   11        # Mover para longe
#   12        # Mover para frente
#   13        # Mover para trás
#   14        # Pular
#   15        # Esperar
#   16        # Olhar para baixo
#   17        # Olhar para esquerda
#   18        # Olhar para direita
#   19        # Olhar para cima
#   20        # Rotação de 90° para a direita
#   21        # Rotação de 90° para a esquerda
#   22        # Rotação de 180°
#   23        # Rotação de 90° aleatória
#   24        # Olhar aleatóriamente
#   25        # Olhar para perto
#   26        # Olhar pata longe
#   27        # Switch ON
#   28        # Switch OFF
#   29        # Mudança de velocidade
#   30        # Mudança de frequência
#   31        # Animação em movimento ON
#   32        # Animação em movimento OFF
#   33        # Animação parado ON
#   34        # Animação parado OFF
#   35        # Direção fixa ON
#   36        # Direção fixa OFF
#   37        # Atravessar ON
#   38        # Atravessar OFF
#   39        # Transparência ON
#   40        # Transparência OFF
#   41        # Mudança de gráfico
#   42        # Mudança de opacidade
#   43        # Mudança de sinteticidade
#   44        # Tocar SE
#   45        # Script
#==============================================================================

#==============================================================================
# KTKMoveRoute
#==============================================================================
module KTKMoveRoute
  module_function
  def player_move_route_p(move_list, rep)
    move_route  = RPG::MoveRoute.new
    move_route.repeat = rep
    move_route.skippable = true
    move_cmd = RPG::MoveCommand.new
    
    move_list.each(&:reverse!)
    
    move_list.first.zip(move_list.last).each{|(code, script)|
      move_cmd.code = code
      move_cmd.parameters = [script]
      move_route.list.insert(0, move_cmd.clone)
    }
    
    $game_player.force_move_route(move_route)
  end
  
  def player_move_route(move_list, rep)
    move_route  = RPG::MoveRoute.new
    move_route.repeat = rep
    move_route.skippable = false
    move_cmd = RPG::MoveCommand.new
    
    move_list.reverse!
    
    move_list.each{|i|
      move_cmd.code = i
      move_route.list.insert(0, move_cmd.clone)
    }
    
    $game_player.force_move_route(move_route)
  end
  
  def event_move_route_p(event_id, move_list, rep)
    move_route  = RPG::MoveRoute.new
    move_route.repeat = rep
    move_route.skippable = false
    move_cmd = RPG::MoveCommand.new
    
    move_list.each(&:reverse!)
    
    move_list.first.zip(move_list.last).each{|(code, script)|
      move_cmd.code = code
      move_cmd.parameters = [script]
      move_route.list.insert(0, move_cmd.clone)
    }

    evento = $game_map.events[event_id]
    evento.force_move_route(move_route)
  end
  
  def event_move_route(event_id, move_list, rep)
    move_route  = RPG::MoveRoute.new
    move_route.repeat = rep
    move_route.skippable = false
    move_cmd = RPG::MoveCommand.new
    
    move_list.reverse!
    
    move_list.each{|i|
      move_cmd.code = i
      move_route.list.insert(0, move_cmd.clone)
    }
    evento = $game_map.events[event_id]
    evento.force_move_route(move_route)
  end
end

#==============================================================================
# Game_Interpreter
#==============================================================================
class Game_Interpreter
  def player_move_route_p(move_list, rep)
    KTKMoveRoute.player_move_route_p(move_list, rep)
  end
  
  def player_move_route(move_list, rep)
    KTKMoveRoute.player_move_route(move_list, rep)
  end
  
  def event_move_route_p(event_id, move_list, rep)
    KTKMoveRoute.event_move_route_p(event_id, move_list, rep)
  end
  
  def event_move_route(event_id, move_list, rep)
    KTKMoveRoute.event_move_route(event_id, move_list, rep)
  end
end
