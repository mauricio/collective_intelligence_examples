class RatingsController < ApplicationController

  def compare_user
    @algorithm = params[:algorithm] || :default
    @users = User.find( params[:users].split(',') )
    @result = CodeVader::RecommendationsService.compare_users( @users.first, @users.last, @algorithm )
    render :action => 'compare'
  end

  def compare_item
    @algorithm = params[:algorithm] || :default
    @movies = Movie.find( params[:movies].split(',') )
    @result = CodeVader::RecommendationsService.compare_items( @movies.first, @movies.last, @algorithm )
    render :action => 'compare_movies'
  end  

  # GET /ratings
  # GET /ratings.xml
  def index
    @ratings = paginate_model( Rating, :include => [ :user, :rated ] )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ratings }
    end
  end

  # GET /ratings/1
  # GET /ratings/1.xml
  def show
    @rating = Rating.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rating }
    end
  end

  # GET /ratings/new
  # GET /ratings/new.xml
  def new
    @rating = Rating.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rating }
    end
  end

  # GET /ratings/1/edit
  def edit
    @rating = Rating.find(params[:id])
  end

  # POST /ratingsmovielens database
  # POST /ratings.xml
  def create
    @rating = Rating.new(params[:rating])

    respond_to do |format|
      if @rating.save
        flash[:notice] = 'Rating was successfully created.'
        format.html { redirect_to(ratings_path) }
        format.xml  { render :xml => @rating, :status => :created, :location => @rating }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rating.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ratings/1
  # PUT /ratings/1.xml
  def update
    @rating = Rating.find(params[:id])

    respond_to do |format|
      if @rating.update_attributes(params[:rating])
        flash[:notice] = 'Rating was successfully updated.'
        format.html { redirect_to(ratings_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rating.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ratings/1
  # DELETE /ratings/1.xml
  def destroy
    @rating = Rating.find(params[:id])
    @rating.destroy

    respond_to do |format|
      format.html { redirect_to(ratings_url) }
      format.xml  { head :ok }
    end
  end
end
