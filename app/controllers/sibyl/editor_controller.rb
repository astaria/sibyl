require_dependency "sibyl/application_controller"

module Sibyl
  class EditorController < ApplicationController
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
			json_file = dir.to_s.gsub(/.$/, ".json")
			if File.exists? json_file
				filesystem_bag = JSON.parse(File.read(json_file))
			else
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

    def edit
			
    end
  end
end
