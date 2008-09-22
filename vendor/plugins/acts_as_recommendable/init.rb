[ 'acts_as_recommendable', 'rating', 'similarity', 'euclidean_distance', 'pearson_correlation'].each do |i|
  require "#{File.dirname(__FILE__)}/lib/#{i}"
end