Sibyl::Engine.routes.draw do
  get "editor/edit/:task/:form", to: "editor#edit"
	get "editor/index", to: "editor#index"
	get "editor/index/:task(?)", to: "editor#index_task"
	get "editor/list/:task(?)", to: "editor#list_task"
	get "editor/index/:task/:form(?)", to: "editor#index_form"
	put "editor/save/:task/:form(?)", to: "editor#save_form"
end
