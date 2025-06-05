#https://app.sendgrid.com/settings/api_keys
#username tdwebste@gmail.com
#standard extended

import os
import sendgrid
#from sendgrid.helpers.mail import *
from sendgrid.helpers.mail import Mail

message = Mail(
    from_email='timw@genistsystems.com',
    to_emails='tdwebste@gmail.com',
    subject='Twilio:M1 errors',
    html_content='<strong>and easy to do anywhere, even with Python</strong>')
"""
    attachments: [
        {
            content: attachment,
            filename: "attachment.pdf",
            type: "application/pdf",
            disposition: "attachment"
        }
    ]
"""
try:
    sg = sendgrid.SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))
    response = sg.send(message)
    print(f"Email sent successfully! Status code: {response.status_code}")
    print(response.body)
    print(response.headers)
except Exception as e:
    print(f"Error: {str(e)}")

