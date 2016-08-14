class Website < ActiveRecord::Base

	def dolar=(dolar)
	  write_attribute(:dolar, dolar.gsub('.', '').gsub(',', '.'))
	end

end
