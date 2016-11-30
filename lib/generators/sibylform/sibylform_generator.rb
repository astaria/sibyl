require 'fileutils'

class SibylformGenerator < Rails::Generators::NamedBase
  def create_pdf_file
    if ARGV.length < 3
			Sibyl::Form.usage
		end

		task = ARGV.shift
		form = ARGV.shift
		file = ARGV.shift

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
