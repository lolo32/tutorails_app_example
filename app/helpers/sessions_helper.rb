# encoding: utf-8
module SessionsHelper

  # Authentifie l'utilisateur, en renvoyant un cookies
  def sign_in(utilisateur)
    cookies.permanent.signed[:remember_token] = [utilisateur.id, utilisateur.sel]
    self.current_utilisateur = utilisateur
  end

  # Sauvegarde l'id de l'utilisateur dans les infos de session
  def current_utilisateur=(utilisateur)
    @current_utilisateur = utilisateur
  end

  # trouver l'utilisateur courant
  def current_utilisateur
    @current_utilisateur ||= utilisateur_from_remember_token
  end

  # L'utilisateur passé est-il l'actuel ?
  def current_utilisateur?(utilisateur)
    utilisateur == current_utilisateur
  end

  # Utilisateur authentifié ?
  def signed_in?
    !current_utilisateur.nil?
  end

  # Déconnexion
  def sign_out
    cookies.delete(:remember_token)
    self.current_utilisateur = nil
  end

  # Reditige vers la page d'authentification avec un message flash en plus
  def deny_access
    store_location
    redirect_to signin_path, :notice =>'Merci de vous identifier pour accéder à cette page.'
  end

  # Redirige vers la page précédente mémorisée tout en vidant la mémoire "page précédente"
  def redirect_back_or(defaut)
    redirect_to( session[:return_to] || defaut )
    clear_return_to
  end

  private

    def utilisateur_from_remember_token
      Utilisateur.authentifie_with_sel(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

    # Mémorise la page actuelle
    def store_location
      session[:return_to] = request.fullpath
    end

    # Vide la page précédente
    def clear_return_to
      session[:return_to] = nil
    end
end
