# encoding: utf-8
require 'spec_helper'

describe Utilisateur do
  before(:each) do
    @attr = { :nom => "Example User", :courriel => "user@example.com" }
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
end
# == Schema Information
#
# Table name: utilisateurs
#
#  id         :integer         not null, primary key
#  nom        :string(255)
#  courriel   :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

