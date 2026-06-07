#!/bin/bash

# RDS Connection Variables
export RDSHOST="dwp-platform-nonprod.ch8cowcymvme.eu-west-1.rds.amazonaws.com"
export dbname="blogdb"
export username="blogdbadmin"
export PGPASSWORD="${PGPASSWORD:-}"  # Set password via environment variable

# Execute SQL commands on remote RDS server
psql -h "$RDSHOST" -d "$dbname" -U "$username" << 'EOF'

-- Create dev environment
CREATE USER devuser WITH ENCRYPTED PASSWORD 'devuser';
CREATE DATABASE devblogdb;
ALTER DATABASE devblogdb OWNER TO devuser;

-- Create QA environment
CREATE USER qauser WITH ENCRYPTED PASSWORD 'qauser';
CREATE DATABASE qablogdb;
ALTER DATABASE qablogdb OWNER TO qauser;

-- Create stage environment
CREATE USER stageuser WITH ENCRYPTED PASSWORD 'stageuser';
CREATE DATABASE stageblogdb;
ALTER DATABASE stageblogdb OWNER TO stageuser;

EOF

echo "Database users and databases created successfully!"

