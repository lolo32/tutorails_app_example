# En utilisant le symbole ':utilisateur', nous faisons que
# Factory Girl simule un modèle User.
FactoryGirl.define do
  factory :utilisateur do
    nom                  "Michael Hartl"
    courriel             "mhartl@example.com"
    mdp                  "foobar"
    mdp_confirmation     "foobar"
  end
end
