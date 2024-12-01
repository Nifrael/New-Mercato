class UserService
  def self.create_or_update_user(email, first_name, last_name, password, avatar)
    user = User.find_or_initialize_by(email: email)
    user.assign_attributes(
      first_name: first_name,
      last_name: last_name,
      password: password,
      avatar: avatar
    )

    if user.save
      if user.saved_change_to_id?
        puts "Utilisateur créé : #{user.first_name} #{user.last_name} (#{user.email})"
      else
        puts "Utilisateur mis à jour : #{user.first_name} #{user.last_name} (#{user.email})"
      end
    else
        puts "Erreur concernant #{email}: #{user.errors.full_messages.join(', ')}"
    end
  end
end
