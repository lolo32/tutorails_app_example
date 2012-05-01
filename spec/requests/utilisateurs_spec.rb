# encoding: utf-8
require 'spec_helper'

describe "Utilisateurs" do

  describe "une inscription" do

    describe "ratée" do
      it "ne devrait pas créer un nouvel utilisateur" do
        lambda do
          visit signup_path
          fill_in "Nom",           :with => ""
          fill_in "Courriel",      :with => ""
          fill_in "Mot de passe",  :with => ""
          fill_in "Confirmation",  :with => ""
          click_button
          response.should render_template('utilisateurs/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(Utilisateur, :count)
      end
    end # describe "ratée"

    describe "réussie" do
      it "devrait créer un nouvel utilisateurr" do
        lambda do
          visit signup_path
          fill_in "Nom",          :with => "Example User"
          fill_in "Courriel",     :with => "user@example.com"
          fill_in "Mot de passe", :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Bienvenue")
          response.should render_template('utilisateurs/show')
        end.should change(Utilisateur, :count).by(1)
      end
    end # describe "réussie"
  end # describe "une inscription"

  describe "identification/deconnexion" do

    describe "l'échec" do
      it "ne devrait pas identifier l'utilisateur" do
        visit signin_path
        fill_in "Courriel",          :with => ""
        fill_in "Mot de passe",      :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "invalide")
      end
    end # describe "l'échec"

    describe "le succès" do
      it "devrait identifier un utilisateur puis le déconnecter" do
        utilisateur = FactoryGirl.create(:utilisateur)
        visit signin_path
        fill_in "Courriel",          :with => utilisateur.courriel
        fill_in "Mot de passe",      :with => utilisateur.mdp
        click_button
        controller.should be_signed_in
        click_link "Déconnexion"
        controller.should_not be_signed_in
      end
    end # describe "le succès"
  end # describe "identification/deconnexion"
end
