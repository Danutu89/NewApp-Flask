import httplib2
from apiclient.discovery import build
from oauth2client.client import flow_from_clientsecrets
from oauth2client.file import Storage
from oauth2client import tools
import argparse

CLIENT_SECRETS = 'analytics_key.json'

# The Flow object to be used if we need to authenticate.
FLOW = flow_from_clientsecrets(
    CLIENT_SECRETS,
    scope='https://www.googleapis.com/auth/analytics.readonly'
)

# A file to store the access token
TOKEN_FILE_NAME = 'credentials.dat'


def prepare_credentials():
    parser = argparse.ArgumentParser(parents=[tools.argparser])
    flags = parser.parse_args()
    # Retrieve existing credendials
    storage = Storage(TOKEN_FILE_NAME)
    credentials = storage.get()
    # If no credentials exist, we create new ones
    if credentials is None or credentials.invalid:
        credentials = tools.run_flow(FLOW, storage, flags)
    return credentials


def initialize_service():
    # Creates an http object and authorize it using
    # the function prepare_creadentials()
    http = httplib2.Http()
    credentials = prepare_credentials()
    http = credentials.authorize(http)
    # Build the Analytics Service Object with the authorized http object
    return build('analytics', 'v3', http=http)


if __name__ == '__main__':
    service = initialize_service()