class RecordsController < ApplicationController
  attr_reader :settings

  def index
    @service = Service.find_by(slug: params[:service_slug])
    v_num = params[:version][1..-1]
    @version = @service.versions.find_by(number: v_num)
    if @service.activated && @version.active
      @settings = default_params.merge(params)
      @records = RecordQueryService.new(@version, settings).fetch_records
      @formatter = DataFormatter.new(metadata_options)
      @formatter.data = @records.to_json(json_options)
      render json: @formatter.to_json(except: ["created_at","updated_at","id"]), status: 200
    else
      render json: "This service has been deactivated. Check the service's documentation for details."
    end
  end

  protected

  def default_params
    {page: 0, page_size: 50, start: 0, sortby: :insertion_id, order: :asc}.with_indifferent_access
  end

  def default_options
    @options = {except: "_id"}
  end

  def json_options
    default_options
    if params[:only]
      @options[:only] = params[:only].split(",")
    end
    @options
  end

  def metadata_options
    {
      :start => first_record,
      :end => last_record,
      :total => total_retrieved,
      :num_pages => num_pages,
      :page => page,
      :page_size => @settings[:page_size],
      :uri => uri,
      :first_page_uri => first_page_uri,
      :last_page_uri => last_page_uri,
      :previous_page_uri => previous_page_uri,
      :next_page_uri => next_page_uri
    }
  end

  def total_retrieved
    @records.count
  end

  def page
    [0, @settings[:page].to_i].max
  end

  def num_pages
    (@records.count / @settings[:page_size].to_i) + 1
  end

  def last_record
    (@settings[:page_size].to_i * page) + @settings[:page_size].to_i - 1
  end

  def first_record
    [@settings[:start], 0].max
  end

  def uri
    "/services/#{@service.slug}/v1/records"
  end

  def first_page_uri
    "/services/#{@service.slug}/v1/records?page=0&page_size=#{@settings[:page_size]}"
  end

  def last_page_uri
    "/services/#{@service.slug}/v1/records?page=#{num_pages-1}&page_size=#{@settings[:page_size]}"
  end

  def previous_page_uri
    "/services/#{@service.slug}/v1/records?page=#{previous_page}&page_size=#{@settings[:page_size]}" if previous_page
  end

  def next_page_uri
    "/services/#{@service.slug}/v1/records?page=#{next_page}&page_size=#{@settings[:page_size]}" if next_page
  end

  def previous_page
    if page <= 0
      nil
    else
      page-1
    end
  end

  def next_page
    if page >= num_pages - 1
      nil
    else
      page+1
    end
  end
end
