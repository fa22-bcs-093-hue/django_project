#!/bin/sh

set -e

echo "Waiting for database to be ready..."
while ! python manage.py dbshell --command="SELECT 1;" > /dev/null 2>&1; do
    echo "Database is unavailable - sleeping"
    sleep 1
done

echo "Database is ready!"

echo "Running Database Migrations"
python manage.py makemigrations --noinput
python manage.py migrate --noinput

echo "Collecting static files"
python manage.py collectstatic --noinput

echo "Running app1 management commands"
python manage.py sample_management_command

echo "Starting Django application..."
exec "$@"