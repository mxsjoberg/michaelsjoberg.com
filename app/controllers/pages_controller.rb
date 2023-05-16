class PagesController < ApplicationController
  before_action :set_meta
  # version
  $version = "5.0.0"
  # GET /
  def home
    @route_path = "home"
    @meta_title = "Michael Sjöberg"
    # posts.json
    @posts = JSON.parse(File.read(Rails.public_path + 'posts.json'))
    @posts_array = Hash.new
    @max_len = 1
    @posts.keys.each do |post|
      unless @posts[post]['draft'] == true || @posts_array.length >= @max_len
        @posts_array[post] = {
          title: @posts[post]['title'],
          date: @posts[post]['date']
        }
      end
    end
    # sort by date if not sorted already
    @posts_array = @posts_array.sort_by{ |_,h| -h[:date].to_i }.to_h
  end
  # GET /programming
  def programming
    @route_path = "programming"
    @meta_title = "Programming"
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
  # GET /finance
  # def finance
  #   @route_path = "finance"
  #   @meta_title = "Finance"
  #   # finance.json
  #   @finance = JSON.parse(File.read(Rails.public_path + 'finance.json'))
  #   @url = @finance["url"]
  #   @format = @finance["format"]
  # end
  # GET /projects
  def projects
    @route_path = "projects"
    @meta_title = "Projects"
    # projects.json
    @projects = JSON.parse(File.read(Rails.public_path + 'projects.json'))
  end
  # GET /writing
  def writing
    @route_path = "writing"
    @meta_title = "Writing"
    # params
    @post = params[:post]
    # posts.json
    @posts = JSON.parse(File.read(Rails.public_path + 'posts.json'))
    # random
    if @post == "random"
      # pick random sample in posts.json
      @post = @posts.keys.sample
      # redirect
      redirect_to "/writing/#{@post}"
    end
    # redirects
    if @post == "a-few-notes-on-investing" || @post == "investing-in-stocks-like-a-pro" || @post == "how-to-invest-in-stocks-like-a-pro"
      @post = "how-to-invest-in-stocks"
    end
    if @post == "computer-vision-in-a-hurry" || @post == "a-deep-dive-into-computer-vision"
      @post = "lecture-notes-on-computer-vision"
    end
    if @post == "why-are-financial-data-apps-so-bad"
      @post = "building-an-alternative-to-yahoo-finance"
    end
    if @post == "computer-systems-and-low-level-software-security" || @post == "a-computer-systems-primer-for-application-developers"
      @post = "lecture-notes-on-security-engineering"
    end
    # render post
    unless (@post.nil?)
      # tag
      if @post == "algorithms" || @post == "computer-science" || @post == "machine-learning" || @post == "finance" || @post == "misc" || @post == "projects"
        @tag = @post
        # filter posts.json by tag
        @posts_array = Hash.new
        @posts.keys.each do |post|
          if @posts[post]['tags'].include? @post
            @title = @posts[post]['title']
            @tags = @posts[post]['tags']
            @date = @posts[post]['date']
            @updated = @posts[post]['updated']
            @draft = @posts[post]['draft']
            if @draft
              # set date to this year, format YYYYMMDD
              @date = Time.now.strftime("%Y%m%d")
              @updated = @date
            end
            @read = @posts[post]['read']
            @intro = @posts[post]['intro']
            @posts_array[post] = {
              title: @title,
              tags: @tags,
              date: @date,
              updated: @updated,
              draft: @draft,
              read: @read,
              intro: @intro
            }
          end
        end
        # set post to nil
        @post = nil
        # sort by date if not sorted already
        @posts_array = @posts_array.sort_by{ |_,h| -h[:date].to_i }.to_h
        # override meta title
        @meta_title = "Computer Science"
      else
        @file = @post + '.md'
        @title = @posts[@post]['title']
        @tags = @posts[@post]['tags']
        @date = @posts[@post]['date']
        @updated = @posts[@post]['updated']
        @draft = @posts[@post]['draft']
        if @draft
          # set date to this year, format YYYYMMDD
          @date = Time.now.strftime("%Y%m%d")
          @updated = @date
        end
        @toc = @posts[@post]['toc']
        @all_lines = File.read(Rails.public_path + 'posts/' + @file)
        @lines = File.readlines(Rails.public_path + 'posts/' + @file)
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
      end
    # render all posts unless hash already created by filter
    else
      @tags_all = Array.new
      @posts_array = Hash.new
      @posts.keys.each do |post|
        @file = post + '.md'
        @title = @posts[post]['title']
        @tags = @posts[post]['tags']
        @date = @posts[post]['date']
        @updated = @posts[post]['updated']
        @draft = @posts[post]['draft']
        if @draft
          # set date to this year, format YYYYMMDD
          @date = Time.now.strftime("%Y%m%d")
          @updated = @date
        end
        @read = @posts[post]['read']
        @intro = @posts[post]['intro']
        @posts_array[post] = {
          title: @title,
          tags: @tags,
          date: @date,
          updated: @updated,
          draft: @draft,
          read: @read,
          intro: @intro
        }
        # add tags to array
        @tags.each do |tag|
          @tags_all.push(tag)
        end
      end
      # sort by date if not sorted already
      @posts_array = @posts_array.sort_by{ |_,h| -h[:date].to_i }.to_h
      # remove duplicate in tags_array
      @tags_all = @tags_all.uniq!
      # sort tags_all
      @tags_all = @tags_all.sort
    end
  end
  # GET /about/courses
  def courses
    @route_path = "courses"
    @meta_title = "Course List"
    # courses
    @courses = JSON.parse(File.read(Rails.public_path + 'courses.json'))
  end
  # private
  private
    # meta
    def set_meta
      @meta_image = ""
      @meta_site_name = "michaelsjoeberg.com"
      @meta_card_type = "summary"
      @meta_author = "@miqqeio"
    end
end