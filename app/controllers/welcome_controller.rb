class WelcomeController < ApplicationController
	require 'jawbone-up'
  def index
  	
  end



  def show
  	@client = Jawbone::Client.new "#{current_user.token}"
  	@work=@client.body_event('dv80YWQ2mYxQuGjMfOQuXA')
  	puts "==========#{@work}"
  end


























  def login
  	if !params[:email].blank? && !params[:password].blank?
    user=UserDevice.where("user_id=? and provider=?",current_user.id,"jawbone")
      if user.blank?
    user=UserDevice.new

    up = JawboneUP::Session.new
    up.signin params[:email], params[:password]
        @token=up.token
        @xid=  up.xid
       
    
      user.provider="jawbone"

      user.u_id = nil
      user.user_id=current_user.id
      user.active=true
      #user.username = auth.info.nickname
      user.token = @token
      user.secret = @xid
      user.save(:validate=>false)
    end
    end
    #respond_to do |format|
      #format.js
    #end
  end

end
