class RedirectorController < ApplicationController
  def index
    url = params[:url]
    if url
      redirect_to URI.decode(url)
    else
      root_path
    end

  end
end
