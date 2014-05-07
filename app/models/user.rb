class User < ActiveRecord::Base
	def self.find_or_create_from_jawbone(auth)
		if user = where(uid: auth['uid']).first
			user.token = auth['credentials']['token']
			user.save!
			puts "============================================"
			puts "================================"			
		else
			user = create_from_jawbone(auth)
		end
		user
	end

	def self.create_from_jawbone(auth)
		create! do |user|
			user.uid        = auth['uid']
			user.token      = auth['credentials']['token']
			user.first_name = auth['info']['first_name']
			# user.last_name  = auth['info']['last_name']
		end
	end
	
	
	
	
	
	
	def self.update_activity_jawbone
		devices=UserDevice.where("active=?",true)
		devices.each do |devise|
			puts "#{devise.user_id}............... #{FITBIT_CONSUMER_KEY}.......#{FITBIT_SECRATE_KEY}"
			client = Fitgem::Client.new({:consumer_key => FITBIT_CONSUMER_KEY, :consumer_secret => FITBIT_SECRATE_KEY,:token=>devise.token,:secret=>devise.secret})
			data=client.activities_on_date 'yesterday'
			devise_user=devise.user
			if !data['summary'].blank?  and data['summary']["steps"].to_i>0
			    result=UserActivitie.where('user_id=? and activity_date=?',devise.user_id,(Date.today-1))
			    if result.blank?	
					UserActivitie.create(:user_id=>devise.user_id,:steps=>data['summary']["steps"].to_i,:provider=>devise.provider,:u_id=>devise.u_id,:activity_date=>(Date.today-1))
				puts "Updating user #{devise_user.first_name} with user id=#{devise.user_id} and email=#{devise_user.email} activity with steps=#{data['summary']["steps"].to_i}"
			    end
			else
				puts data.inspect
				puts "Updating user #{devise_user.first_name} with user id=#{devise.user_id} and email=#{devise_user.email} activity  failed ....#{data['success']}"
			end
		end
	end
	
end
