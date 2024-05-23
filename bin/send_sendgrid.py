#https://app.sendgrid.com/settings/api_keys
#username tdwebste@gmail.com
#standard extended

import os
import sendgrid
#from sendgrid.helpers.mail import *
from sendgrid.helpers.mail import Mail

message = Mail(
    from_email='timw@genistsystems.com',
    to_emails='tdwebste@example.com',
    subject='Sending with Twilio SendGrid is Fun',
    html_content='<strong>and easy to do anywhere, even with Python</strong>')
try:
    sg = sendgrid.SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))
    response = sg.send(message)
    print(f"Email sent successfully! Status code: {response.status_code}")
    print(response.body)
    print(response.headers)
except Exception as e:
    print(f"Error: {str(e)}")

