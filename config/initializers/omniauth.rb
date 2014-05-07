Rails.application.config.middleware.use OmniAuth::Builder do
  provider :jawbone,
  # ENV['JAWBONE_CLIENT_ID'],
  'OwfghOK7-qwdaaEJI',
  # ENV['JAWBONE_CLIENT_SECRET'],
  '4322f0c9c9c624c78c1db085z34353b71607b4xxxb93',
  scope: "basic_read mood_read sleep_read move_read"
end