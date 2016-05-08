'''
Web app configuration options.
'''

# Host to run on. Keep this as 127.0.0.1 for development, change to 0.0.0.0 for
# opening to a network.
FLASK_HOST = '127.0.0.1'

# Port to run the app on.
FLASK_PORT = 5000

# Number of seconds a lexeme collection is active and can be changed.
LEXEME_COLLECTION_ACTIVE_TIME = 300

# Delay in seconds between checks for expired active lexeme collections.
POLLING_DELAY = 2
