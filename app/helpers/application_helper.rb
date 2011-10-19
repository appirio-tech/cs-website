module ApplicationHelper
      
  def s3_image(path, options = {})
    image_tag("http://cloudspokes.s3.amazonaws.com/#{path}", options)
  end  
  
end
