class PanelController < ApplicationController
	before_filter :authenticate_admin!
	layout 'panel'
	
  def index
  end
end
