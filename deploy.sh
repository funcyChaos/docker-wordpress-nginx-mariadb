#!/bin/bash

# # Set variables
# LOCAL_DB_BACKUP="./local/backup.sql"        # Relative path on your local machine
# REMOTE_DB_PATH="/path/to/remote/backup.sql" # Absolute path on the remote server
# REMOTE_WP_CONTENT="/path/to/remote/wp-content"  # Absolute path on the remote server
# LOCAL_WP_CONTENT="./local/wp-content"       # Relative path on your local machine
# CONTAINER_NAME="wordpress"  # Name of the container
# REMOTE_CONTAINER_NAME="wordpress"  # Remote container name (ensure it's the same name)


### Testing Cause Newb ###
# REMOTE="tech-garage"
REMOTE="knotty"

# docker-compose run --rm wpcli db export /var/www/html/local/backup.sql

ssh $REMOTE "cd docker-wordpress-nginx-mariadb && docker-compose run --rm wpcli db export /var/backups/backup.sql"

# scp ./wordpress/local/backup.sql $REMOTE:~/

# Step 1: Export the local WordPress database using WP-CLI (from local Docker container)
# docker-compose exec $CONTAINER_NAME wp db export /var/www/html/$LOCAL_DB_BACKUP

# Step 2: Copy the database backup from the container to the local machine using docker cp
# docker cp $(docker-compose ps -q $CONTAINER_NAME):/var/www/html/$LOCAL_DB_BACKUP ./local/$LOCAL_DB_BACKUP



# # Step 3: Copy the database backup to the remote server using scp (single file)
# scp ./local/$LOCAL_DB_BACKUP user@your-server:$REMOTE_DB_PATH

# # Step 4: Copy the database backup into the remote WordPress container using docker cp
# ssh user@your-server "docker cp $REMOTE_DB_PATH $(docker-compose ps -q $REMOTE_CONTAINER_NAME):/var/www/html/$LOCAL_DB_BACKUP"

# # Step 5: Sync the entire wp-content directory to the remote server using rsync (directories)
# rsync -avz $LOCAL_WP_CONTENT/ user@your-server:$REMOTE_WP_CONTENT

# # Step 6: SSH into the remote server and import the database using WP-CLI in the Docker container
# ssh user@your-server "docker-compose exec $REMOTE_CONTAINER_NAME wp db import /var/www/html/$LOCAL_DB_BACKUP"

# # Step 7: Update URLs in the database (if needed) using WP-CLI in the Docker container (remote server)
# ssh user@your-server "docker-compose exec $REMOTE_CONTAINER_NAME wp search-replace 'http://localhost' 'https://yourdomain.com' --skip-columns=guid"

# # Step 8: Clear cache (optional) using WP-CLI in the Docker container (remote server)
# ssh user@your-server "docker-compose exec $REMOTE_CONTAINER_NAME wp cache flush"

# # Step 9: Clean up local backup file (optional)
# rm ./local/$LOCAL_DB_BACKUP

# # Step 10: Clean up remote backup file (optional)
# ssh user@your-server "rm $REMOTE_DB_PATH"
