module UtilisateursHelper

  # helper pour afficher plus facilement les gravatars
  def gravatar_for( user, options = { :size => 50 } )
    gravatar_image_tag( user.courriel.downcase,
                            :alt         => user.nom,
                            :class       => 'gravatar',
                            :gravatar    => options
                      )
  end
end
