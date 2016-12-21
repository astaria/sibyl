require 'pathname'
require File.expand_path("../task.rb", __FILE__)

module Sibyl
  class Base
    def self.load
			self.tasks.each do |task|
        Dir[Rails.root.join("app", "sibyl", task, "*.rb").to_s].each do |rb|
					STDERR.puts "Requiring: #{rb}"
          require rb
        end
      end
    end

		def self.tasks
			tasks = []
			Dir[Rails.root.join("app", "sibyl", "*").to_s].each do |file|
				if File.directory? file
					tasks.push(Pathname.new(file).basename)
				end
			end
			tasks
		end

		def self.list_columns(task)
			columns = {}
			Dir[Rails.root.join("app", "sibyl", task, "*.json").to_s].each do |json_file|
				json = JSON.parse(File.read(json_file))
				json.each_key do |page|
					if json[page].has_key? 'elements'
						json[page]['elements'].each_key do |name|
							if json[page]['elements'][name].has_key? 'column' and json[page]['elements'][name]['column'].to_s == "true"
								columns[name] = true
							end
						end
					end
				end
			end
			return columns
		end

		def self.list_defaults(task)
			defaults = {}
			Dir[Rails.root.join("app", "sibyl", task, "*.json").to_s].each do |json_file|
				json = JSON.parse(File.read(json_file))
				json.each_key do |page|
					if json[page].has_key? 'elements'
						json[page]['elements'].each_key do |name|
							if json[page]['elements'][name].has_key? 'default'
								defaults[name] = json[page]['elements'][name]['default']
							else
								defaults[name] = "Default #{name}"
							end
						end
					end
				end
			end
			return defaults
		end

		def self.forms(task)
			dir = Rails.root.join("app", "sibyl", task)
			filesystem_bag = {}
			entries = Dir.entries(dir).select {|entry| File.directory? File.join(dir,entry) and !(entry =='.' || entry == '..') }
			entries.each do |form|
				name = form.split(/\//).last
				filesystem_bag['forms'] = [] unless filesystem_bag.has_key? 'forms'
				filesystem_bag['forms'].push name
			end
			begin
				filesystem_bag['defaults'] = self.list_defaults(task)
				filesystem_bag['columns'] = self.list_columns(task)
			rescue Exception => e
				STDERR.puts "Exception: #{e}: #{e.backtrace}"
			end
			return filesystem_bag
		end

		def self.pages(task, form)
			filesystem_bag = {}
			dir = Rails.root.join("app", "sibyl", task, form)
			json_file = dir.to_s.gsub(/$/, ".json")
			STDERR.puts "Reading: #{json_file}"
			begin
				filesystem_bag = JSON.parse(File.read(json_file))
			rescue Exception => e
				STDERR.puts("Exception: #{e}: #{e.backtrace}")
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
			return filesystem_bag
		end
  end
end
