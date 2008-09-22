namespace :recommendations  do
  
  desc 'Generate similarities for items'
  task :load_similarities_for_items => :environment do

    item_id = ENV['START'] || 0
    rated_type = (ENV['RATED_TYPE'] || 'Movie').constantize
    rated_type.paginated_each( :page => 1, :per_page => 20, :conditions => [ 'id >= ?', item_id ], :order => 'id asc' ) do |first_item|
      puts "Comparing item -> #{first_item.id}"
      str = Benchmark.measure do
        rated_type.paginated_each( :page => 1, :per_page => 200, :conditions => [ 'id != ?', first_item.id ], :order => 'id asc' ) do |last_item|
          if !Similarity.find_similarity_for( first_item, last_item)
            similarity_value = CodeVader::RecommendationsService.compare_items( first_item , last_item, :pearson_correlation)
            Similarity.create(:first_item => first_item , :last_item => last_item , :similarity_value => similarity_value)
          end
        end
      end
      puts str
    end
  end

  desc 'Update similarities'
  task :update_similarities do

    rated_type = (ENV['RATED_TYPE'] || 'Movie').constantize
    since = ( ENV['DAYS_AGO'] || '1' ).to_i.days.ago

    updated_items = Rating.since( since, rated_type ).find(:all)
    user_ids = updated_items.map(&:user_id)
    user_ids.uniq!
    rated_ids = updated_items.map(&:rated_id)
    rated_ids.uniq!
    items_to_update = Rating.find_items_to_update(user_ids, rated_ids, rated_type)

    rated_ids.each do |first_item_id|
      items_to_update.each do |last_item_id|
        similarity_value = Rating.compare_items_by_ids( first_item_id, last_item_id, rated_type )
        Similarity.find_or_create_similarity_for_ids(first_item_id, last_item_id, similarity_value , rated_type)
      end
    end

  end

end