# encoding: utf-8
require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    #
    # Define @base_title here.
    #
    @base_titre = "Simple App du Tutoriel Ruby on Rails"
  end

  describe "GET 'home'" do
    it "devrait exister" do
      get 'home'
      response.should be_success
    end

    it "devrait avoir le bon titre" do
      get 'home'
      response.should have_selector("title", :content => @base_titre + " | Accueil")
    end
  end

  describe "GET 'contact'" do
    it "devrait exister" do
      get 'contact'
      response.should be_success
    end

    it "devrait avoir le bon titre" do
      get 'contact'
      response.should have_selector("title", :content => @base_titre + " | Contact")
    end
  end

  describe "GET 'about'" do
    it "devrait exister" do
      get 'about'
      response.should be_success
    end

    it "devrait avoir le bon titre" do
      get 'about'
      response.should have_selector("title", :content => @base_titre + " | À propos")
    end
  end

  describe "GET 'help'" do
    it "devrait exister" do
      get 'help'
      response.should be_success
    end

  it "devrait avoir le bn titre" do
    get 'help'
    response.should have_selector("title", :content => @base_titre + " | Aide")
  end
  end
end
