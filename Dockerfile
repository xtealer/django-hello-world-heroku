# Start from a base image with Python 3.9.16 installed
FROM --platform=linux/amd64 python:3.9.16

# Set default variables.
ENV PORT=8000

RUN apt-get update && apt-get install -y portaudio19-dev libsndfile1 ffmpeg && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file into the container and install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Set environment variables for Django
# ENV DJANGO_SETTINGS_MODULE=mysite.settings.production
# ENV PYTHONUNBUFFERED 1
# ENV DEBUG 1

# Collect static files
RUN python manage.py collectstatic --noinput

COPY . /app/

# Start Gunicorn
CMD gunicorn mysite.wsgi --bind 0.0.0.0:$PORT