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
    end

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
    end
  end
end
