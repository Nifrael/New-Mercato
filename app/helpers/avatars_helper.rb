module AvatarsHelper
  # Photo du joueur en avatar rond, ou son initiale s'il n'a pas de photo.
  # alt="" : l'image est décorative, le nom du joueur est toujours écrit à côté.
  # size: :lg → grand avatar (cartes du catalogue, fiche joueur).
  def player_avatar(player, size: nil)
    classes = [ "avatar", ("avatar--#{size}" if size) ]

    if player.photo.present?
      image_tag player.photo, alt: "", class: classes, loading: "lazy"
    else
      tag.span player.name.first, class: classes + [ "avatar--initials" ], "aria-hidden": true
    end
  end
end
