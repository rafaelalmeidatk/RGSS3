#==============================================================================
# Arc Engine - Detectar posição/colisão
# Criado por Fogomax (20/07/2014 - Arc Engine por Khas)
#-----------------------------------------------------------------------------
# Permite criar uma colisão com eventos mais realista. O script deve ser
# utilizado com a Arc Engine do Khas.
#==============================================================================
 
module AEDC_F
  #----------------------------------------------------------------------------
  # Início da configuração
  #----------------------------------------------------------------------------
 
  # Tamanho padrão da colisão
  Default_CWH = 40
 
  #----------------------------------------------------------------------------
  # Fim da configuração
  #----------------------------------------------------------------------------
end

class Game_Interpreter
  def colisao?(direction, id, distance=AEDC_F::Default_CWH)
    x = $game_map.events[@event_id].ax; y = $game_map.events[@event_id].ay
    ax = id == 0 ? $game_player.ax - x : $game_map.events[id].ax - x
    ay = id == 0 ? $game_player.ay - y : $game_map.events[id].ay - y
    case direction
    when 4
      ay <= distance && ay >= 0  && ax > -24 && ax <= 0 # 24
    when 2
      ax >= distance * -1 && ax <= 0 && ay > -30 && ay <= 0
    when 3
      ax <= distance && ax >= 0 && ay > -30 && ay <= 0
    when 1
      ay >= distance * -1 && ay <= 0  && ax > -30 && ax < 20 #24
    end
  end
 
  def colisao_lados?(id, distance=AEDC_F::Default_CWH)
    return true if colisao?(1, id, distance, distance)
    return true if colisao?(2, id, distance, distance)
    return true if colisao?(3, id, distance, distance)
    return true if colisao?(4, id, distance, distance)
  end
 
  def colisao_frente?(id, distance=AEDC_F::Default_CWH)
    case $game_map.events[@event_id].direction
    when 2; return true if colisao?(4, id, distance)
    when 4; return true if colisao?(2, id, distance)
    when 6; return true if colisao?(3, id, distance)
    when 8; return true if colisao?(1, id, distance)
    end
  end
 
  def colisao_atras?(id, distance=AEDC_F::Default_CWH)
    case $game_map.events[@event_id].direction
    when 2; return true if colisao?(1, id, distance)
    when 4; return true if colisao?(3, id, distance)
    when 6; return true if colisao?(4, id, distance)
    when 8; return true if colisao?(4, id, distance)
    end
  end
end
