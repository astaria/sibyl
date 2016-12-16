require_dependency "sibyl/application_controller"

module Sibyl
  class EditorController < ApplicationController
		protect_from_forgery :except => :save_form

		def index
			@tasks = Sibyl::Base.tasks
		end

		def list_task
			@filesystem_bag = Sibyl::Base.forms(params[:task])
			render json: @filesystem_bag
		end

		def index_task
			@filesystem_bag = Sibyl::Base.forms(params[:task])
			@task = params[:task]
			render "index_task"
		end

		def index_form
			@pages = Sibyl::Base.pages(params[:task], params[:form])
			render json: @pages
		end

		def save_form
			filesystem_bag = {}
			dir = Rails.root.join("app", "sibyl", params[:task], params[:form])
			json_file = dir.to_s.gsub(/$/, ".json")
			STDERR.puts "Writing: #{json_file}"
			File.open(json_file, "w") do |f|
				f.write params[:json].to_json
			end
			head :ok
		end

		def create
			logger.info "Got request: #{params[:task]} -> #{params[:form]}"
			task = params[:task]
			form = params[:form]
			@errors = []
			@errors.push ["Task name '#{task}' is not a valid ruby class name."] unless task =~ /^[A-Z]\w+/
			@errors.push ["Form name '#{form}' is not a valid ruby class name."] unless form =~ /^[A-Z]\w+/
			task = task.underscore.downcase
			form = form.underscore.downcase

			unless @errors.length == 0 and (@errors = Sibyl::Form.create_form(task, form, params[:pdf])).length == 0
				redirect_to "/sibyl/editor/edit/#{task}/#{form}"
			else
				logger.info "Errors: #{@errors}"
				rendeer 'create_error'
			end
		end

    def edit
			@pages = Sibyl::Base.pages(params[:task], params[:form])
    end
  end
end
