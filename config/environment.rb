# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "sanitize"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  config.active_record.observers = :record_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Taipei'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :en
end

require 'sanitize'

ENV['TZ'] = 'Asia/Taipei'

TIMEZONE_MINUS_0 = ["Casablanca","Dublin", "Edinburgh","Lisbon","London","Monrovia","UTC"]
TIMEZONE_MINUS_1 = ["Azores","Cape Verde Is."]
TIMEZONE_MINUS_2 = ["Mid-Atlantic"]
TIMEZONE_MINUS_3 = ["Brasilia", "Buenos Aires","Georgetown","Greenland"]
TIMEZONE_MINUS_4 = ["Atlantic Time (Canada)","La Paz","Santiago", "Newfoundland"]
TIMEZONE_MINUS_5 = ["Bogota","Eastern Time (US & Canada)","Indiana (East)", "Lima","Quito","Caracas"]
TIMEZONE_MINUS_6 = ["Central America","Central Time (US & Canada)", "Guadalajara", "Mexico City", "Monterrey", "Saskatchewan"]
TIMEZONE_MINUS_7 = ["Arizona","Chihuahua", "Mazatlan", "Mountain Time (US & Canada)"]
TIMEZONE_MINUS_8 = ["Pacific Time (US & Canada)", "Tijuana"]
TIMEZONE_MINUS_9 = ["Alaska"]
TIMEZONE_MINUS_10 = ["Hawaii"]
TIMEZONE_MINUS_11 = ["International Date Line West", "Midway Island", "Samoa"]
TIMEZONE_PLUS_13 = ["Nuku'alofa"]
TIMEZONE_PLUS_12 = ["Auckland", "Fiji", "Kamchatka", "Marshall Is.", "Wellington"]
TIMEZONE_PLUS_11 = ["Magadan", "New Caledonia", "Solomon Is."]
TIMEZONE_PLUS_10 = ["Brisbane", "Canberra", "Guam", "Hobart", "Melbourne", "Port Moresby", "Sydney", "Vladivostok"]
TIMEZONE_PLUS_9 = ["Osaka", "Sapporo", "Seoul", "Tokyo", "Yakutsk", "Adelaide", "Darwin"]
TIMEZONE_PLUS_8 = ["Beijing", "Chongqing", "Hong Kong", "Irkutsk", "Kuala Lumpur", "Perth", "Singapore", "Taipei", "Ulaan Bataar", "Urumqi"]
TIMEZONE_PLUS_7 = ["Bangkok", "Hanoi", "Jakarta", "Krasnoyarsk"]
TIMEZONE_PLUS_6 = ["Almaty", "Astana", "Dhaka", "Novosibirsk", "Rangoon"]
TIMEZONE_PLUS_5 = ["Ekaterinburg", "Islamabad", "Karachi", "Tashkent", "Chennai", "Kolkata", "Mumbai", "New Delhi", "Sri Jayawardenepura", "Kathmandu"]
TIMEZONE_PLUS_4 = ["Abu Dhabi", "Baku", "Muscat", "Tbilisi", "Yerevan", "Kabul"]
TIMEZONE_PLUS_3 = ["Baghdad", "Kuwait", "Moscow", "Nairobi", "Riyadh", "St. Petersburg", "Volgograd", "Tehran"]
TIMEZONE_PLUS_2 = ["Athens", "Bucharest", "Cairo", "Harare", "Helsinki", "Istanbul", "Jerusalem", "Kyev", "Minsk", "Pretoria", "Riga", "Sofia", "Tallinn", "Vilnius"]
TIMEZONE_PLUS_1 = ["Amsterdam", "Belgrade", "Berlin", "Bern", "Bratislava", "Brussels", "Budapest", "Copenhagen", "Ljubljana", "Madrid", "Paris", "Prague", "Rome", "Sarajevo", "Skopje", "Stockholm", "Vienna", "Warsaw", "West Central Africa", "Zagreb"]
