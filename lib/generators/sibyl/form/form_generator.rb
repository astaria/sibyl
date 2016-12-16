require 'fileutils'
require 'rails/generators/active_record'

module Sibyl
	class FormGenerator < ActiveRecord::Generators::Base
		desc "Creates a new form from a PDF"
		argument :task, type: :string
		argument :form, type: :string
		argument :file, type: :string

	  def create_png_pages
			STDERR.puts "Task: #{task}"
			STDERR.puts "Form: #{form}"
			STDERR.puts "File: #{file}"
	    unless task =~ /^[a-zA-Z0-9_-]+$/
				STDERR.puts "Error: Task must not contain whitespace or invalid characters."
				Sibyl::Form.usage
			end
			unless form =~ /^[a-zA-Z0-9_-]+$/
				STDERR.puts "Error: Form must not contain whitespace or invalid characters."
				Sibyl::Form.usage
			end
			unless File.exists? file
				STDERR.puts "Error: File does not exist: #{file}"
				Sibyl::Form.usage
			end

			dir = Rails.root.join("app", "sibyl", task, form)
			FileUtils.mkdir_p dir

			Sibyl::Form.convert_to_pdf(dir, file)
	  end
	end
end
