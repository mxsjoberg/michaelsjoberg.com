class PagesController < ApplicationController
    before_action :set_meta

    # version
    $version = "4.5.0"

    # GET /
    def home
        @route_path = "posts"
        @meta_title = "Michael Sjöberg"
        # intro.json
        @intro = JSON.parse(File.read(Rails.public_path + 'intro.json'))
        # recent
        @recent = @intro['recent']
        # highlight
        @highlight = @intro['highlight']
    end

    # GET /programming
    def programming
        @route_path = "programming"
        @meta_title = "Programming"
        @category = params[:category]
        @group = params[:group]
        @file = params[:file]
        # programming.json
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
                @file_content = HTTParty.get(@path + "#{@group}/#{@file}" + @format).parsed_response
            rescue
                @file_content = nil
            end
        end
    end

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
        @post = params[:post]
        # posts.json
        @posts = JSON.parse(File.read(Rails.public_path + 'posts.json'))
        # post
        unless (@post.nil?)
            @file = @post + '.md'
            @title = @posts[@post]['title']
            @tags = @posts[@post]['tags']
            @date = @posts[@post]['date']
            @updated = @posts[@post]['updated']
            @draft = @posts[@post]['draft']
            @lines = File.readlines(Rails.public_path + 'posts/' + @file)
            @skip = @lines[4].to_i
            unless (@skip == 0)
                @toc = @lines[5..@skip]
            end
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
            # content
            # to render full file
            # @content = @lines.drop(4).join("\n")
        # all posts
        else
            @posts_array = Hash.new
            @posts.keys.each do |post|
                @file = post + '.md'
                # @date = post
                @title = @posts[post]['title']
                @tags = @posts[post]['tags']
                @date = @posts[post]['date']
                @updated = @posts[post]['updated']
                @draft = @posts[post]['draft']
                @posts_array[post] = { title: @title, tags: @tags, date: @date, updated: @updated, draft: @draft }
            end
        end
    end

    # GET /about
    # def about
    #     @route_path = "about"
    #     @meta_title = "About"
    #     # projects
    #     @projects = JSON.parse(File.read(Rails.public_path + 'projects.json'))
    # end

    # GET /about/courses
    def courses
        @route_path = "courses"
        @meta_title = "Course List"
        # courses
        @courses = JSON.parse(File.read(Rails.public_path + 'courses.json'))
    end

    private
        # meta
        def set_meta
            @meta_image = ""
            @meta_site_name = "michaelsjoeberg.com"
            @meta_card_type = "summary"
            @meta_author = "@sjoebergco"
        end
end