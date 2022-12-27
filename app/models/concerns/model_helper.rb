module ModelHelper
  def file_urls
    files.collect { |file| Rails.application.routes.url_helpers.rails_blob_url(file, host: 'localhost:3000') }
  end

  def rate
    votes.liked.count - votes.disliked.count
  end
end
