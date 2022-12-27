module ModelHelper
  def file_urls
    files.collect { |file| Rails.application.routes.url_helpers.rails_blob_url(file, host: ENV['HOST']) }
  end

  def rate
    votes.liked.count - votes.disliked.count
  end
end
