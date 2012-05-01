class Utilisateur < ActiveRecord::Base
  attr_accessor   :mdp
  attr_accessible :nom, :courriel, :mdp, :mdp_confirmation

  courriel_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :nom,      :presence     => true,
                       :length       => { :maximum => 50 }
  validates :courriel, :presence     => true,
                       :format       => { :with => courriel_regex },
                       :uniqueness   => { :case_sensitive => false }
  # Crée automatique l'attribut virtuel 'mdp_confirmation'.
  validates :mdp,      :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  # Méthode appelée juste avant de sauvegarder
  before_save :chiffre_mdp

  # Retourne vrai si le mot de passe correspond
  # Compare mdp_chiffre avec la version chiffre de mdp_soumis
  def has_mdp?( mdp_soumis )
    mdp_chiffre == chiffre( mdp_soumis )
  end

  def self.authentifie( courriel, mdp_saisis )
    user = find_by_courriel( courriel )
    return nil            if user.nil?
    return user           if user.has_mdp?( mdp_saisis )
  end

  def self.authentifie_with_sel( id, cookie_sel )
    user = find_by_id( id )
    (user && user.sel == cookie_sel) ? user : nil
  end

  private

    def chiffre_mdp
      self.sel = gen_sel if new_record?
      self.mdp_chiffre = chiffre( mdp )
    end

    def chiffre( string )
      hash_securise( "#{sel}--#{string}" )
    end

    def gen_sel
      hash_securise( "#{Time.now.utc}--#{mdp}" )
    end

    def hash_securise( string )
      Digest::SHA2.hexdigest( string )
    end
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

