class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if @movies
    else
      @movies = Movie.all
    end
    if params[:ratings]
      logger.info "#{params[:ratings].inspect}"
      @ratings = params[:ratings]
      @movies = Movie.filter_by_ratings(@ratings)
    else
      @ratings = {}
    end
    sort = params[:sort]
    if sort  == 'title'
      @movies = @movies.sort {|a,b| a.title.downcase <=> b.title.downcase}
      @sort = 'title'
    elsif sort == 'release'
      @movies = @movies.sort {|a,b| a.release_date <=> b.release_date}
      @sort = sort
    end
    @all_ratings = Movie.all_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
