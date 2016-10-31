require_dependency "sibyl/application_controller"

module Sibyl
  class EditorController < ApplicationController
    def index
    end

    def edit
      @root = Rails.root
    end
  end
end
