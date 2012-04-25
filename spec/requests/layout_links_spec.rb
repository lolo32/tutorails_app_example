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
end
