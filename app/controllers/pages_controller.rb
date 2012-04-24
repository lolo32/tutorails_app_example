# encoding: utf-8
class PagesController < ApplicationController
  def home
    @titre = "Accueil"
  end

  def contact
    @titre = "Contact"
  end

  def about
    @titre = "À propos"
  end

  def help
    @titre = "Aide"
  end
end
