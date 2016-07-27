class Search < ActiveRecord::Base
  TYPES = %w(all questions answers comments users).freeze

  def self.find(request, type)
    query = Riddle::Query.escape(request)

    if type == 'all'
      ThinkingSphinx.search query
    else
      model = type.singularize.classify.constantize
      model.search query
    end
  end
end