# encoding: utf-8
class UtilisateursController < ApplicationController
  before_filter :authentifie,  :only => [ :index, :edit, :update ]
  before_filter :correct_user, :only => [ :edit, :update ]

  def index
    @titre = "Liste des utilisateurs"
    @utilisateurs = Utilisateur.paginate( :page => params[:page] )
  end

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
      sign_in @utilisateur
      flash[:success] = 'Bienvenue dans l\'Application Exemple'
      redirect_to @utilisateur
    else
      @titre      = 'Inscription'
      render 'new'
    end
  end

  def edit
    @titre = "Édition profil"
  end

  def update
    if @utilisateur.update_attributes( params[:utilisateur] )
      flash[:success] = 'Profil actualisé.'
      redirect_to @utilisateur
    else
      @titre = 'Édition profil'
      render 'edit'
    end
  end

  private

    def authentifie
      deny_access unless signed_in?
    end

    def correct_user
      @utilisateur = Utilisateur.find( params[:id] )
      redirect_to(root_path) unless current_utilisateur?(@utilisateur)
    end
end
