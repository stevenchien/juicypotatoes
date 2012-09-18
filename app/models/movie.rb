class Movie < ActiveRecord::Base
  def self.all_ratings
    return ['G', 'PG', 'PG-13', 'R']
  end

  def self.filter_by_ratings(ratings)
    self.select{|l| ratings.include?(l.rating)}
  end
end
