# encoding: utf-8
require 'spec_helper'

describe UtilisateursController do
  render_views

  describe "GET 'index'" do

    describe "pour utilisateur non identifiés" do
      it "devrait refuser l'accès" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /identifier/
      end
    end # describe "pour utilisateur non identifiés"

    describe "pour un utilisateur identifié" do
      before(:each) do
        @utilisateur = test_sign_in(FactoryGirl.create(:utilisateur))
        second = FactoryGirl.create(:utilisateur, :courriel => "another@example.com")
        third  = FactoryGirl.create(:utilisateur, :courriel => "another@example.net")

        @utilisateurs = [ @utilisateur, second, third ]

        30.times do
          @utilisateurs << FactoryGirl.create( :utilisateur )
        end
      end

      it "devrait réussir" do
        get :index
        response.should be_success
      end

      it "devrait avoir le bon titre" do
        get :index
        response.should have_selector("title", :content => "Liste des utilisateurs")
      end

      it "devrait avoir un élément pour chaque utilisateur" do
        get :index
        @utilisateurs.each do |user|
          response.should have_selector("li", :content => user.nom)
        end
      end

      it "devrait avoir un élément pour chaque utilisateur" do
        get :index
        @utilisateurs[0..2].each do |user|
          response.should have_selector("li", :content => user.nom)
        end
      end

      it "devrait paginer les utilisateurs" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/utilisateurs?page=2", :content => "2")
        response.should have_selector("a", :href => "/utilisateurs?page=2", :content => "Next")
      end
    end # describe "pour un utilisateur identifié"

  end # describe "GET 'index'"

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

  end # describe "GET 'show'"

  describe "GET 'new'" do
    it "devrait exister" do
      get :new
      response.should be_success
    end

    it "devrait avoir le titre adéquat" do
      get :new
      response.should have_selector("title", :content => "Inscription")
    end
  end # describe "GET 'new'"

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
    end # describe "échec"

    describe "succès" do

      before(:each) do
        @attr = { :nom => "New User", :courriel => "user@example.com",
                  :mdp => "foobar", :mdp_confirmation => "foobar" }
      end

      it "devrait créer un utilisateur" do
        lambda do
          post :create, :utilisateur => @attr
        end.should change(Utilisateur, :count).by(1)
      end

      it "devrait identifier l'utilisateur" do
        post :create, :utilisateur => @attr
        controller.should be_signed_in
      end

      it "devrait rediriger vers la page d'affichage de l'utilisateur" do
        post :create, :utilisateur => @attr
        response.should redirect_to(utilisateur_path(assigns(:utilisateur)))
      end    

      it "devrait avoir un message de bienvenue" do
        post :create, :utilisateur => @attr
        flash[:success].should =~ /Bienvenue dans l'Application Exemple/i
      end
    end # describe "succès"
  end # describe "POST 'create'"

  describe "GET 'edit'" do

    before(:each) do
      @utilisateur = FactoryGirl.create(:utilisateur)
      test_sign_in(@utilisateur)
    end

    it "devrait réussir" do
      get :edit, :id => @utilisateur
      response.should be_success
    end

    it "devrait avoir le bon titre" do
      get :edit, :id => @utilisateur
      response.should have_selector("title", :content => "Édition profil")
    end

    it "devrait avoir un lien pour changer l'image Gravatar" do
      get :edit, :id => @utilisateur
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href    => gravatar_url,
                                         :content => "changer")
    end
  end # describe "GET 'edit'"

  describe "PUT 'update'" do
    before(:each) do
      @utilisateur = FactoryGirl.create(:utilisateur)
      test_sign_in(@utilisateur)
    end

    describe "échec" do

      before(:each) do
        @attr = { :courriel => "", :nom => "", :mdp => "",
                  :mdp_confirmation => "" }
      end

      it "devrait retourner la page d'édition" do
        put :update, :id => @utilisateur, :utilisateur => @attr
        response.should render_template('edit')
      end

      it "devrait avoir le bon titre" do
        put :update, :id => @utilisateur, :utilisateur => @attr
        response.should have_selector("title", :content => "Édition profil")
      end
    end # describe "échec"

    describe "succès" do

      before(:each) do
        @attr = { :nom => "New Name", :courriel => "user@example.org",
                  :mdp => "barbaz", :mdp_confirmation => "barbaz" }
      end

      it "devrait modifier les caractéristiques de l'utilisateur" do
        put :update, :id => @utilisateur, :utilisateur => @attr
        @utilisateur.reload
        @utilisateur.nom.should  == @attr[:nom]
        @utilisateur.courriel.should == @attr[:courriel]
      end

      it "devrait rediriger vers la page d'affichage de l'utilisateur" do
        put :update, :id => @utilisateur, :utilisateur => @attr
        response.should redirect_to(utilisateur_path(@utilisateur))
      end

      it "devrait afficher un message flash" do
        put :update, :id => @utilisateur, :utilisateur => @attr
        flash[:success].should =~ /actualisé/
      end
    end # describe "succès"
  end # describe "PUT 'update'"

  describe "authentification des pages edit/update" do

    before(:each) do
      @utilisateur = FactoryGirl.create(:utilisateur)
    end

    describe "pour un utilisateur non identifié" do

      it "devrait refuser l'acccès à l'action 'edit'" do
        get :edit, :id => @utilisateur
        response.should redirect_to(signin_path)
      end

      it "devrait refuser l'accès à l'action 'update'" do
        put :update, :id => @utilisateur, :utilisateur => {}
        response.should redirect_to(signin_path)
      end
    end # describe "pour un utilisateur non identifié"

    describe 'pour un utilisateur identifié' do
      before(:each) do
        wrong_user = FactoryGirl.create( :utilisateur, :courriel => 'user@example.net' )
        test_sign_in( wrong_user )
      end

      it "devrait correspondre à l'utilisateur à éditer" do
        get :edit, :id => @utilisateur
        response.should redirect_to(root_path)
      end

      it "devrait correspondre à l'utilisateur à actualiser" do
        put :update, :id => @utilisateur, :utilisateur => {}
        response.should redirect_to(root_path)
      end
    end # describe 'pour un utilisateur identifié'
  end # describe "authentification des pages edit/update"
end
