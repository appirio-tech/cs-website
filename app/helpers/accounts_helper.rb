module AccountsHelper

  MENU_OPTIONS_ACCOUNT = { :account_details      => {:value => "account details",     :link => "/account/details"},
                       :payments             => {:value => "payment info",        :link => "/account/payments"},
                       :school_work_info     => {:value => "school & work info",  :link => "/account/school"},
                       :edit_public_profile  => {:value => "edit public profile", :link => "/account/public_profile"},
                       :change_password      => {:value => "change password",     :link => "/account/password"}}
                       
  MENU_OPTIONS_MY = { :my_challenges        => {:value => "my challenges",       :link => "/account/challenges"} }                       

  MENU_OPTIONS_REVIEW = { :outstanding_reviews  => {:value => "outstanding reviews", :link => "/account/outstanding_reviews"} }
  
  MENU_OPTIONS_QUICKQUIZ = { :submit_question => {:value => "submit a question",       :link => "/quiz_questions/new"},
                          :review_questions  => {:value => "review questions", :link => "/quiz_questions"}}

  def build_menu(position,selected_item)
    content = ""
    eval("MENU_OPTIONS_#{position.upcase}").each do |item,options|
      content  += "<li>"
      if item.to_s == selected_item
        content += "<a href='#{options[:link]}' class='active'>#{options[:value]}</a>"
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
  
  def preferred_payment_options
    [["Please select ...",nil],["Check","Check"],["Paypal","Paypal"],["Wire","Wire"]]
  end

  def timezone_options
    [
      ["(GMT+14:00) Line Islands Time (Pacific/Kiritimati)","(GMT+14:00) Line Islands Time (Pacific/Kiritimati)"],
      ["(GMT+13:00) Phoenix Islands Time (Pacific/Enderbury)","(GMT+13:00) Phoenix Islands Time (Pacific/Enderbury)"],
      ["(GMT+13:00) Tonga Time (Pacific/Tongatapu)","(GMT+13:00) Tonga Time (Pacific/Tongatapu)"],
      ["(GMT+12:45) Chatham Standard Time (Pacific/Chatham)","(GMT+12:45) Chatham Standard Time (Pacific/Chatham)"],
      ["(GMT+12:00) Magadan Time (Asia/Kamchatka)","(GMT+12:00) Magadan Time (Asia/Kamchatka)"],
      ["(GMT+12:00) New Zealand Standard Time (Pacific/Auckland)","(GMT+12:00) New Zealand Standard Time (Pacific/Auckland)"],
      ["(GMT+12:00) Fiji Time (Pacific/Fiji)","(GMT+12:00) Fiji Time (Pacific/Fiji)"],
      ["(GMT+11:30) Norfolk Islands Time (Pacific/Norfolk)","(GMT+11:30) Norfolk Islands Time (Pacific/Norfolk)"],
      ["(GMT+11:00) Solomon Islands Time (Pacific/Guadalcanal)","(GMT+11:00) Solomon Islands Time (Pacific/Guadalcanal)"],
      ["(GMT+10:30) Lord Howe Standard Time (Australia/Lord_Howe)","(GMT+10:30) Lord Howe Standard Time (Australia/Lord_Howe)"],
      ["(GMT+10:00) Australian Eastern Standard Time (Australia/Brisbane)","(GMT+10:00) Australian Eastern Standard Time (Australia/Brisbane)"],
      ["(GMT+10:00) Australian Eastern Standard Time (Australia/Sydney)","(GMT+10:00) Australian Eastern Standard Time (Australia/Sydney)"],
      ["(GMT+09:30) Australian Central Standard Time (Australia/Adelaide)","(GMT+09:30) Australian Central Standard Time (Australia/Adelaide)"],
      ["(GMT+09:30) Australian Central Standard Time (Australia/Darwin)","(GMT+09:30) Australian Central Standard Time (Australia/Darwin)"],
      ["(GMT+09:00) Korean Standard Time (Asia/Seoul)","(GMT+09:00) Korean Standard Time (Asia/Seoul)"],
      ["(GMT+09:00) Japan Standard Time (Asia/Tokyo)","(GMT+09:00) Japan Standard Time (Asia/Tokyo)"],
      ["(GMT+08:00) Hong Kong Time (Asia/Hong_Kong)","(GMT+08:00) Hong Kong Time (Asia/Hong_Kong)"],
      ["(GMT+08:00) Malaysia Time (Asia/Kuala_Lumpur)","(GMT+08:00) Malaysia Time (Asia/Kuala_Lumpur)"],
      ["(GMT+08:00) Philippine Time (Asia/Manila)","(GMT+08:00) Philippine Time (Asia/Manila)"],
      ["(GMT+08:00) China Standard Time (Asia/Shanghai)","(GMT+08:00) China Standard Time (Asia/Shanghai)"],
      ["(GMT+08:00) Singapore Standard Time (Asia/Singapore)","(GMT+08:00) Singapore Standard Time (Asia/Singapore)"],
      ["(GMT+08:00) Taipei Standard Time (Asia/Taipei)","(GMT+08:00) Taipei Standard Time (Asia/Taipei)"],
      ["(GMT+08:00) Australian Western Standard Time (Australia/Perth)","(GMT+08:00) Australian Western Standard Time (Australia/Perth)"],
      ["(GMT+07:00) Indochina Time (Asia/Bangkok)","(GMT+07:00) Indochina Time (Asia/Bangkok)"],
      ["(GMT+07:00) Western Indonesia Time (Asia/Jakarta)","(GMT+07:00) Western Indonesia Time (Asia/Jakarta)"],
      ["(GMT+07:00) Indochina Time (Asia/Saigon)","(GMT+07:00) Indochina Time (Asia/Saigon)"],
      ["(GMT+06:30) Myanmar Time (Asia/Rangoon)","(GMT+06:30) Myanmar Time (Asia/Rangoon)"],
      ["(GMT+06:00) Bangladesh Time (Asia/Dacca)","(GMT+06:00) Bangladesh Time (Asia/Dacca)"],
      ["(GMT+06:00) Yekaterinburg Time (Asia/Yekaterinburg)","(GMT+06:00) Yekaterinburg Time (Asia/Yekaterinburg)"],
      ["(GMT+05:45) Nepal Time (Asia/Katmandu)","(GMT+05:45) Nepal Time (Asia/Katmandu)"],
      ["(GMT+05:30) India Standard Time (Asia/Calcutta)","(GMT+05:30) India Standard Time (Asia/Calcutta)"],
      ["(GMT+05:30) India Standard Time (Asia/Colombo)","(GMT+05:30) India Standard Time (Asia/Colombo)"],
      ["(GMT+05:00) Pakistan Time (Asia/Karachi)","(GMT+05:00) Pakistan Time (Asia/Karachi)"],
      ["(GMT+05:00) Uzbekistan Time (Asia/Tashkent)","(GMT+05:00) Uzbekistan Time (Asia/Tashkent)"],
      ["(GMT+04:30) Afghanistan Time (Asia/Kabul)","(GMT+04:30) Afghanistan Time (Asia/Kabul)"],
      ["(GMT+04:30) Iran Daylight Time (Asia/Tehran)","(GMT+04:30) Iran Daylight Time (Asia/Tehran)"],
      ["(GMT+04:00) Gulf Standard Time (Asia/Dubai)","(GMT+04:00) Gulf Standard Time (Asia/Dubai)"],
      ["(GMT+04:00) Georgia Time (Asia/Tbilisi)","(GMT+04:00) Georgia Time (Asia/Tbilisi)"],
      ["(GMT+04:00) Moscow Standard Time (Europe/Moscow)","(GMT+04:00) Moscow Standard Time (Europe/Moscow)"],
      ["(GMT+03:00) East Africa Time (Africa/Nairobi)","(GMT+03:00) East Africa Time (Africa/Nairobi)"],
      ["(GMT+03:00) Arabian Standard Time (Asia/Baghdad)","(GMT+03:00) Arabian Standard Time (Asia/Baghdad)"],
      ["(GMT+03:00) Israel Daylight Time (Asia/Jerusalem)","(GMT+03:00) Israel Daylight Time (Asia/Jerusalem)"],
      ["(GMT+03:00) Arabian Standard Time (Asia/Kuwait)","(GMT+03:00) Arabian Standard Time (Asia/Kuwait)"],
      ["(GMT+03:00) Arabian Standard Time (Asia/Riyadh)","(GMT+03:00) Arabian Standard Time (Asia/Riyadh)"],
      ["(GMT+03:00) Eastern European Summer Time (Europe/Athens)","(GMT+03:00) Eastern European Summer Time (Europe/Athens)"],
      ["(GMT+03:00) Eastern European Summer Time (Europe/Bucharest)","(GMT+03:00) Eastern European Summer Time (Europe/Bucharest)"],
      ["(GMT+03:00) Eastern European Summer Time (Europe/Helsinki)","(GMT+03:00) Eastern European Summer Time (Europe/Helsinki)"],
      ["(GMT+03:00) Eastern European Summer Time (Europe/Istanbul)","(GMT+03:00) Eastern European Summer Time (Europe/Istanbul)"],
      ["(GMT+03:00) Eastern European Time (Europe/Minsk)","(GMT+03:00) Eastern European Time (Europe/Minsk)"],
      ["(GMT+02:00) Eastern European Time (Africa/Cairo)","(GMT+02:00) Eastern European Time (Africa/Cairo)"],
      ["(GMT+02:00) South Africa Standard Time (Africa/Johannesburg)","(GMT+02:00) South Africa Standard Time (Africa/Johannesburg)"],
      ["(GMT+02:00) Central European Summer Time (Europe/Amsterdam)","(GMT+02:00) Central European Summer Time (Europe/Amsterdam)"],
      ["(GMT+02:00) Central European Summer Time (Europe/Berlin)","(GMT+02:00) Central European Summer Time (Europe/Berlin)"],
      ["(GMT+02:00) Central European Summer Time (Europe/Brussels)","(GMT+02:00) Central European Summer Time (Europe/Brussels)"],
      ["(GMT+02:00) Central European Summer Time (Europe/Paris)","(GMT+02:00) Central European Summer Time (Europe/Paris)"],
      ["(GMT+02:00) Central European Summer Time (Europe/Prague)","(GMT+02:00) Central European Summer Time (Europe/Prague)"],
      ["(GMT+02:00) Central European Summer Time (Europe/Rome)","(GMT+02:00) Central European Summer Time (Europe/Rome)"],
      ["(GMT+01:00) Central European Time (Africa/Algiers)","(GMT+01:00) Central European Time (Africa/Algiers)"],
      ["(GMT+01:00) Irish Summer Time (Europe/Dublin)","(GMT+01:00) Irish Summer Time (Europe/Dublin)"],
      ["(GMT+01:00) Western European Summer Time (Europe/Lisbon)","(GMT+01:00) Western European Summer Time (Europe/Lisbon)"],
      ["(GMT+01:00) British Summer Time (Europe/London)","(GMT+01:00) British Summer Time (Europe/London)"],
      ["(GMT+00:00) Greenwich Mean Time (GMT)","(GMT+00:00) Greenwich Mean Time (GMT)"],
      ["(GMT-01:00) Cape Verde Time (Atlantic/Cape_Verde)","(GMT-01:00) Cape Verde Time (Atlantic/Cape_Verde)"],
      ["(GMT-02:00) South Georgia Time (Atlantic/South_Georgia)","(GMT-02:00) South Georgia Time (Atlantic/South_Georgia)"],
      ["(GMT-02:30) Newfoundland Daylight Time (America/St_Johns)","(GMT-02:30) Newfoundland Daylight Time (America/St_Johns)"],
      ["(GMT-03:00) Argentina Time (America/Buenos_Aires)","(GMT-03:00) Argentina Time (America/Buenos_Aires)"],
      ["(GMT-03:00) Atlantic Daylight Time (America/Halifax)","(GMT-03:00) Atlantic Daylight Time (America/Halifax)"],
      ["(GMT-03:00) Brasilia Time (America/Sao_Paulo)","(GMT-03:00) Brasilia Time (America/Sao_Paulo)"],
      ["(GMT-03:00) Atlantic Daylight Time (Atlantic/Bermuda)","(GMT-03:00) Atlantic Daylight Time (Atlantic/Bermuda)"],
      ["(GMT-04:00) Eastern Daylight Time (America/Indianapolis)","(GMT-04:00) Eastern Daylight Time (America/Indianapolis)"],
      ["(GMT-04:00) Eastern Daylight Time (America/New_York)","(GMT-04:00) Eastern Daylight Time (America/New_York)"],
      ["(GMT-04:00) Atlantic Standard Time (America/Puerto_Rico)","(GMT-04:00) Atlantic Standard Time (America/Puerto_Rico)"],
      ["(GMT-04:00) Chile Time (America/Santiago)","(GMT-04:00) Chile Time (America/Santiago)"],
      ["(GMT-04:30) Venezuela Time (America/Caracas)","(GMT-04:30) Venezuela Time (America/Caracas)"],
      ["(GMT-05:00) Colombia Time (America/Bogota)","(GMT-05:00) Colombia Time (America/Bogota)"],
      ["(GMT-05:00) Central Daylight Time (America/Chicago)","(GMT-05:00) Central Daylight Time (America/Chicago)"],
      ["(GMT-05:00) Peru Time (America/Lima)","(GMT-05:00) Peru Time (America/Lima)"],
      ["(GMT-05:00) Central Daylight Time (America/Mexico_City)","(GMT-05:00) Central Daylight Time (America/Mexico_City)"],
      ["(GMT-05:00) Eastern Standard Time (America/Panama)","(GMT-05:00) Eastern Standard Time (America/Panama)"],
      ["(GMT-06:00) Mountain Daylight Time (America/Denver)","(GMT-06:00) Mountain Daylight Time (America/Denver)"],
      ["(GMT-06:00) Central Standard Time (America/El_Salvador)","(GMT-06:00) Central Standard Time (America/El_Salvador)"],
      ["(GMT-07:00) Pacific Daylight Time (America/Los_Angeles)","(GMT-07:00) Pacific Daylight Time (America/Los_Angeles)"],
      ["(GMT-07:00) Mountain Standard Time (America/Phoenix)","(GMT-07:00) Mountain Standard Time (America/Phoenix)"],
      ["(GMT-07:00) Pacific Daylight Time (America/Tijuana)","(GMT-07:00) Pacific Daylight Time (America/Tijuana)"],
      ["(GMT-08:00) Alaska Daylight Time (America/Anchorage)","(GMT-08:00) Alaska Daylight Time (America/Anchorage)"],
      ["(GMT-10:00) Hawaii-Aleutian Standard Time (Pacific/Honolulu)","(GMT-10:00) Hawaii-Aleutian Standard Time (Pacific/Honolulu)"],
      ["(GMT-11:00) Niue Time (Pacific/Niue)","(GMT-11:00) Niue Time (Pacific/Niue)"],
      ["(GMT-11:00) Samoa Standard Time (Pacific/Pago_Pago)","(GMT-11:00) Samoa Standard Time (Pacific/Pago_Pago)"]
    ]
  end

end
