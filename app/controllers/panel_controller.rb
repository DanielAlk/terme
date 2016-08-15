class PanelController < ApplicationController
	before_filter :authenticate_admin!, only: :admin
	before_filter :authenticate_user!, except: :admin
	layout 'panel'
	
  def admin
  end
	
  def profile
  end

  def user_cards
  	@cards = current_user.cards
  end

  def destroy_user_card
  	card_id = params.require(:card_id)
  	deletion = current_user.delete_card(card_id)
  	if deletion['status'].try(:to_i) == 200
  		redirect_to user_cards_url, notice: "Ya no se recordará la tarjeta #{deletion['response']['payment_method']['name'].upcase}."
  	else
  		redirect_to user_cards_url, alert: 'No se pudo eliminar la tarjeta, intentalo nuevamente en unos minutos.'
  	end
  end

end
