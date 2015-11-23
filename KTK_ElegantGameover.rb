#==============================================================================
# KTK - Elegant Gameover
# Criado por Fogomax (01/06/2014)
#------------------------------------------------------------------------------
# Edita o Gameover para deixá-lo mais elegante. Para o efeito ser visível a
# imagem de Gameover deve ter o fundo transparente.
#==============================================================================

#==============================================================================
# Scene_Gameover
#==============================================================================
class Scene_Gameover
  
  #----------------------------------------------------------------------------
  # Alias method: start
  #----------------------------------------------------------------------------
  alias egameover_start start
  
  def start
    super
    create_scene_background
    egameover_start
  end
  
  #----------------------------------------------------------------------------
  # Alias method: terminate
  #----------------------------------------------------------------------------
  alias egameover_terminate terminate
  
  def terminate
    super
    dispose_scene_background
    egameover_terminate
  end
  
  #----------------------------------------------------------------------------
  # Alias method: create_background
  #----------------------------------------------------------------------------
  alias ecreate_background create_background
  
  def create_background
    ecreate_background
    @sprite.z = 20
  end
  
  def create_scene_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = SceneManager.background_bitmap
    @background_sprite.color.set(16, 16, 16, 128)
    @background_sprite.z = 10
  end
 
  def dispose_scene_background
    @background_sprite.dispose
  end
end
