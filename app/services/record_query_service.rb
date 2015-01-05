class RecordQueryService
  attr_reader :service, :options

  def initialize(service, options={})
    @service = service
    @options = options
  end

  def fetch_records
    scope = service.records
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
      # Ex. zip=63630$district=17$city=Chicago => [[:zip, 63630], [:district, 17], [:city, "Chicago"]]
      scope.where(Hash[format_pairs])
    else
      scope
    end
  end

  def with_limit(scope)
    options[:limit] ? scope.limit(options[:limit]) : scope
  end

  def with_sort(scope)
    if options[:sortby] && options[:order]
      scope.order_by(options[:sortby] + " " + options[:order])
    else
      scope
    end
  end

  def format_pairs
    filters = options[:filter].split("$").map do |filter|
      filter_pair = filter.split("=")
      key, value = filter_pair[0], filter_pair[1]
      #make the first element a symbol
      filter_pair[0] = key.to_sym
      #make the second element an integer if necessary
      filter_pair[1] = value.to_i if value == value.to_i.to_s
      filter_pair
    end
  end

end
