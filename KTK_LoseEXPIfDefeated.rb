#==============================================================================
# KTK - Lose EXP if defeated
# Criado por Fogomax (04/06/2014)
#------------------------------------------------------------------------------
# Ao perder uma batalha, permite retirar certa porcentagem de experiência dos
# membros do grupo
#==============================================================================

module LoseEXP
  #----------------------------------------------------------------------------
  # Início da configuração
  #----------------------------------------------------------------------------
  
  # Ativar a perda de experiência? Sim: true | Não: false
  Can_Lose = true
  
  # Porcentagem da perda de experiência
  EXP_Porc = 3
  
  #----------------------------------------------------------------------------
  # Final da configuração
  #----------------------------------------------------------------------------
end

#==============================================================================
# BattleManager
#==============================================================================
class << BattleManager
  
  #----------------------------------------------------------------------------
  # Alias method: process_defeat
  #----------------------------------------------------------------------------
  alias ktk_lose_exp_def_pd process_defeat
  
  def process_defeat
    if LoseEXP::Can_Lose
      $game_party.members.each{|actor|
        v = (actor.exp * ((100 - LoseEXP::EXP_Porc) / 100.0)).to_i
        actor.exp > v ? actor.change_exp(v, false) : actor.change_exp(1, false)
      }
    end
    ktk_lose_exp_def_pd
  end
end
