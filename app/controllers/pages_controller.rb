class PagesController < ApplicationController
    before_action :get_time, :set_meta, :get_twitter#, :get_github

    # version
    $version = "3.0.0"

    # GET /
    def home
        @route_path = "posts"
        @meta_title = "Michael Sjöberg"
        # intro
        @intro = JSON.parse(File.read(Rails.public_path + 'intro.json'))
        @typewriter = @intro['intro']
        # recent
        @recent = @intro['recent']
        # post
        @posts = JSON.parse(File.read(Rails.public_path + 'posts.json'))
        @post = @posts.keys.first
        @file = @post + '.md'
        @date = @post
        @title = @posts[@date]['title']
        @tags = @posts[@date]['tags']
        @lines = File.readlines(Rails.public_path + 'posts/' + @file)
        @updated = @lines[3]
        # count words
        @words = 0
        @lines.drop(4).each do |line|
            words = line.split(' ')
            words.each do |word|
                @words += 1
            end
        end
    end

    # GET /programming
    def programming
        @route_path = "programming"
        @meta_title = "Programming"
        @category = params[:category]
        @group = params[:group]
        @file = params[:file]
        # programming
        json_file = File.read(Rails.public_path + 'programming.json')
        @programming = JSON.parse(json_file)
        unless (@file.nil?)
            @meta_title = @file.titleize + " -- " + @category.titleize
            # define file properties
            @path = @programming[@category][@group]["path"]
            @url = @programming[@category][@group]["url"]
            @format = @programming[@category][@group]["format"]
            # get raw file content from github
            begin
                @content = HTTParty.get(@path + "#{@group}/#{@file}" + @format).parsed_response
            rescue
                @content = nil
            end
        end
    end

    # GET /posts
    def posts
        @route_path = "posts"
        @meta_title = "Posts"
        @post = params[:post]
        # post
        @posts = JSON.parse(File.read(Rails.public_path + 'posts.json'))
        unless (@post.nil?)
            @file = @post + '.md'
            @date = @post
            @title = @posts[@date]['title']
            @tags = @posts[@date]['tags']
            @lines = File.readlines(Rails.public_path + 'posts/' + @file)
            @updated = @lines[3]
            # override meta
            @meta_title = @title
            # count words
            @words = 0
            @lines.drop(4).each do |line|
                words = line.split(' ')
                words.each do |word|
                    @words += 1
                end
            end
        # all posts
        else
            @posts_array = Hash.new
            @posts.keys.each do |post|
                @file = post + '.md'
                @date = post
                @title = @posts[@date]['title']
                @tags = @posts[@date]['tags']
                @posts_array[@date] = { title: @title, tags: @tags,  }
            end
        end
    end

    # GET /about
    def about
        @route_path = "about"
        @meta_title = "About"
        # projects
        @projects = JSON.parse(File.read(Rails.public_path + 'projects.json'))
    end

    # GET /about/courses
    def courses
        @route_path = "courses"
        @meta_title = "Course List"
        # courses
        @courses = JSON.parse(File.read(Rails.public_path + 'courses.json'))
    end

    private
        # get time
        def get_time
            @time = Time.now
        end
        # meta
        def set_meta
            @meta_image = ""
            @meta_site_name = "michaelsjoeberg.com"
            @meta_card_type = "summary"
            @meta_author = "@sjoebergco"
        end
        
        # github api
        # def get_github
        #     url = "https://api.github.com/users/michaelsjoeberg/events/public?client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
        #     @commits = HTTParty.get(url).parsed_response
        # end
        
        # twitter api
        def get_twitter
            begin
                twitter_client = Twitter::REST::Client.new do |config|
                    config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
                    config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
                    config.access_token = ENV['TWITTER_ACCESS_TOKEN']
                    config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
                end
                @tweets = twitter_client.user_timeline("sjoebergco")
                @location = @tweets[0].user.location
                @description = (@tweets[0].user.description).split('--')[0]
            rescue
                @tweets = nil
                @location = nil
            end
        end
end