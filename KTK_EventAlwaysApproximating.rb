#==============================================================================
# KTK - Event Always Approximating
# Criado por Fogomax (08/07/2014)
#------------------------------------------------------------------------------
# Enquanto uma switch estiver ligada, os eventos com o movimento do tipo
# "Aproximar" irá sempre andar em direção ao jogador, ao invés de dar
# movimentos aleatórios em certos passos
#==============================================================================

module EAApp
  #----------------------------------------------------------------------------
  # Início da configuração
  #----------------------------------------------------------------------------
  
  Switch_Ativar = 1 # Switch que vai ativar o script
  
  #----------------------------------------------------------------------------
  # Fim da configuração
  #----------------------------------------------------------------------------
end

#==============================================================================
# Game_Event
#==============================================================================
def Game_Event
  alias event_always_app_mttp move_type_toward_player
  def move_type_toward_player
    $game_switches[EAApp::Switch_Ativar] ? move_toward_player : event_always_app_mttp
  end
end
