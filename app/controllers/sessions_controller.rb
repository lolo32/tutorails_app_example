class SessionsController < ApplicationController

  def new
    @titre = 'S\'identifier'
  end

  def create
    # On recherche le couple courriel/mdp
    utilisateur = Utilisateur.authentifie( params[:session][:courriel],
                                           params[:session][:mdp])
    if utilisateur.nil?
      # Aucun Utilisateur correspondant. Affiche un message d'erreur, et redemande les infos
      flash.now[:error] = 'Combinaison courriel/mot de passe invalide&nbsp!'.html_safe
      @titre = 'S\'identifier'
      render 'new'
    else
      # Authentifie l'utilisateur et redirige vers sa page d'affichage.
      sign_in utilisateur
      redirect_back_or utilisateur
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
