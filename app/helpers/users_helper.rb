module UsersHelper
  def badge_name(col)
    temp = col.to_s.split('_')
    name = temp[0]
    num = temp[1]
    t("badges.#{name}", :num => num)
  end
end
