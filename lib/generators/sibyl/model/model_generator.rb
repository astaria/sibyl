require 'rails/generators/active_record'

module Sibyl
	class ModelGenerator < ActiveRecord::Generators::Base
		desc "Prepare Sibyl model and views"
		argument :task, type: :string

		def inject_into_model
			file = Rails.root.join("app", "models", "#{task.classify.underscore}.rb")
			inject_into_file file, after: "class #{task.classify} < ApplicationRecord" do
				"\n  include Sibyl::Task\n"
			end
		end

		def modify_controller
			file = Rails.root.join("app", "controllers", "#{task}_controllers.rb")
			gsub_file, file, /def show\r?\nend/, <<QUOTE
	respond_to do |format|
		format.html
		format.zip  { send_file @#{task.classify.uderscore}.zip_path }
	end
QUOTE
		end

		def modify_view
			file = Rails.root.join("app", "views", task, "index.html.erb")
			gsub_file file, "<th colspan=\"3\"></th>", "<th colspan=\"4\"></th>"
			inject_into_file file, after: "<td><%= link_to 'Show', #{task.classify.underscore} %></td>" do
				"\n      <td><%= link_to 'Download', #{task.classify.underscore}_path(#{task.classify.underscore})+'.zip' %></td>"
			end
		end

	end
end
