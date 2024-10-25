# Grab the latest alpine image
FROM alpine:latest

# Install python and pip
RUN apk add --no-cache --update python3 py3-pip bash

# Create a virtual environment
RUN python3 -m venv /venv

# Ensure pip is up to date
RUN /venv/bin/pip install --no-cache-dir --upgrade pip

# Add requirements file
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install dependencies in the virtual environment
RUN /venv/bin/pip install --no-cache-dir -q -r /tmp/requirements.txt

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Expose the port (optional)
EXPOSE 5000

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

# Run the app
CMD /venv/bin/gunicorn --bind 0.0.0.0:$PORT wsgi
