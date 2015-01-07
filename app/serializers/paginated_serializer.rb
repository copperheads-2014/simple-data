class PaginatedSerializer < ActiveModel::ArraySerializer
  include Rails.application.routes.url_helpers

  def initialize(object, options={})
    meta_key = options[:meta_key] || :meta
    options[meta_key] ||= {}
    options[meta_key][:pagination] = {
      current_page: object.current_page,
      per_page: object.per_page,
      total_pages: object.total_pages,
      total_count: object.total_entries,
      links: pagination_links(object)
    }
    super(object, options)
  end

  def pagination_links(object)
    {
      prev_page: object.previous_page && polymorphic_path(object.name.constantize, {per_page: object.per_page, page: object.previous_page || 1}),
      current_page: polymorphic_path(object.name.constantize, {per_page: object.per_page, page: object.current_page}),
      next_page: object.next_page && polymorphic_path(object.name.constantize, {per_page: object.per_page, page: object.next_page || object.total_pages}),
    }
  end
end
