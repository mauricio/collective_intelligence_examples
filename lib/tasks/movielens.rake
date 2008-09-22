
namespace :dataset do

  desc "Decompresses the movie lens database"
  task :untar_database => :environment do
    Kernel.system( "cd #{RAILS_ROOT}/data; tar -xzf data.tar.gz" )
  end

  desc 'Load users from the movie lens database'
  task  :load_users => :environment do

    User.delete_all

    FasterCSV.foreach( "#{RAILS_ROOT}/data/u.user", :col_sep => '|' ) do |row|
      name = "#{row[0]} - #{row[1]} -  #{row[2]} - #{row[3]}"
      ActiveRecord::Base.connection.insert( "INSERT INTO users ( id, name ) values ( #{row[0]}, '#{name}' ) " )
    end

    User.update_all( :created_at => Time.now, :updated_at => Time.now )

  end

  desc 'Load movies from the movielens dataset'
  task :load_movies => :environment do

    Movie.delete_all

    FasterCSV.foreach( "#{RAILS_ROOT}/data/u.item", :col_sep => '|' ) do |row|
      name = "#{row[0]} - #{row[1]} -  #{row[2]} - #{row[3]}"
      ActiveRecord::Base.connection.insert( "INSERT INTO movies ( id, title ) values ( #{row[0]}, \"#{row[1]}\" ) " )
    end    

    Movie.update_all( :created_at => Time.now, :updated_at => Time.now )
    
  end

  desc 'Load ratings from the movie lens dataset'
  task :load_ratings => :environment do
    Rating.delete_all

    FasterCSV.foreach( "#{RAILS_ROOT}/data/u.data", :col_sep => ' ' ) do |row|
      row = row[0].split( ' ' ).map { |i| i.strip }
      ActiveRecord::Base.connection.insert( "INSERT INTO ratings (  user_id, rated_id, score, rated_type ) values ( #{row[0]}, #{row[1]}, #{row[2]}, 'Movie' ) " )
    end    

    Rating.update_all( :created_at => Time.now, :updated_at => Time.now )
    
  end

  desc 'Load the whole movielens dataset'
  task :load_database => [:untar_database, :load_users, :load_movies, :load_ratings]

  desc 'Calculate similarities for all using skynet'
  task :load_similarities_for_movies_with_skynet => :environment do

    movie_id = ENV['START'] || 0
    end_movie_id = ENV['end'] || 2000
    puts "Starting with -> #{movie_id}"

    Movie.paginated_each( :page => 1, :per_page => 20, :conditions => [ 'id >= ? and id <= ?', movie_id, end_movie_id ], :order => 'id asc' ) do |m|
      puts "Comparing movie -> #{m.id}"
      Movie.paginated_each( :page => 1, :per_page => 200, :conditions => [ 'id != ?', m.id ], :order => 'id asc' ) do |movie|
        if !Similarity.find_similarity_for(m, movie)
          puts "Comparing movie -> #{m.id} - #{movie.id}"
          m.send_later( :create_similarity, movie )
        end
      end
    end
  end


end
