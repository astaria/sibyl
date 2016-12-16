require 'rails/generators/base'

module Sibyl
	class InstallGenerator < Rails::Generators::Base
		desc "Installs sibyl on a fresh Rails project"

  	source_root File.expand_path('../templates', __FILE__)

		def copy_initializer
			  template 'sibyl.rb', 'config/initializers/sibyl.rb'
		end

		def mount_engine
			 route 'mount Sibyl::Engine => "/sibyl"'
		end
	end
end
