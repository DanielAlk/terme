class PanelController < ApplicationController
	before_filter :authenticate_admin!, only: :admin
	before_filter :authenticate_user!, only: :profile
	layout 'panel'
	
  def admin
  end
	
  def profile
  end
end
