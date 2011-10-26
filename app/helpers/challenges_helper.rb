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
            display = "due in " + (secs/86400).floor.to_s + " days(s)"
        else
            display = "due in " + (secs/3600).floor.to_s + " hour(s) " + (secs/60).round.to_s + " minute(s)"
        end
    end

  end
  
end
