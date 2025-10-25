class ApplicationController < ActionController::Base

  allow_browser versions: :modern

  
  before_action :configure_permitted_parameters, if: :devise_controller?

 
  before_action :set_locale 

  protected

 
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :bio])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  private 

  
  def set_locale

    puts "\n" # Apenas para separar as mensagens no terminal
    puts "DEBUG --- In set_locale method ---"
    puts "DEBUG: I18n.locale ANTES de qualquer alteração = #{I18n.locale.inspect}"
    puts "DEBUG: params[:locale] = #{params[:locale].inspect}"
    puts "DEBUG: session[:locale] = #{session[:locale].inspect}"
    puts "DEBUG: http_accept_language.compatible_language_from(I18n.available_locales) = #{http_accept_language.compatible_language_from(I18n.available_locales).inspect}"
    
    I18n.locale = params[:locale] || session[:locale] || http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
    session[:locale] = I18n.locale 

    puts "DEBUG: I18n.locale APÓS determinar = #{I18n.locale.inspect}"
    session[:locale] = I18n.locale # Persiste o locale na sessão
    puts "DEBUG: session[:locale] APÓS atualizar = #{session[:locale].inspect}"
    puts "DEBUG --- End set_locale method ---"
    puts "\n"
  end

    def default_url_options
    { locale: I18n.locale }
  end
end