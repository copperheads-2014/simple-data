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
end
