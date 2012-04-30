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
      get :new
      response.should be_success
    end

    it "devrait avoir le titre adéquat" do
      get :new
      response.should have_selector("title", :content => "Inscription")
    end
  end

  describe "POST 'create'" do

    describe "échec" do

      before(:each) do
        @attr = { :nom => "", :courriel => "", :mdp => "",
                  :mdp_confirmation => "" }
      end

      it "ne devrait pas créer d'utilisateur" do
        lambda do
          post :create, :utilisateur => @attr
        end.should_not change(Utilisateur, :count)
      end

      it "devrait avoir le bon titre" do
        post :create, :utilisateur => @attr
        response.should have_selector("title", :content => "Inscription")
      end

      it "devrait rendre la page 'new'" do
        post :create, :utilisateur => @attr
        response.should render_template('new')
      end
    end

    describe "succès" do

      before(:each) do
        @attr = { :nom => "New User", :courriel => "user@example.com",
                  :mdp => "foobar", :mdp_confirmation => "foobar" }
      end

      it "devrait créer un utilisateur" do
        lambda do
          post :create, :utilisateur => @attr
        end.should change(Utilisateurer, :count).by(1)
      end

      it "devrait rediriger vers la page d'affichage de l'utilisateur" do
        post :create, :utilisateur => @attr
        response.should redirect_to(utilisateur_path(assigns(:utilisateur)))
      end    
    end

    it "devrait avoir un message de bienvenue" do
      post :create, :utilisateur => @attr
      flash[:success].should =~ /Bienvenue dans l'Application Exemple/i
    end
  end
end
