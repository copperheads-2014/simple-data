class RecordQueryService
  attr_reader :options, :version

  def initialize(version, options={})
    @options = options
    @version = version
  end

  def fetch_records
    scope = version.records
    scope = with_filters(scope)
    scope = with_offset(scope)
    scope = with_limit(scope)
    scope = with_sort(scope)
  end

  protected

  def with_offset(scope)
    options[:page] ? scope.skip(options[:page]) : scope
  end

  def with_filters(scope)
    if options[:filter]
      scope.where(options[:filter])
    else
      scope
    end
  end

  def with_limit(scope)
    options[:page_size] ? scope.limit(options[:page_size]) : scope
  end

  def with_sort(scope)
    if options[:sortby] || options[:order]
      scope.order_by("#{options[:sortby]} #{options[:order]}")
    else
      scope
    end
  end

end
