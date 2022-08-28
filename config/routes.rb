Rails.application.routes.draw do
    #root to: "pages#home"
    get "/"                                             => "pages#home", as: "home"
    get "/programming"                                  => "pages#programming", as: "programming"
    get "/programming/:category/:group/:file"           => 'pages#programming', as: "file"
    get "/projects"                                     => "pages#projects", as: "projects"
    # get "/about"                                        => "pages#about", as: "about"
    get "/about/courses"                                => "pages#courses", as: "courses"
    get "/writing"                                      => "pages#writing", as: "writing"
    get "/writing/:post"                                => "pages#writing", as: "post"
end
