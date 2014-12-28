module ServicesHelper
  def headers_match?(new_headers, existing_headers)
    new_headers.sort == existing_headers.sort
  end
end
