# encoding: utf-8
require 'spec_helper'

describe "LayoutLinks" do

  it "devrait trouver une page Accueil à '/'" do
    get '/'
    response.should have_selector('title', :content => "Accueil")
  end

  it "devrait trouver une page Contact à '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "devrait trouver une page À Propos à '/about'" do
    get '/about'
    response.should have_selector('title', :content => "À propos")
  end

  it "devrait trouver une page Aide à '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Aide")
  end

  it "devrait trouver une page d'inscription à '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Inscription")
  end

  it "devrait avoir le bon lien sur le layout" do
    visit root_path
    click_link "À Propos"
    response.should have_selector('title', :content => "À propos")
    click_link "Aide"
    response.should have_selector('title', :content => 'Aide')
    click_link "Contact"
    response.should have_selector('title', :content => 'Contact')
    click_link "Accueil"
    response.should have_selector('title', :content => 'Accueil')
    click_link "S'inscrire !"
    response.should have_selector('title', :content => "Inscription")
  end

  describe "quand pas identifié" do
    it "doit avoir un lien de connexion" do
      visit root_path
      response.should have_selector('a', :href      => signin_path,
                                         :content   => "S'identifier")
    end
  end # describe "quand pas identifié"

  describe "quand identifié" do

    before (:each) do
      @utilisateur = FactoryGirl.create(:utilisateur)
      visit signin_path
      fill_in :courriel,      :with => @utilisateur.courriel
      fill_in "Mot de passe", :with => @utilisateur.mdp
      click_button
    end

    it "devrait avoir un lien de déconnexion" do
      visit root_path
      response.should have_selector("a", :href    => signout_path,
                                         :content => "Déconnexion")
    end
    it "devrait avoir un lien vers le profil" do
      visit root_path
      response.should have_selector("a", :href    => utilisateur_path(@utilisateur),
                                         :content => 'Profil')
    end
  end # describe "quand pas identifié"
end
