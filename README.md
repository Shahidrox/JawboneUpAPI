Jawbone-UP-API
====
<pre><code>gem 'omniauth-jawbone'</code></pre>
<pre><code>gem 'jawbone'</code></pre>
<pre><code>$ bundle</code></pre>
<pre>config/initializers/omniauth.rb create</pre>
<pre><code>
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :jawbone,<br />
  # ENV['JAWBONE_CLIENT_ID'],<br />
  'OwOK237-qwerEJI',<br />
  # ENV['JAWBONE_CLIENT_SECRET'],<br />
  '4322f0c9c9c624c78c1db08534353b71607b224b93',<br />
  scope: "basic_read mood_read sleep_read move_read"<br />
end
</code></pre>
====
<pre><code>$ rails g controller welcome index</code></pre>
<pre><code>welcome_controller.rb<br />
  def index<br />
  end<br />
  def show<br />
  	@client = Jawbone::Client.new "#{current_user.token}"<br />
  	@work=@client.body_event('dv80YWQ2mYxQuGjMfOQuXA')<br />
  	puts "==========#{@work}"<br />
  end
</code></pre>
====
<pre><code>
routes.rb<br />
get "welcome/index"<br />
  get "welcome/login"<br />
  get "welcome/show"<br />
  root :to => 'welcome#index'<br />

  get "auth/jawbone/callback" => 'sessions#create'<br />
  get 'signout', to: 'sessions#destroy', as: 'signout'<br />
</code></pre>
====
<pre><code>$ rails g controller sessions</code></pre>
<pre><code>sessions_controller.rb<br />
def create<br />
		user = User.find_or_create_from_jawbone(env['omniauth.auth'])<br />
		session[:user_id] = user.id<br />
    
      redirect_to root_path<br />
	end<br />

  def destroy<br />
    session[:user_id] = nil<br />
    redirect_to root_url, notice: "Signed out."<br />
  end<br />
</code></pre>
====
<pre><code>$ rails g model user</code></pre>
<pre><code>user.rb<br />
def self.find_or_create_from_jawbone(auth)<br />
		if user = where(uid: auth['uid']).first<br />
			user.token = auth['credentials']['token']<br />
			user.save!<br />
			puts "============================================"<br />
			puts "================================"			<br />
		else<br />
			user = create_from_jawbone(auth)<br />
		end<br />
		user<br />
	end<br />

	def self.create_from_jawbone(auth)<br />
		create! do |user|<br />
			user.uid        = auth['uid']<br />
			user.token      = auth['credentials']['token']<br />
			user.first_name = auth['info']['first_name']<br />
			# user.last_name  = auth['info']['last_name']<br />
		end<br />
	end<br />
</code></pre>
====
<pre><code>$ rails g migration AddTokenToUsers</code></pre>
<pre><code>20140506133902_add_token_to_users.rb<br />
def change<br />
  	add_column :users, :token, :string<br />
    add_column :users, :uid, :string<br />
    add_column :users, :first_name, :string<br />
    #rename_column :users, :name, :last_name<br />
  end<br />
</code></pre>
====
<pre><code>application.html.erb<br />
<% if current_user %><%= @users.inspect %>
  Signed in as <%= current_user.first_name %><br>
  <%= link_to "Sign out", signout_path %>
<% else %>
  <%= link_to "Sign in with Jawbone", "/auth/jawbone", :class => "btn btn-primary jawbone" %>
<% end %><br>
<a href="/welcome/show">Show Data</a>
</code></pre>
====
<pre><code>show.html.erb<br />
<%= @client.user %><br>
</code></pre>
====