class TaggedUrlsController < ApplicationController
  
  def index 

    if params[:tag]
       if params[:prefix] 
          tags = Array.new
          params[:tag].split(",").each do |tag|
            tags << params[:prefix] + ":" + tag.downcase
          end
       else
          tags = params[:tag]
       end
     
      @tagged_urls = TaggedUrl.where("tag in (?) ", tags)
    
      
    elsif params[:source]
      @paginated = true
      @tagged_urls = TaggedUrl.where("source = ? ", params[:source]).page(params[:page])    
      
    else
      @paginated = true
      @tagged_urls = TaggedUrl.page params[:page] 
    end
    
    respond_to do |format|
        format.html
        format.rss { render :layout => false } 
    end
  
  end
  
  def new
    @tagged_url = TaggedUrl.new
  end

  def create
    @tagged_url = TaggedUrl.new(params[:tagged_url])
    if @tagged_url.save
      redirect_to tagged_urls_url, :notice => "Successfully created tagged url."
    else
      render :action => 'new'
    end
  end

  def edit
    @tagged_url = TaggedUrl.find(params[:id])
  end

  def update
    @tagged_url = TaggedUrl.find(params[:id])
    if @tagged_url.update_attributes(params[:tagged_url])
      redirect_to tagged_urls_url, :notice  => "Successfully updated tagged url."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @tagged_url = TaggedUrl.find(params[:id])
    @tagged_url.destroy
    redirect_to tagged_urls_url, :notice => "Successfully destroyed tagged url."
  end
  
  # Get Unique Tags
  def tags
    @tagged_urls = TaggedUrl.find(:all, :group => 'tag')


    render "index"
    
  
  end
end
