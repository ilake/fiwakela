module RecordsHelper

  def owner_area(&block)
    if @user.fb_id == session[:current_facebook_user_id].to_s || @user.fb_id == @current_facebook_user.id.to_s
      concat capture(&block)
    end
  end

  HTTP_REGEX = /((http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/[A-Za-z\.0-9_\+\?%\/=&\-]*)?)/ix

  def full_format_content(content)
    c = content
    return '' if c.blank?

    return c.gsub(/\r\n/, "\n").gsub(/\n/) { |e|
      "<br />" unless $` =~/<br \/>$/
    }.gsub(HTTP_REGEX) do  |e|
      if $` =~/(href|src)=(?:"|')$/
        e
      else
        "<a href='#{e}'>#{e}</a>"
      end
    end
  end

  def friend_status(status)
    if status == 0
      "<a alt='#{t('friend.absence')}' title='#{t('friend.absence')}'><span class='bulb empty-light fl-r'></span></a>"
    elsif status == 4
      "<a alt='#{t('friend.leave')}' title='#{t('friend.leave')}'><span class='bulb black-light fl-r'></span></a>"
    elsif status == 2
      "<a alt='#{t('friend.late')}' title='#{t('friend.late')}'><span class='bulb red-light fl-r'></span></a>"
    elsif status == 1
      "<a alt='#{t('friend.early')}' title='#{t('friend.early')}'><span class='bulb green-light fl-r'></span></a>"
    end
  end

  def record_status_img(status)
    if status
      "<a alt='#{t('record.realtime')}' title='#{t('record.realtime')}'><span class='record-img green-flag record-info'></span></a>"
    else
      "<a alt='#{t('record.manual')}' title='#{t('record.manual')}'><span class='record-img yellow-flag record-info'></span></a>"
    end
  end

  def record_result_img(status)
    if status
      "<a alt='#{t('record.success')}' title='#{t('record.success')}'><span class='record-img success-symbol record-info'></span></a>"
    else
      "<a alt='#{t('record.fail')}' title='#{t('record.fail')}'><span class='record-img fail-symbol record-info'></span></a>"
    end
  end

  def record_auth_img(pri)
    if pri
    "<a alt='#{t('record.pri')}' title='#{t('record.pri')}'><span class='record-img pri-symbol'></span></a>"
    end
  end

  def datepicker_css
    unless session[:locale] == 'en'
      javascript_include_tag "datepicker/i18n/ui.datepicker-#{session[:locale]}.js"
    end
  end

  def last_record_status(user)
    if time = user.status.last_record_at
      time.to_s(:time)
    else
      t('status.norecord')
    end
  end

  def target_time_status(user)
    user.target_time ? user.target_time.to_s(:hm) : (link_to(t('common.setting'), edit_user_path(session[:user]), :rel => "facebox", :class => 'alert-red') if user.fb_id == session[:current_facebook_user_id].to_s || user.fb_id == @current_facebook_user.id.to_s)
  end
end
