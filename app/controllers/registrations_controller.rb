class RegistrationsController < Devise::RegistrationsController
  before_filter :authenticate

  protected
    def authenticate
        authenticate_or_request_with_http_basic do |username, password|
          username == 'candyfinderadmin' && password == 'iluvcandy'
        end
    end
end
