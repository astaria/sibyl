require 'prawn'
require 'zip'

module Sibyl
	module Task
		include Magick

		def clear
			@sibyl_elements = {}
			@sibyl_pdfs = []
		end
		def prepare(obj = nil)
			clear unless @sibyl_elements
			obj = self if obj == nil
			obj.attributes.each do |col,val|
				STDERR.puts "attr: #{col}: #{val}"
				@sibyl_elements[col] = val
			end
		end
		def fill
			prepare
			STDERR.puts "Obj: #{self}"
			STDERR.puts "Obj.class: #{self.class}"
			@task = ActiveSupport::Inflector.underscore(self.class.to_s).pluralize
			STDERR.puts "@task: #{@task}"
			Dir[Rails.root.join("app", "sibyl", @task, "*.json").to_s].each do |json|
				self.create_pdf(json, Rails.root.join("tmp"))
			end
		end
		def create_pdf(json, dest_dir)
			STDERR.puts "json: #{json}"
			data = JSON.parse(File.read(json))
			STDERR.puts "data: #{data.inspect}"
			dir = Pathname.new(json.gsub(/\.json/i, ""))
			STDERR.puts "dir: #{dir}"
			STDERR.puts "dir.basename: #{dir.basename}"
			pdf_path = Pathname.new(dest_dir.to_s).join( dir.basename.to_s.gsub(/\/$|\\$/, '') + ".pdf" )
			STDERR.puts "pdf_path: #{pdf_path}"
			pdf = nil
			tmp_images = []
			data.keys.each do |page_name|
				img_path = dir.join(page_name).to_s
				img_outpath = dest_dir.join(page_name).to_s
				STDERR.puts "img_path: #{img_path}"
				STDERR.puts "img_outpath: #{img_outpath}"
				STDERR.puts "data[#{page_name}]: #{data[page_name]}"
				if data[page_name].has_key? 'elements'
					img = ImageList.new(img_path)
					text = Magick::Draw.new
					elements = data[page_name]['elements']
					STDERR.puts "elements: #{elements}"
					elements.keys.each do |col|
						STDERR.puts "elments[#{col}]: #{elements[col]}"
						if elements[col].has_key? 'fontsize'
							STDERR.puts "setting fontsize: #{elements[col]['fontsize']}"
		      		text.pointsize = elements[col]['fontsize'].to_f + 2
						end
						if elements[col].has_key?('x') and elements[col].has_key?('y')
							STDERR.puts "received element: #{elements[col]['x']},#{elements[col]['y']}"
							if self.respond_to? col
								STDERR.puts "Setting: #{col} at #{elements[col]['x']},#{elements[col]['y']}"
								text.annotate(img, 0,0,elements[col]['x'].to_i,elements[col]['y'].to_i + 15, self.send(col)) {
				        	self.fill = 'black'
				      	}
							end
						end
					end
					img.write(img_outpath)
					tmp_images.push img_outpath
				else
					STDERR.puts "No elements to using default: #{img_path}"
					img_outpath = img_path
				end

				img = Magick::Image.ping(img_outpath).first
      	width = img.columns
      	height = img.rows

	      # Image should be 300dpi
	      # LETTER = 612.00 x 792.0
	      # Which is 2550 px, 3300 px
	      # This works out to 612 / 2550 = 0.24
	      ratio = 0.24
	      pdf_width = width * ratio
	      pdf_height = height * ratio

			 	if pdf
					STDERR.puts "start_new_page"
					pdf.start_new_page(:page_size => [pdf_width, pdf_height], :margin => 0)
				else
					STDERR.puts "generate_pdf"
					pdf = Prawn::Document.new(:page_size => [pdf_width, pdf_height], :margin => 0)
				end
				STDERR.puts "#{page_name}: Putting: #{img_outpath} of #{width},#{height} at [0,#{pdf_height}]"
				pdf.image img_outpath, :at => [0,pdf_height],  :width => pdf_width
			end
			pdf.render_file pdf_path
      STDERR.puts "Saved to: #{pdf_path}"
			# Clean up tmp images
			tmp_images.each do |img_path|
				File.unlink img_path
			end
			@sibyl_pdfs.push pdf_path
      return pdf_path
    end

		def zip_path
			fill

			dirpath = Rails.root.join('tmp', "#{@task}#{self.id}-#{SecureRandom.hex(8)}")
      FileUtils.mkdir dirpath
      zip_path = dirpath.join("#{@task}.zip").to_s
      STDERR.puts "Creating: #{zip_path}"
			Zip::File.open(zip_path, Zip::File::CREATE) do |zipfile|
				@sibyl_pdfs.each do |pdf|
					STDERR.puts "Adding: #{pdf}"
					zipfile.add(Pathname.new(pdf.to_s).basename, pdf)
				end
			end
			return zip_path
		end
	end
end
