# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def user_image_tag(img = 'http://static.ak.fbcdn.net/pics/q_silhouette.gif')
    image_tag(img)
  end
end
