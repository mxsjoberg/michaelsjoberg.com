Rails.application.routes.draw do
    #root to: "pages#home"
    get "/"                                             => "pages#home", as: "home"
    get "/programming"                                  => "pages#programming", as: "programming"
    get "/programming/:category/:group/:file"           => 'pages#programming', as: "file"
    get "/about"                                        => "pages#about", as: "about"
    get "/about/courses"                                => "pages#courses", as: "courses"
    get "/posts"                                        => "pages#posts", as: "posts"
    get "/posts/:post"                                  => "pages#posts", as: "post"
    # get "/writing"                                      => "pages#writing", as: "writing"
    # get "/writing/:post"                                => "pages#writing", as: "post"
    #get "/curriculum"                                   => "pages#curriculum", as: "curriculum"
    #get "/curriculum/:level"                            => "pages#curriculum", as: "level"
end
