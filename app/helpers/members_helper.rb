module MembersHelper
  
  def member_category_display(categories)
    cats = ''
    categories["records"].each do |record|
      cats = cats + record["Category__r"]["Name"] + ", "
    end
    return cats[0..cats.length-3]
  end
  
  def member_challenge_place(place)
    display = ''
    if place.nil?
      display =  ''
    else
      display =  place.to_i.ordinalize
    end
    return display
  end
  
end