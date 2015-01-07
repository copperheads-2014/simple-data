# class MetadataResponse
#   def initialize(meta_class, scope, options={})
#     @options = metadata_options.merge(
#       options)
#   end

#   MetadataResponse.new(Service.active)

#   protected

#   def default_options
#     @options = {except: "_id"}
#   end

#   def json_options
#     default_options
#     if params[:only]
#       @options[:only] = params[:only].split(",")
#     end
#     @options
#   end

#   def metadata_options
#     {
#       :start => first_record,
#       :end => last_record,
#       :total => @records.length,
#       :num_pages => num_pages,
#       :page => @options[:page],
#       :per_page => @options[:per_page],
#       :uri => uri,
#       :links => {
#         "organization" => '/organizations/2',
#         ""
#       }
#       :first_page_uri => first_page_uri,
#       :last_page_uri => "/services/#{@service.slug}/records?page=0&page_size=50",
#       :previous_page_uri => previous_page_uri,
#       :next_page_uri => next_page_uri
#     }
#   end

#   def num_pages
#     @version.total_records / @options[:page_size] + 1
#   end

#   def last_record
#     [@options[:page_size], @records.count].min
#   end

#   def first_record
#     @options[:page] * @options[:per_page]
#   end

#   def uri
#     "/#{scope.class.to_s.downcase.pluralize}/#{@service.slug}/records"
#   end

#   def first_page_uri
#     "/#{scope.class.to_s.downcase.pluralize}/#{@service.slug}/records?page=0&page_size=#{@options[:page_size]}"
#   end

#   def last_page_uri
#     "/#{scope.class.to_s.downcase.pluralize}/#{@service.slug}/records?page=#{num_pages-1}&page_size=50"
#   end

#   def previous_page_uri
#     "/#{scope.class.to_s.downcase.pluralize}/#{@service.slug}/records?page=#{previous_page}&page_size=50" if previous_page
#   end

#   def next_page_uri
#     "/#{scope.class.to_s.downcase.pluralize}/#{@service.slug}/records?page=#{next_page}&page_size=50" if next_page
#   end

#   def previous_page
#     if page == 0
#       nil
#     else
#       page-1
#     end
#   end

#   def next_page
#     if page == num_pages-1
#       nil
#     else
#       [page+1]
#     end
#   end
# end
