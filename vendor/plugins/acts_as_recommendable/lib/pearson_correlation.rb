CodeVader::RecommendationsService.register :pearson_correlation, true do |first_user_ratings, last_user_ratings|

  size = first_user_ratings.size

  #ratings sum
  sum_first = first_user_ratings.sum(&:score)
  sum_last = last_user_ratings.sum(&:score)

  # squared ratings sum
  sum_first_squares = first_user_ratings.sum { |i| i.score ** 2 }
  sum_last_squares = last_user_ratings.sum { |i| i.score ** 2 }

  sum_products = 0

  #products sum
  0.upto( size -1 ) do |index|
    sum_products += first_user_ratings[index].score * last_user_ratings[index].score
  end

  numerator = sum_products - ( sum_first * sum_last / size )
  denominator = Math.sqrt( ( sum_first_squares - ( sum_first ** 2 )/ size ) * ( sum_last_squares - ( sum_last ** 2 )/ size ) )
  if denominator == 0
    0
  else
    numerator/denominator
  end
end