'''
Web app configuration options.
'''

# Host to run on. Keep this as 127.0.0.1 for development, change to 0.0.0.0 for
# opening to a network.
flask_host = '127.0.0.1'

# Port to run the app on.
flask_port = 5000

# Number of seconds a lexeme collection is active and can be changed.
lexeme_collection_active_time = 300

# Delay in seconds between checks for expired active lexeme collections.
polling_delay = 2
