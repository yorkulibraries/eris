class ServicesController < ApplicationController

  def sort_feeds
    service_id = params[:id]
    params[:feed].each_with_index do |id, index|
      ServiceFeedBridge.update_all({position: index+1}, {feed_id: id, service_id: service_id})
    end
    render nothing: true
  end

  def preview

    @service = Service.find(params[:id])
    render :layout => "simple"
  end

  def fetch

    @service = Service.find_by_service_slug(params[:slug])

    # make sure that non-nil services are ignored
    @service = Service.new unless @service


    @query_string = request.query_string

    if @service.transform_course_code

      if params[:courses].blank?
        request.parameters.merge!( { courses: "XXXX_XX_XXXX_X_XXXX__X_X_XX_X_XXXX_XX"})
        @query_string.sub!("courses=", "course=#{params[:courses]}")
      end

      if params[:courses]
        course_tags = Service.parse_course_codes(params[:courses].split(",")).join(",")
      else
        course_tags = ""
      end

      @query_string = @query_string + (@query_string.size > 1 ? "&" : "") + "tag=#{course_tags},#{params[:courses]}&program_codes=#{course_tags}"
    end


    @feeds = @service.fetch_feeds(@query_string)

    if @service.live?  || params[:preview]
      respond_to do |format|
          format.html { render :layout => "simple"}
          format.xml
          format.rss
          format.js
          format.json
      end
    else
      render :nothing => true
    end
  end

  def index
    @services = Service.all
  end

  def show
    @service = Service.find(params[:id])
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(params[:service])
    if @service.save
      redirect_to @service, :notice => "Successfully created service."
    else
      render :action => 'new'
    end
  end

  def edit
    @service = Service.find(params[:id])
  end

  def update
    @service = Service.find(params[:id])
    
    if @service.update_attributes(params[:service])
      redirect_to @service, :notice  => "Successfully updated service."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @service = Service.find(params[:id])
    if @service.live?
      redirect_to service_path(@service), :alert => "The service must be take off line, before you can delete it."
    else
      @service.destroy
      redirect_to services_url, :notice => "Successfully destroyed service."
    end
  end
end
