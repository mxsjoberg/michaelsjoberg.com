class PagesController < ApplicationController
  before_action :set_meta
  $author = "Michael Sjöberg"
  $version = "5.0.0"
  $updated = "July 22, 2023"
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
    @meta_title = $author
    # courses
    @courses = JSON.parse(File.read(Rails.public_path + 'courses.json'))
  end
  # ----------------------------------------------
  # GET /about/stack
  # ----------------------------------------------
  def stack
    @route_path = "stack"
    @meta_title = $author
    # stack
    @stack = JSON.parse(File.read(Rails.public_path + 'stack.json'))
  end
  # ----------------------------------------------
  # GET /projects
  # ----------------------------------------------
  def projects
    @route_path = "projects"
    @meta_title = $author
    # projects.json
    @projects = JSON.parse(File.read(Rails.public_path + 'projects.json'))
  end
  # ----------------------------------------------
  # GET /projects/attefall
  # ----------------------------------------------
  def attefall
    @route_path = "attefall"
    @meta_title = $author
    @images = []
    Dir.glob(Rails.public_path + 'images/attefall/*.jpg') do |filename|
      next if filename.include? '_sm'
      @file = filename.split('/').last
      @images.push(@file)
    end
  end
  # ----------------------------------------------
  # GET /post/:post
  # ----------------------------------------------
  def post
    @route_path = "post"
    @meta_title = $author
    # params
    @post = params[:post]
    # render post
    unless (@post.nil?)
      @file = @post + '.md'
      # join files in two folders
      @files = Dir.glob(Rails.public_path + 'posts/*.md') + Dir.glob(Rails.public_path + 'programming/*.md')
      # get file in files
      @file = @files.select { |file| file.include? @file }.first
      # @post_details = File.readlines(Rails.public_path + 'posts/' + @file).first(4) # array
      @post_details = File.readlines(@file).first(6)
      # post details
      @title = @post_details[0].strip
      @author = @post_details[1].strip
      @date = @post_details[2].strip
      @updated = @post_details[3].strip
      @language = @post_details[4].strip
      @category = @post_details[5].strip
      if @draft
        # set date to this year, format YYYYMMDD
        @date = Time.now.strftime("%Y%m%d")
        @updated = @date
      end
      @lines = File.readlines(Rails.public_path + 'posts/' + @file).drop(6)
      @all_lines = @lines.join
      # override meta title
      @meta_title = @title
      # count words
      @words = 0
      @lines.drop(6).each do |line|
        words = line.split(' ')
        words.each do |word|
          @words += 1
        end
      end
    end
  end
  # ----------------------------------------------
  # GET /writing
  # ----------------------------------------------
  def writing
    @route_path = "writing"
    @meta_title = $author
    # params
    @post = params[:post]
    # render post
    unless (@post.nil?)
      @file = @post + '.md'
      @post_details = File.readlines(Rails.public_path + 'posts/' + @file).first(6)
      # post details
      @title = @post_details[0].strip
      @author = @post_details[1].strip
      @date = @post_details[2].strip
      @updated = @post_details[3].strip
      @language = @post_details[4].strip
      @category = @post_details[5].strip
      if @draft
        # set date to this year, format YYYYMMDD
        @date = Time.now.strftime("%Y%m%d")
        @updated = @date
      end
      @lines = File.readlines(Rails.public_path + 'posts/' + @file).drop(6)
      @all_lines = @lines.join
      # override meta title
      @meta_title = @title
      # count words
      @words = 0
      @lines.drop(6).each do |line|
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
        @post_details = File.readlines(filename).first(6)
        # draft
        next if @post_details[0].include? '<'
        # post details
        @title = @post_details[0].strip
        @author = @post_details[1].strip
        @date = @post_details[2].strip
        @updated = @post_details[3].strip
        @language = @post_details[4].strip
        @category = @post_details[5].strip
        @filename = filename.split('/').last.split('.').first
        @dir_posts.push({ 
          title: @title,
          author: @author,
          date: @date,
          updated: @updated,
          language: @language,
          category: @category,
          filename: @filename
        })
      end
      @dir_posts.sort! { |a, b| Date.parse(b[:date]) <=> Date.parse(a[:date]) }
    end
  end
  # ----------------------------------------------
  # GET /programming
  # ----------------------------------------------
  def programming
    @route_path = "programming"
    @meta_title = $author
    # OLD
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
    else
      # NEW
      @dir_programming = []
      Dir.glob(Rails.public_path + 'programming/*.md') do |filename|
        next if filename.include? 'OLD'
        @post_details = File.readlines(filename).first(6)
        # draft
        next if @post_details[0].include? '<'
        # post details
        @title = @post_details[0].strip
        @author = @post_details[1].strip
        @date = @post_details[2].strip
        @updated = @post_details[3].strip
        @language = @post_details[4].strip
        @category = @post_details[5].strip
        @filename = filename.split('/').last.split('.').first
        @dir_programming.push({ 
          title: @title,
          author: @author,
          date: @date,
          updated: @updated,
          language: @language,
          category: @category,
          filename: @filename
        })
      end
      @dir_programming.sort! { |a, b| Date.parse(b[:date]) <=> Date.parse(a[:date]) }
      # group on language then category
      @dir_programming_grouped = @dir_programming.group_by { |d| d[:language] }
      @dir_programming_grouped.each do |key, value|
        @dir_programming_grouped[key] = value.group_by { |d| d[:category] }
      end
    end
  end
  # ----------------------------------------------
  # private
  # ----------------------------------------------
  private
    # meta
    def set_meta
      @meta_image = "fav.png"
      @meta_site_name = "michaelsjoberg.com"
      @meta_card_type = "summary"
      @meta_author = "@mixmaester"
    end
end