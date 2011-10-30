module ChallengesHelper
  
  def category_display(categories)
    cats = ''
    categories['records'].each do |record|
      cats = cats + record['Display_Name__c'] + ", "
    end
    return cats[0..cats.length-3]
  end
  
  def format_close_date(end_date)
    
    end_time = Time.parse(end_date)
    if end_time.past?
        display = "closed"
    else
        secs = Time.parse(end_date) - Time.now
        if (secs > 86400)
            display = "due in " + pluralize((secs/86400).floor, 'day')
        else
            display = "due in " + pluralize((secs/3600).floor, 'hour') + "  " + pluralize((secs/60).round, 'minute')
        end
    end

  end
  
  def format_close_date_time(end_date)
    
    end_time = Time.parse(end_date)
    if end_time.past?
        display = "Completed"
    else
      secs = Time.parse(end_date) - Time.now
      display = "due in "
      display += pluralize((secs/86400).floor, 'day')
      secs = secs%86400
      display += " " + pluralize((secs/3600).floor, 'hour') + " " + pluralize(((secs%3600)/60).round, 'minute')
    end

  end
  
end






