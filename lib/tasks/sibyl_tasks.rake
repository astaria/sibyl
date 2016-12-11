namespace :sibyl do
  task :open do
    desc "open tasks"
		Sibyl::Engine.open
  end
	task :install do
		initializer =	Rails.root.join("config", "initializers", "sibyl.rb")
		unless File.exists? initializer
			File.open(initializer, "w") do |f|
				f.write "Sibyl::Base.load"
			end
		end
		routes_file = Rails.root.join("config", "routes.rb")
		routes = File.read(routes_file).gsub(/Rails.application.routes.draw do/, "Rails.application.routes.draw do\n mount Sibyl::Engine => \"/sibyl\"\n")
		File.open(routes_file, "w") do |f|
			f.write routes
		end
	end
end
