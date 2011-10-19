class ContentController < ApplicationController
  def show
    if File.exist?(Rails.root.to_s + "/app/views/content/#{params[:id]}.html.erb")
      render template: "content/#{params[:id]}"
    else
      render file: Rails.root + '/public/404.html', status: 404
    end
  end
end
