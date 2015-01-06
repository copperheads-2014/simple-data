class RecordQueryService
  attr_reader :service, :options

  def initialize(service, options={})
    @service = service
    @options = options
  end

  def fetch_records
    scope = service.latest_version.records
    scope = with_filters(scope)
    scope = with_offset(scope)
    scope = with_limit(scope)
    scope = with_sort(scope)
  end

  protected

  def with_offset(scope)
    options[:offset] ? scope.skip(options[:offset]) : scope
  end

  def with_filters(scope)
    if options[:filter]
      format_pairs
      scope.where(options[:filter])
    else
      scope
    end
  end

  def with_limit(scope)
    options[:limit] ? scope.limit(options[:limit]) : scope
  end

  def with_sort(scope)
    if options[:sortby] || options[:order]
      scope.order_by("#{options[:sortby]} #{options[:order]}")
    else
      scope
    end
  end

  def format_pairs
    # Make the value of a field an integer if it matches that format
    # Ex. "filter"=>{"zip"=>"60630", "city"=>"Chicago"},
    # becomes
    # "filter"=>{"zip"=> 60630, "city"=>"Chicago"}
    options[:filter].keys.each do |key|
      value = options[:filter][key]
      options[:filter][key] = value.to_i if value.to_i.to_s == value
    end
  end

end
