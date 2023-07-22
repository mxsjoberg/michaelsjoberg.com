class PagesController < ApplicationController
  before_action :set_meta
  $author = "Michael Sjöberg"
  $version = "5.0.0"
  $updated = "July 11, 2023"
  # ----------------------------------------------
  # GET /
  # GET /about
  # ----------------------------------------------
  def about
    @route_path = "about"
    @meta_title = $author
    @images = []
    Dir.glob(Rails.public_path + 'images/attefall/*.jpg') do |filename|
      @file = filename.split('/').last
      @images.push(@file)
    end
  end
  # ----------------------------------------------
  # GET /about/courses
  # ----------------------------------------------
  def courses
    @route_path = "courses"
    @meta_title = "Courses | " + $author
    # courses
    @courses = JSON.parse(File.read(Rails.public_path + 'courses.json'))
  end
  # ----------------------------------------------
  # GET /about/stack
  # ----------------------------------------------
  def stack
    @route_path = "stack"
    @meta_title = "Stack | " + $author
    # stack
    @stack = JSON.parse(File.read(Rails.public_path + 'stack.json'))
  end
  # ----------------------------------------------
  # GET /programming
  # ----------------------------------------------
  def programming
    @route_path = "programming"
    @meta_title = "Programming | " + $author
    # params
    @category = params[:category]
    @group = params[:group]
    @file = params[:file]
    # programming.json
    @programming = JSON.parse(File.read(Rails.public_path + 'programming.json'))
    unless (@file.nil?)
      @meta_title = @file.titleize + " in " + @category.titleize
      # define file properties
      @path = @programming[@category][@group]["path"]
      @url = @programming[@category][@group]["url"]
      @format = @programming[@category][@group]["format"]
      # get raw file content from github
      begin
        @file_content = HTTParty.get(@path + "#{@group}/#{@file}" + @format).parsed_response
      rescue
        @file_content = nil
      end
    end
  end
  # ----------------------------------------------
  # GET /projects
  # ----------------------------------------------
  def projects
    @route_path = "projects"
    @meta_title = "Projects | " + $author
    # projects.json
    @projects = JSON.parse(File.read(Rails.public_path + 'projects.json'))
  end
  # ----------------------------------------------
  # GET /projects/attefall
  # ----------------------------------------------
  def attefall
    @route_path = "attefall"
    @meta_title = "Building a small house in Sweden | " + $author
    @images = []
    Dir.glob(Rails.public_path + 'images/attefall/*.jpg') do |filename|
      next if filename.include? '_sm'
      @file = filename.split('/').last
      @images.push(@file)
    end
  end
  # ----------------------------------------------
  # GET /writing
  # ----------------------------------------------
  def writing
    @route_path = "writing"
    @meta_title = "Writing | " + $author
    # params
    @post = params[:post]
    # posts.json
    # @posts = JSON.parse(File.read(Rails.public_path + 'posts.json'))
    # render post
    unless (@post.nil?)
      # tag
      # if @post == "algorithms" || @post == "computer-science" || @post == "machine-learning" || @post == "finance" || @post == "misc" || @post == "projects"
      #   @tag = @post
      #   # filter posts.json by tag
      #   @posts_array = Hash.new
      #   @posts.keys.each do |post|
      #     if @posts[post]['tags'].include? @post
      #       @title = @posts[post]['title']
      #       @tags = @posts[post]['tags']
      #       @date = @posts[post]['date']
      #       @updated = @posts[post]['updated']
      #       @draft = @posts[post]['draft']
      #       if @draft
      #         # set date to this year, format YYYYMMDD
      #         @date = Time.now.strftime("%Y%m%d")
      #         @updated = @date
      #       end
      #       @read = @posts[post]['read']
      #       @intro = @posts[post]['intro']
      #       @posts_array[post] = {
      #         title: @title,
      #         tags: @tags,
      #         date: @date,
      #         updated: @updated,
      #         draft: @draft,
      #         read: @read,
      #         intro: @intro
      #       }
      #     end
      #   end
      #   # set post to nil
      #   @post = nil
      #   # sort by date if not sorted already
      #   @posts_array = @posts_array.sort_by{ |_,h| -h[:date].to_i }.to_h
      #   # override meta title
      #   @meta_title = "Computer Science"
      # else
      #   @file = @post + '.md'
      #   @post_details = File.readlines(Rails.public_path + 'posts/' + @file).first(4) # array
      #   # post details
      #   @title = @post_details[0].strip
      #   @author = @post_details[1].strip
      #   @date = @post_details[2].strip
      #   @updated = @post_details[3].strip
      #   if @draft
      #     # set date to this year, format YYYYMMDD
      #     @date = Time.now.strftime("%Y%m%d")
      #     @updated = @date
      #   end
      #   @lines = File.readlines(Rails.public_path + 'posts/' + @file).drop(4)
      #   @all_lines = @lines.join
      #   # override meta title
      #   @meta_title = @title + " | Michael Sjöberg"
      #   # count words
      #   @words = 0
      #   @lines.drop(5).each do |line|
      #     words = line.split(' ')
      #     words.each do |word|
      #       @words += 1
      #     end
      #   end
      # end
      @file = @post + '.md'
      @post_details = File.readlines(Rails.public_path + 'posts/' + @file).first(4) # array
      # post details
      @title = @post_details[0].strip
      @author = @post_details[1].strip
      @date = @post_details[2].strip
      @updated = @post_details[3].strip
      if @draft
        # set date to this year, format YYYYMMDD
        @date = Time.now.strftime("%Y%m%d")
        @updated = @date
      end
      @lines = File.readlines(Rails.public_path + 'posts/' + @file).drop(4)
      @all_lines = @lines.join
      # override meta title
      @meta_title = @title + " | Michael Sjöberg"
      # count words
      @words = 0
      @lines.drop(5).each do |line|
        words = line.split(' ')
        words.each do |word|
          @words += 1
        end
      end
    # render all posts unless hash already created by filter
    else
      @dir_posts = []
      Dir.glob(Rails.public_path + 'posts/*.md') do |filename|
        next if filename.include? 'OLD'
        @post_details = File.readlines(filename).first(4) # array
        # draft
        next if @post_details[0].include? '<'
        # post details
        @title = @post_details[0].strip
        @author = @post_details[1].strip
        @date = @post_details[2].strip
        @updated = @post_details[3].strip
        @filename = filename.split('/').last.split('.').first
        @dir_posts.push({ 
          title: @title,
          author: @author,
          date: @date,
          updated: @updated,
          filename: @filename
        })
      end
      @dir_posts.sort! { |a, b| Date.parse(b[:date]) <=> Date.parse(a[:date]) }
    end
  end
  # ----------------------------------------------
  # private
  # ----------------------------------------------
  private
    # meta
    def set_meta
      @meta_image = "fav.png"
      @meta_site_name = "michaelsjoeberg.com"
      @meta_card_type = "summary"
      @meta_author = "@miqqeio"
    end
end