Rails.application.routes.draw do
    get "/"                                             => "pages#about"
    get "/about"                                        => "pages#about", as: "about"
    get "/about/stack"                                  => "pages#stack", as: "stack"
    get "/about/courses"                                => "pages#courses", as: "courses"
    get "/programming"                                  => "pages#programming", as: "programming"
    get "/programming/:category/:group/:file"           => "pages#programming", as: "file"
    get "/projects"                                     => "pages#projects", as: "projects"
    get "/projects/attefall"                            => "pages#attefall", as: "attefall"
    get "/writing"                                      => "pages#writing", as: "writing"
    get "/posts"                                        => "pages#posts", as: "posts"
    get "/posts/:post"                                  => "pages#posts", as: "post"
end
