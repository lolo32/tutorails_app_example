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

  def signed_in?
    !current_utilisateur.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_utilisateur = nil
  end

  private

    def utilisateur_from_remember_token
      Utilisateur.authentifie_with_sel(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
