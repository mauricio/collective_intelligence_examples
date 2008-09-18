
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

end
