#==============================================================================
# KTK - Map Battle Background
# Criado por Fogomax (02/06/2014)
#------------------------------------------------------------------------------
# Transforma o fundo da batalha no cenário do mapa
#==============================================================================

module MapBattleBg
  #----------------------------------------------------------------------------
  # Início das configurações
  #----------------------------------------------------------------------------
  
  # Ativar o script? Sim: true | Não: false
  Ativado = true
  
  #-------------------------------------------------------------------------#
  # Você também pode ativar/desativar o script durante o jogo trocando o    #
  # valor da variável através do Chamar Script utilizando:                  #
  #                                                                         #
  #  MapBattleBg::Ativado = valor                                           #
  #                                                                         #
  # O valor deve ser um configurados acima (true ou false).                 #
  #-------------------------------------------------------------------------#
  
  #----------------------------------------------------------------------------
  # Fim das configurações
  #----------------------------------------------------------------------------
end

#==============================================================================
# Spriteset_Battle
#==============================================================================
class Spriteset_Battle
  #----------------------------------------------------------------------------
  # Overwrite method: create_battleback1
  #----------------------------------------------------------------------------
  def create_battleback1
    unless MapBattleBg::Ativado; ktk_map_battle_bg_cb1; return; end
    @back1_sprite = Sprite.new
    @back1_sprite.bitmap = SceneManager.background_bitmap
    @back1_sprite.color.set(16, 16, 16, 128)
    @back1_sprite.z = -10
    center_sprite(@back1_sprite)
  end
  
  #----------------------------------------------------------------------------
  # Overwrite method: create_battleback2
  #----------------------------------------------------------------------------
  def create_battleback2
    unless MapBattleBg::Ativado; ktk_map_battle_bg_cb2; return; end
    @back2_sprite = Sprite.new
    @back2_sprite.bitmap = Bitmap.new(1, 1)
    @back2_sprite.visible = false
  end
end
