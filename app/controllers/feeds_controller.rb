class FeedsController < ApplicationController
  def index
    @feeds = Feed.all
  end

  def show
    @feed = Feed.find(params[:id])
  end

  def new
    @feed = Feed.new
  end

  def create
    @feed = Feed.new(params[:feed])
    if @feed.save
      redirect_to feeds_path, :notice => "Successfully created feed."
    else
      render :action => 'new'
    end
  end

  def edit
    @feed = Feed.find(params[:id])
  end

  def update
    @feed = Feed.find(params[:id])
    if @feed.update_attributes(params[:feed])
      redirect_to feeds_path, :notice  => "Successfully updated feed."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy
    redirect_to feeds_url, :notice => "Successfully destroyed feed."
  end
end
