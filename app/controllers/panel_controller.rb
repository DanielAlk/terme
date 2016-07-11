class PanelController < ApplicationController
	before_filter :authenticate_admin!, only: :admin
	before_filter :authenticate_user!, only: :profile
	layout :choose_layout
	
  def admin
  end
	
  def profile
  end

  private
  	def choose_layout
  		case action_name.to_sym
  		when :admin
  			'admin'
  		when :profile
  			'profile'
  		end
  	end
end
