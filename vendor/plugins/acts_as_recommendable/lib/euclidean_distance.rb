CodeVader::RecommendationsService.register :euclidean_distance do |first_user_ratings, last_user_ratings|
    sum_of_squares = 0
    0.upto( first_user_ratings.size - 1 ) do |index|
      sum_of_squares += (first_user_ratings[index].score - last_user_ratings[index].score) ** 2
    end
    1.0/( 1 + sum_of_squares )
end