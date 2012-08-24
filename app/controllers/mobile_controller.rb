class MobileController < ApplicationController
  #prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  #prepend_before_filter :allow_params_authentication!, :only => :create
  skip_before_filter :verify_authenticity_token, :only => [ :create, :destroy, :sign_up ]
  respond_to :json, :except => [:index]

  def index

    render :layout => false
  end

  # create authenticity token if user authentication succeeds
  def login
    email = params[:email]
    password = params[:password]

    if request.format != :json
      render :json => {:status => 406, :message => "The request must be json" }
      return
    end

    if email.nil? or password.nil?
      render :json => {:status => 400, :message => "Must provide email address and password"}
      return
    end

    @user = User.find_by_email(email)

    if @user.nil?
      logger.info("user @{email} failed sign in.  User not found")
      render :json => {:status => 402, :message => "#{email} not found"}
      return
    end

    #Only resets auth token if it's blank
    # /usr/lib/ruby/gems/1.8/gems/devise-2.0.4/lib/devise/models/token_authenticatable.rb:
    @user.ensure_authentication_token!

    if @user.valid_password?(password)
      logger.info @user.to_json
      logger.info "Auth token = #{@user.authentication_token}"
      render :json => {:status => 200, :user => @user, :authentication_token => @user.authentication_token }
      return
    else
      logger.info "User #{email} invalid password"
      render :json => {:status => 401, :message => "Invalid password"}
      return
    end
  end

  #Destroy mobile session
  def logout
    @user = User.find_by_authentication_token(params[:id])
    if @user.nil?
      logger.info "User token #{params[:id]} not found"
      render :json => {:status => 404, :message => "Invalid token"}
    else
      @user.reset_authentication_token!
      render :json => {:status => 200, :message => params[:id]}
    end
  end

  # Sign up mobile user
  def sign_up
    if request.format != :json
      render :json => {:status => 406, :message => "The request must be json" }
      return
    end

    @user = nil
    build_resource

    if @user.save
	logger.info "User registered and signed in"
        sign_in(User, @user)
	@user.ensure_auentication_token!
        render :json => {:status => 200, :user => @user, :authentication_token => @user.authentication_token}
    else
      @user.clean_up_passwords if @user.respond_to?(:clean_up_passwords)
      render :json => {:status => 404, :message => @user.errors.full_messages.join("\n") }
    end
  end

  #get mobile user
  #@params authentication_token
  def user
    if params[:id]
      @user = User.find_by_authentication_token(params[:id])
      if @user
	logger.info "mobile/user: User info retrieved"
	render :json => {:status => 200, :user => @user, :authentication_token => @user.authentication_token}
      else
	logger.info "mobile/user: Invalid authentication token #{params[:id]}"
	render :json => {:status => 404, :message => "Invalid authentication token", :authentication_token => params[:id]}
      end
    end
  end

  protected

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    hash ||= params[:user] || {}
    @user = User.new_with_session(hash, session)
  end

end
