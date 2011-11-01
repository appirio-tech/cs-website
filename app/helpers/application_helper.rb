module ApplicationHelper
  
  def signed_in?
    !current_user.nil?
  end
      
  def s3_image(path, options = {})
    image_tag("http://cloudspokes.s3.amazonaws.com/#{path}", options)
  end  
  
  def category_display(categories)
    cats = ''
    categories['records'].each do |record|
      cats = cats + record['Display_Name__c'] + ", "
    end
    return cats[0..cats.length-3]
  end
  
end
