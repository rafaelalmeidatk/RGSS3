#==============================================================================
# KTK - Actor Status Info
# Criado por Fogomax (06/06/2014)
#------------------------------------------------------------------------------
# Permite pegar rapidamente o valor de atributos dos Actors
#------------------------------------------------------------------------------
# ● Como Usar
#
#   Para pegar o valor de um parâmetro, use o comando em um "Chamar Script":
#     ktk_actor_info(actor_id, info_id)
#   Sendo:
#   actor_id - ID do Actor escolhido
#   info_id - ID do parâmetro, em caso de dúvidas, consulte a lista abaixo
#
#------------------------------------------------------------------------------
# ---------------------
# | ID dos parâmetros |
# ---------------------
#   1 - HP Atual
#   2 - MP Atual
#   3 - HP Máximo
#   4 - MP Máximo
#   5 - Ataque
#   6 - Defesa
#   7 - Inteligência
#   8 - Resistência
#   9 - Agilidade
#   10 - Sorte
#   11 - Precisão
#   12 - Esquiva
#   13 - Crítico
#   14 - Esquiva Crítica
#   15 - Esquiva Mágica
#   16 - Reflexão
#   17 - Contra Ataque
#   18 - Regeneração de HP
#   19 - Regeneração de SP
#   20 - Regeneração de TP
#   21 - Taxa de Alvo
#   22 - Taxa de Defesa
#   23 - Taxa de Recuperação
#   24 - Farmacologia
#   25 - Taxa de Custo de MP
#   26 - Taxa de Carregamento do TP
#   27 - Taxa de Dano Físico
#   28 - Taxa de Dano Mágico
#   29 - Taxa de Dano por Terreno
#   30 - Taxa de Experiência
#==============================================================================


#==============================================================================
# Game_Interpreter
#==============================================================================
class Game_Interpreter
  def ktk_actor_info(actor_id, info_id)
    actor = $game_actors[actor_id]
    case info_id
      when 1; return actor.hp
      when 2; return actor.mp
      when 3; return actor.mhp
      when 4; return actor.mmp
      when 5; return actor.atk
      when 6; return actor.def
      when 7; return actor.mat
      when 8; return actor.mdf
      when 9; return actor.agi
      when 10; return actor.luk
      when 11; return (actor.hit * 100)
      when 12; return (actor.eva * 100)
      when 13; return (actor.cri * 100)
      when 14; return (actor.cev * 100)
      when 15; return (actor.mev * 100)
      when 16; return (actor.mrf * 100)
      when 17; return (actor.cnt * 100)
      when 18; return (actor.hrg * 100)
      when 19; return (actor.mrg * 100)
      when 20; return (actor.trg * 100)
      when 21; return (actor.tgr * 100)
      when 22; return (actor.grd * 100)
      when 23; return (actor.rec * 100)
      when 24; return (actor.pha * 100)
      when 25; return (actor.mcr * 100)
      when 26; return (actor.tcr * 100)
      when 27; return (actor.pdr * 100)
      when 28; return (actor.mdr * 100)
      when 29; return (actor.fdr * 100)
      when 30; return (actor.ext * 100)
      else return 0
    end
  end
end
