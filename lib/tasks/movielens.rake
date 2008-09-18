
namespace :dataset do

  desc "Decompresses the movie lens database"
  task :untar_database do
    Kernel.system( "cd #{RAILS_ROOT}/data; tar -xzf data.tar.gz" )
  end

end
