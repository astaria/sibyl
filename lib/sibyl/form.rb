require 'RMagick'
require 'fileutils'

module Sibyl
	class Form
		def self.usage
			STDERR.puts <<EOT
Usage: bin/rails generate siblform <task name> <form name> <pdffile>
	Task name and form name must be valid file names. Task name is a general
	category for all forms that relate to a particular task. This is just for
	organization purposes. Both task and form name should be alphanumeric and
	not contain any whitespace.
EOT
			exit
		end
		def self.create_form(task,form,file)
			dir = Rails.root.join("app", "sibyl", task, form)
			pdf_file = dir.to_s.gsub(/$/, '.pdf')
			STDERR.puts "Dir: #{dir}"
			STDERR.puts "Saving: #{pdf_file}"
			STDERR.puts "Creating: #{dir}"
			FileUtils.mkdir_p dir
			File.open(pdf_file, 'wb') do |f|
    		f.write(file.read)
  		end
			STDERR.puts "Done"
			convert_to_pdf(dir,pdf_file)
		end
		def self.convert_to_pdf(folder, pdf)
			im = Magick::ImageList.new(pdf) {
				self.density = '300'
				self.background_color = "none"
			}
      im.reverse.each_with_index do |img, i|
				filename = sprintf "page%03d.png", i
				out = folder.join(filename)
				STDERR.puts "writing: #{out}"
  			xr = img.write(out)
				p xr
			end
		end
	end
end
