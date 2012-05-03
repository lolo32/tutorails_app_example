# En utilisant le symbole ':utilisateur', nous faisons que
# Factory Girl simule un modèle User.
FactoryGirl.define do
  sequence :courriel do |n|
    "personne-#{n}@example.com"
  end

  factory :utilisateur do
    nom                  "Michael Hartl"
#   courriel             "mhartl@example.com"
    courriel
    mdp                  "foobar"
    mdp_confirmation     "foobar"
  end
end
