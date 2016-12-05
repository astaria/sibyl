require_dependency "sibyl/application_controller"

module Sibyl
  class EditorController < ApplicationController
		protect_from_forgery :except => :save_form
    def index
    end

		def index_task
			bag = {}
			dir = Rails.root.join("app", "sibyl", params[:task])
			filesystem_bag = {}
			Dir[dir.join("*")].each do |form|
				name = form.split(/\//).last
				filesystem_bag[name] = {}
				Dir[dir.join(form, "*.png").to_s].each do |page|
					png = page.split("/").last
					unless filesystem_bag[name].has_key? page
						filesystem_bag[name][png] = {}
					end
					img = Magick::Image.ping( page ).first
					filesystem_bag[name][png]['width'] = img.columns
					filesystem_bag[name][png]['height'] = img.rows
				end
			end
			p filesystem_bag
			render json: filesystem_bag
		end

		def index_form
			filesystem_bag = {}
			dir = Rails.root.join("app", "sibyl", params[:task], params[:form])
			json_file = dir.to_s.gsub(/$/, ".json")
			logger.info "Reading: #{json_file}"
			begin
				filesystem_bag = JSON.parse(File.read(json_file))
			rescue Exception => e
				logger.info("Exception: #{e}: #{e.backtrace}")
				Dir[dir.join("*")].each do |form|
					name = form.split(/\//).last
					unless filesystem_bag.has_key? name
						filesystem_bag[name] = {}
					end
					img = Magick::Image.ping( form ).first
					filesystem_bag[name]['width'] = img.columns
					filesystem_bag[name]['height'] = img.rows
				end
			end
			p filesystem_bag
			render json: filesystem_bag
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

    def edit

    end
  end
end
