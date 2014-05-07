Rails.application.config.middleware.use OmniAuth::Builder do
  provider :jawbone,
  # ENV['JAWBONE_CLIENT_ID'],
  'OwOK7-qwEJI',
  # ENV['JAWBONE_CLIENT_SECRET'],
  '4322f0c9c9c624c78c1db08534353b71607b4b93',
  scope: "basic_read mood_read sleep_read move_read"
end