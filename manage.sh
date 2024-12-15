# Run to make executable: chmod +x script.sh

LOCAL="$HOME/code/work/all-happenings/wordpress/"
REMOTE="remote-server"
DOMAIN="https://allhappenings.com"

deploy_db(){
	docker compose run --rm wpcli db export /var/backups/backup.sql
	scp $local/db_backups/backup.sql $REMOTE:~/docker/db_backups/backup.sql
	ssh $REMOTE << "EOF"
	cd docker
	docker compose run --rm wpcli db import /var/backups/backup.sql
	docker compose run --rm search-replace 'http://localhost:8000' '$DOMAIN' --skip-columns=guid
EOF
}

deploy_theme(){
	rsync -avz --exclude-from='rsync-exclude' ./ all-happenings:~/docker-wordpress-nginx-mariadb/wordpress/wp-content/themes/AllHappenings-Wordpress-Theme/
}

deploy_content(){
	rsync -avz ./wordpress/wp-content/ $REMOTE:~/docker/wordpress/wp-content/
}

dev_up(){
	docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
}

dev_down(){
	docker compose down --remove-orphans
}

if [ "$1" == "deploydb" ]; then
	deploy_db
elif [ "$1" == "deploytheme" ]; then
	deploy_theme
elif [ "$1" == "deploycontent" ]; then
	deploy_content
elif [ "$1" == "devup" ]; then
	dev_up
elif [ "$1" == "devdown" ]; then
	dev_down
else
	echo "$1"
	echo "Usage: $0 {deploy db | deploy theme | deploy content}"
fi