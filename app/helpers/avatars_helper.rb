module AvatarsHelper
  # Photo du joueur en avatar rond, ou son initiale s'il n'a pas de photo.
  # alt="" : l'image est décorative, le nom du joueur est toujours écrit à côté.
  def player_avatar(player)
    if player.photo.present?
      image_tag player.photo, alt: "", class: "avatar", loading: "lazy"
    else
      tag.span player.name.first, class: "avatar avatar--initials", "aria-hidden": true
    end
  end
end
