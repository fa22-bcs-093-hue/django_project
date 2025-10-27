#!/bin/sh

echo "Starting Django application..."

# Change to the project directory
cd /django_project

# Run migrations
echo "Running migrations..."
python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Start the server
echo "Starting Django development server..."
exec python manage.py runserver 0.0.0.0:8000
