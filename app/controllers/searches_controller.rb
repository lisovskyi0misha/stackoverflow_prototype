class SearchesController < ApplicationController
  def show
    @results = Search::FindAndReturn.new(params).call
  end
end
