# encoding: utf-8
require 'spec_helper'

describe "RedirectionAmicales" do

  it "devrait rediriger vers la page voulue après identification" do
    utilisateur = FactoryGirl.create(:utilisateur)
    visit edit_utilisateur_path(utilisateur)
    # Le test suit automatiquement la redirection vers la page d'identification
    fill_in :courriel,      :with => utilisateur.courriel
    fill_in "Mot de passe", :with => utilisateur.mdp
    click_button
    # Le test suit à nouveau la redirection, cette fois vers utilisateur/edit
    response.should render_template('utilisateurs/edit')
  end

end
