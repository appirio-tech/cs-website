module AccountsHelper

  MENU_OPTIONS_TOP = { :account_details      => {:value => "account details",     :link => "/account/details"},
                       :school_work_info     => {:value => "school & work info",  :link => "/account/school"},
                       :edit_public_profile  => {:value => "edit public profile", :link => "#"},
                       :change_password      => {:value => "change password",     :link => "/account/password"}}

  MENU_OPTIONS_BOTTOM = { :my_challenges        => {:value => "my challenges",       :link => "/account/challenges"},
                          :discussions          => {:value => "discussions",         :link => "#"},
                          :outstanding_reviews  => {:value => "outstanding reviews", :link => "#"}}

  def build_menu(position,selected_item)
    content = ""
    eval("MENU_OPTIONS_#{position.upcase}").each do |item,options|
      content  += "<li>"
      if item.to_s == selected_item
        content += "<a href='#' class='active'>#{options[:value]}</a>"
      else
        content += "<a href='#{options[:link]}' class=''>#{options[:value]}</a>"
      end
      content += "</li>"
    end
    return content.html_safe
  end

  def work_options
    [["Please select ...",nil],["Contractor","Contractor"],["Employed","Employed"],["Unemployed","Unemployed"],["Prefer Not To Answer","Prefer Not To Answer"]]
  end

  def shirt_size_options
    [["Please select ...",nil],["M-small","M-small"],["M-medium","M-medium"],["M-large","M-large"],["M-x-large","M-x-large"],["W-small","W-small"],["W-medium","W-medium"],["W-large","W-large"],["W-x-large","W-x-large"]]
  end

  def age_range_options
    [["Please select ...",nil],["14-20","14-20"],["21-30","21-30"],["31-40","31-40"],["41-60","41-60"],["60+","60+"],["Prefer not answer","Prefer not answer"]]
  end

  def gender_options
    [["Please select ...",nil],["Male","Male"],["Female","Female"]]
  end

end
