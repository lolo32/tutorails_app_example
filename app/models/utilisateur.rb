class Utilisateur < ActiveRecord::Base
  attr_accessible :courriel, :nom

  courriel_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :nom,      :presence   => true,
                       :length     => { :maximum => 50 }
  validates :courriel, :presence   => true,
                       :format     => { :with => courriel_regex },
                       :uniqueness => { :case_sensitive => false }
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

