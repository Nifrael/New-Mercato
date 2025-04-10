class ChangePositionTypeInPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :position_enum, :integer
    add_index :players, :position_enum

    Player.all.each do |player|
      position_enum_value = case player.position
        when 'Gardien'
          0
        when 'Défenseur'
          1
        when 'Milieu'
          2
        when 'Attaquant'
          3
        when nil
          4
        else
          raise "Position non reconnue pour le joueur ID #{player.id}: #{player.position}"
        end
      player.position_enum = position_enum_value
      unless player.save
        raise "Erreur de sauvegarde pour le joueur ID #{player.id}: #{player.errors.full_messages.join(', ')}"
      end
      puts "Joueur ID: #{player.id} sauvegardé avec position_enum: #{player.position_enum}"
    end
  end
end
