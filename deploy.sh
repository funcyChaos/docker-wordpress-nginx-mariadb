REMOTE="porch-fest-do"
DOMAIN="https://towerporchfest.org"

docker compose run --rm wpcli db export /var/backups/backup.sql
scp ./db_backups/backup.sql $REMOTE:~/docker/db_backups/backup.sql
rsync -avz ./wordpress/wp-content/ $REMOTE:~/docker/wordpress/wp-content/

ssh $REMOTE << "EOF"
cd docker
docker compose run --rm wpcli db import /var/backups/backup.sql
docker compose run --rm search-replace 'http://localhost:8000' '$DOMAIN' --skip-columns=guid
EOF