Rails.application.routes.draw do

  constraints subdomain: lambda { |sd| !sd[/stage/] && !sd[/panel/] } do
    get '(*soon)', to: 'pages#soon'
  end

  constraints subdomain: /panel/ do
    get '/', to: 'panel#admin', as: :panel

    devise_for :admins, controllers: {
      registrations: 'admins/registrations',
      sessions: 'admins/sessions',
      passwords: 'admins/passwords'
    }

    resources :categories
  end

  constraints subdomain: lambda { |sd| !sd[/panel/] } do
    devise_for :users, path: 'profile', controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions',
      passwords: 'users/passwords'
    }
  end

  root 'pages#home'

  get 'profile', to: 'panel#profile', as: :profile

  get 'home', to: 'pages#home', as: :home
  get 'producto', to: 'pages#product', as: :product_page
  get 'carrito', to: 'pages#cart', as: :cart_page
  get 'catalogo', to: 'pages#catalog', as: :catalog_page
  get 'checkout', to: 'pages#checkout', as: :checkout_page
  get 'confirmar', to: 'pages#confirm', as: :confirm_page
  get 'partners', to: 'pages#partners', as: :partners_page
  get 'ingenieria', to: 'pages#engineering', as: :engineering_page
  get 'instalacion', to: 'pages#instalation', as: :instalation_page
  get 'la-empresa', to: 'pages#about', as: :about_page
  get 'noticias', to: 'pages#news', as: :news_page
  get 'contacto', to: 'pages#contact', as: :contact_page

end