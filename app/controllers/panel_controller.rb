class PanelController < ApplicationController
	before_filter :authenticate_admin!, only: :admin
	before_filter :authenticate_user!, except: :admin
	layout 'panel'
	
  def admin
  end
	
  def profile
  end

end
