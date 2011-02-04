# coding: utf-8
require 'authenticated_system'

# This controller handles the login/logout function of the site.  
class <%= controller_class_name %>Controller < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  skip_before_filter :login_required 
  
  def new
  end

  def create
    logout_keeping_session!
    <%= file_name %> = <%= class_name %>.authenticate(params[:login], params[:password])
    if <%= file_name %>
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = <%= file_name %>
      redirect_back_or_default(root_path)
    else
      note_failed_signin
      @login = params[:login]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    render :action => 'new'
  end
  
  protected
    # Track failed login attempts
    def note_failed_signin
      flash.now[:error] = "Usuário ou senha inválida"
      logger.warn "Falha no login do usuario '#{params[:login]}' através do IP #{request.remote_ip} às #{Time.now.utc}"
    end
end