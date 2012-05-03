# encoding: utf-8
require 'spec_helper'

describe Utilisateur do
  before(:each) do
    @attr = {
        :nom              => "Example User",
        :courriel         => "user@example.com",
        :mdp              => "foobar",
        :mdp_confirmation => "foobar"
    }
  end

  it "devrait créer une nouvelle instance dotée des attributs valides" do
    Utilisateur.create!(@attr)
  end

  it "exige un nom" do
    bad_guy = Utilisateur.new( @attr.merge( :nom => '' ) )
    bad_guy.should_not be_valid
  end

  it "exige une adresse email" do
    no_email_user = Utilisateur.new(@attr.merge(:courriel => ""))
    no_email_user.should_not be_valid
  end

  it "devrait rejeter les noms trop longs" do
    long_nom = "a" * 51
    long_nom_user = Utilisateur.new(@attr.merge(:nom => long_nom))
    long_nom_user.should_not be_valid
  end

  it "devrait accepter une adresse email valide" do
    adresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    adresses.each do |address|
      valid_email_user = Utilisateur.new(@attr.merge(:courriel => address))
      valid_email_user.should be_valid
    end
  end

  it "devrait rejeter une adresse email invalide" do
    adresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    adresses.each do |address|
      invalid_email_user = Utilisateur.new(@attr.merge(:courriel => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "devrait rejeter un email double" do
    # Place un utilisateur avec un email donné dans la BD.
    Utilisateur.create!(@attr)
    user_with_duplicate_email = Utilisateur.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "devrait rejeter une adresse email invalide jusqu'à la casse" do
    upcased_email = @attr[:courriel].upcase
    Utilisateur.create!(@attr.merge(:courriel => upcased_email))
    user_with_duplicate_email = Utilisateur.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do

    it "devrait exiger un mot de passe" do
      Utilisateur.new(@attr.merge(:mdp => "", :mdp_confirmation => "")).
        should_not be_valid
    end

    it "devrait exiger une confirmation du mot de passe qui correspond" do
      Utilisateur.new(@attr.merge(:mdp_confirmation => "invalid")).
        should_not be_valid
    end

    it "devrait rejeter les mots de passe (trop) courts" do
      short = "a" * 5
      hash = @attr.merge(:mdp => short, :mdp_confirmation => short)
      Utilisateur.new(hash).should_not be_valid
    end

    it "devrait rejeter les (trop) longs mots de passe" do
      long = "a" * 41
      hash = @attr.merge(:mdp => long, :mdp_confirmation => long)
      Utilisateur.new(hash).should_not be_valid
    end
  end # describe "password validations"

  describe "password encryption" do

    before(:each) do
      @utilisateur = Utilisateur.create!(@attr)
    end

    it "devrait avoir un attribut mot de passe chiffré" do
      @utilisateur.should respond_to(:mdp_chiffre)
    end

    it "devrait définir le mot de passe chiffré" do
      @utilisateur.mdp_chiffre.should_not be_blank
    end

    it 'doit retourner true si les mots de passe coïncident' do
      @utilisateur.has_mdp?( @attr[:mdp] ).should be_true
    end

    it 'doit retourner false si les mots de passe divergent' do
      @utilisateur.has_mdp?( "invalide" ).should be_false
    end

    describe "méthode d'authentification" do

    it "devrait retourner nul en cas d'inéquation entre email/mot de passe" do
        wrong_password_user = Utilisateur.authentifie(@attr[:courriel], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "devrait retourner nil quand un email ne correspond à aucun utilisateur" do
        nonexistent_user = Utilisateur.authentifie("bar@foo.com", @attr[:mdp])
        nonexistent_user.should be_nil
      end

      it "devrait retourner l'utilisateur si email/mot de passe correspondent" do
        matching_user = Utilisateur.authentifie(@attr[:courriel], @attr[:mdp])
        matching_user.should == @utilisateur
      end
    end # describe "méthode d'authentification"
  end # describe "password encryption"

  describe "Attribut admin" do

    before(:each) do
      @utilisateur = Utilisateur.create!(@attr)
    end

    it "devrait confirmer l'existence de `admin`" do
      @utilisateur.should respond_to(:admin)
    end

    it "ne devrait pas être un administrateur par défaut" do
      @utilisateur.should_not be_admin
    end

    it "devrait pouvoir devenir un administrateur" do
      @utilisateur.toggle!(:admin)
      @utilisateur.should be_admin
    end
  end # describe "Attribut admin"
end

# == Schema Information
#
# Table name: utilisateurs
#
#  id          :integer         not null, primary key
#  nom         :string(255)
#  courriel    :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  mdp_chiffre :string(255)
#  sel         :string(255)
#

