module UrlHelper
  def add_scheme(url)
    return nil if url.nil?
    "http://#{url.sub(/^http:\/\//, '')}"
  end
end
