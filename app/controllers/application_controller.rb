class ApplicationController < ActionController::Base
  before_filter :prepare_for_mobile, :send_form_authenticity_token
  protect_from_forgery

  private

      def send_form_authenticity_token
        #logger.info request
	response.headers['X-Authenticity-Token'] = form_authenticity_token
      end

      def prepare_for_mobile
	session[:mobile_param] = params[:mobile] if params[:mobile]
	request.format = :mobile if mobile_device?
      end

      def mobile_device?
	if session[:mobile_param]
	  #compares session to 1, returns true or false
	  session[:mobile_param] == "1"
	else
	  #regex matching, returns true or false
	  request.user_agent =~ /Mobile|webOS/
	end
      end

      helper_method :mobile_device?
end
