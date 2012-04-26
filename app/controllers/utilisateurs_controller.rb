class UtilisateursController < ApplicationController
  def new
    @titre = 'Inscription'
  end

  def show
    @user = Utilisateur.find( params[:id] )
  end
end
