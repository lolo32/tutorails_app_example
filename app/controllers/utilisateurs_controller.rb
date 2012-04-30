class UtilisateursController < ApplicationController
  def new
    @titre = 'Inscription'
  end

  def show
    @utilisateur  = Utilisateur.find( params[:id] )
    @titre        = @utilisateur.nom
  end
end
