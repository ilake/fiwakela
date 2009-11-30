# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_iwakela-facebook_session',
  :secret      => 'a87dcd91270b6baf0f5ee995f82f3e6e5971cf873d3e5a8f708f4d2bcd8bad9a88c53bb00b6162a7afc28e08dd6d2422624a63fb64dd3b435c83e25eeeeb9921'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
