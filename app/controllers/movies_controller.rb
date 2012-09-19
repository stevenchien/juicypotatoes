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
      @ratings = params[:ratings]
      @movies = Movie.filter_by_ratings(@ratings)
    elsif session[:ratings]
      if session[:sort]
        redirect_to movies_path(:ratings => session[:ratings], :sort => session[:sort]) and return
      else
        redirect_to movies_path(:ratings => session[:ratings]) and return
      end
    else
      @movies = []
      @ratings = {}
    end
    if params[:sort]
      if params[:sort]  == 'title'
        @movies = @movies.sort {|a,b| a.title.downcase <=> b.title.downcase}
        @sort = 'title'
      elsif params[:sort] == 'release'
        @movies = @movies.sort {|a,b| a.release_date <=> b.release_date}
        @sort = 'release'
      end
    elsif session[:sort]
      redirect_to movies_path(:sort => session[:sort]) and return
    end
    @all_ratings = Movie.all_ratings
    session[:ratings] = @ratings
    logger.info "ratings: #{session[:ratings].inspect}"
    session[:sort] = @sort
    logger.info "sort: #{session[:sort].inspect}"
    logger.info "session: #{session.inspect}"
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
