module Sibyl
  class Engine < ::Rails::Engine
    isolate_namespace Sibyl
    initializer "static assets" do |app|
      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, Rails.root.join("app", "sibyl").to_s)
    end
		def self.open
			require 'launchy'
			Launchy.open("http://localhost:3000/sibyl/editor/index")
		end
  end
end
