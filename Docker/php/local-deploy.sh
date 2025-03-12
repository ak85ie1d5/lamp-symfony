#!/bin/bash

cd /var/www/html || exit

# Generate the .env.local file
if [ ! -f '.env.local' ]; then

  cat <<EOF > .env.local
APP_ENV=dev
APP_SECRET=$(openssl rand -base64 32)
DATABASE_URL="mysql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
MAILER_DSN=
EOF
fi

# Install composer dependencies
if [ ! -d 'vendor' ]; then composer install; fi

exec "$@"