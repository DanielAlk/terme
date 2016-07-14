class PagesController < ApplicationController
  layout 'soon', only: :soon
  
  def home
  end
  def product
    @product = Product.friendly.find(params[:id])
  end
  def cart
  end
  def catalog
  end
  def checkout
  end
  def confirm
  end
  def partners
  end
  def engineering
  end
  def instalation
  end
  def about
  end
  def news
  end
  def contact
  end
  def soon
  end
end
