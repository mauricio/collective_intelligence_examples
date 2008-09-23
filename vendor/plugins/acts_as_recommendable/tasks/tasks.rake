namespace :recommendations  do
  
  desc %q{Load similarities for all items at the database, you can define a
               START value as the starting id of the items that will have it's similarities generated
              and a RATED_TYPE to define the class if the item that will have it's similarities generated }
  task :load_similarities_for_items => :environment do
    raise ArgumentError, 'you must define a valid value for the RATED_TYPE variable' if ENV['RATED_TYPE'].blank?
    item_id = ENV['START'] || 0
    rated_type = ENV['RATED_TYPE'].constantize
    rated_type.paginated_each( :page => 1, :per_page => 20, :conditions => [ 'id >= ?', item_id ], :order => 'id asc' ) do |first_item|
      rated_type.paginated_each( :page => 1, :per_page => 200, :conditions => [ 'id != ?', first_item.id ], :order => 'id asc' ) do |last_item|
        if !Similarity.find_similarity_for( first_item, last_item)
          similarity_value = CodeVader::RecommendationsService.compare_items( first_item , last_item, :pearson_correlation)
          Similarity.create(:first_item => first_item , :last_item => last_item , :similarity_value => similarity_value)
        end
      end
    end
  end

  desc %q{Update similarities for items already at the database.
               You must define a RATED_TYPE and DAYS_AGO value for this task.
               The RATED_TYPE defines the type of the object that is going to be
               updated and the DAYS_AGO defines the time that is going to be used as a "since"
               filter, only ratings done after the define time are going to be used}
  task :update_similarities => :environment do
    raise ArgumentError, 'you must define a valid value for the RATED_TYPE variable' if ENV['RATED_TYPE'].blank?
    rated_type = ENV['RATED_TYPE']
    since = ( ENV['DAYS_AGO'] || '1' ).to_i.days.ago
    Similarity.update_similarities_since( rated_type, since )
  end

  desc 'Execute plugin specs'
  task :specs do

    files = [ 'algorithms', 'ratings', 'recommendations_service', 'similarities' ].map do |f|
      "#{File.dirname(__FILE__)}/../specs/#{f}_spec.rb"
    end.join( ' ' )

    Kernel.system( "spec #{files}" )
  end

end