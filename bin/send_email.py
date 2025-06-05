import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

sender_email = "tdwebste@gmail.com"
password = "f7ckhklove34Tl9v3"

receiver_email = "tdwebste@gmail.com"

message = MIMEMultipart("alternative")
message["Subject"] = "python send_email"
message["From"] = sender_email
message["To"] = receiver_email

text = "test message change to stdin"
part = MIMEText(text, "plain")
message.attach(part)

try:
    # connect to server
    server = smtplib.SMTP_SSL("smtp.gmail.com", 465)
    server.login(sender_email, password)
    
    # send email
    server.sendmail(sender_email, receiver_email, message.as_string())

    print("Email sent successfully!")
except Exception as e:
    print(f"Error: {e}")
finally:
    server.quit()
