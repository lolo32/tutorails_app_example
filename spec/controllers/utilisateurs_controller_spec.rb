# encoding: utf-8
require 'spec_helper'

describe UtilisateursController do
  render_views

  describe "GET 'show'" do
    before(:each) do
      @utilisateur = FactoryGirl.create(:utilisateur)
    end

    it "devrait réussir" do
      get :show, :id => @utilisateur
      response.should be_success
    end

    it "devrait trouver le bon utilisateur" do
      get :show, :id => @utilisateur
      assigns(:utilisateur).should eq(@utilisateur)
    end

    it 'devrait avoir le bon titre' do
      get :show, :id => @utilisateur
      response.should have_selector("title", :content => @utilisateur.nom)
    end

    it 'devrait inclure le nom de l\'utilisateur' do
      get :show, :id => @utilisateur
      response.should have_selector("h1", :content => @utilisateur.nom)
    end

    it "devrait avoir une image de profil" do
      get :show, :id => @utilisateur
      response.should have_selector("h1>img", :class => "gravatar")
    end

  end

  describe "GET 'new'" do
    it "devrait exister" do
      get 'new'
      response.should be_success
    end

    it "devrait avoir le titre adéquat" do
      get 'new'
      response.should have_selector("title", :content => "Inscription")
    end
  end
end
