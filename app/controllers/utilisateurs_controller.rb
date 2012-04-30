class UtilisateursController < ApplicationController
  def new
    @utilisateur  = Utilisateur.new
    @titre        = 'Inscription'
  end

  def show
    @utilisateur  = Utilisateur.find( params[:id] )
    @titre        = @utilisateur.nom
  end

  def create
    @utilisateur  = Utilisateur.new( params[ :utilisateur ])
    if @utilisateur.save
      flash[:success] = 'Bienvenue dans l''Application Exemple'
      redirect_to @utilisateur
    else
      @titre      = 'Inscription'
      render 'new'
    end
  end
end
