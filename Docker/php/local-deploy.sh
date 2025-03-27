#!/bin/bash

cd /var/www/html || exit

# Generate the .env.local file
if [ ! -f '.env.local' ]; then

  cat <<EOF > .env.local
APP_ENV=dev
APP_SECRET=$(openssl rand -base64 32)
APP_DEBUG=1
URL=${URL}
DATABASE_URL="mysql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}"
MAILER_DSN=smtp://maildev:1025
EOF
fi

# Install composer dependencies
if [ ! -d 'vendor' ]; then composer install; fi

# Install assets
if [ -f 'importmap.php' ]; then
  if [ ! -d 'public/bundles' ]; then php bin/console asset:install; fi

  if [ ! -d 'public/assets' ]; then php bin/console asset-map:compile; fi
fi

exec "$@"
