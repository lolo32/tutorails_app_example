# encoding: utf-8
require 'faker'

namespace :db do
  desc "Peupler la base de données avec des données fictives"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = Utilisateur.create!(:nom              => "Utilisateur exemple",
                                :courriel         => "example@railstutorial.org",
                                :mdp              => "foobar",
                                :mdp_confirmation => "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      nom  = Faker::Name.name
      courriel = "example-#{n+1}@railstutorial.org"
      mdp  = "motdepasse"
      Utilisateur.create!(:nom              => nom,
                          :courriel         => courriel,
                          :mdp              => mdp,
                          :mdp_confirmation => mdp)
    end
  end
end
