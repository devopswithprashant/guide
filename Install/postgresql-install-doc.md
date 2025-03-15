
# Install Postgresql in Ubuntu


You can install PostgreSQL on Ubuntu by following these steps:

Step 1: Update System Packages

sh`sudo apt update && sudo apt upgrade -y`

Step 2: Install PostgreSQL

sudo apt install postgresql postgresql-contrib -y

Step 3: Start and Enable PostgreSQL Service

sudo systemctl start postgresql
sudo systemctl enable postgresql

Step 4: Verify Installation

Check if PostgreSQL is running:

sudo systemctl status postgresql

Step 5: Switch to PostgreSQL User and Access PostgreSQL Shell

PostgreSQL creates a default user (postgres). Switch to it:

sudo -i -u postgres

Then access the PostgreSQL shell:

psql

Step 6: Set a Password for the PostgreSQL User

Inside the psql prompt, run:

ALTER USER postgres PASSWORD 'your_secure_password';

Exit the psql prompt:

\q

Step 7: Allow Remote Connections (Optional)

If you need to allow remote access, edit the configuration files:
	1.	Edit postgresql.conf:

sudo nano /etc/postgresql/$(ls /etc/postgresql)/main/postgresql.conf

Find listen_addresses and set:

listen_addresses = '*'

Save and exit.

	2.	Edit pg_hba.conf:

sudo nano /etc/postgresql/$(ls /etc/postgresql)/main/pg_hba.conf

Add this line to allow remote access:

host    all             all             0.0.0.0/0               md5


	3.	Restart PostgreSQL:

sudo systemctl restart postgresql



Step 8: Enable PostgreSQL on Firewall (If Required)

sudo ufw allow 5432/tcp
sudo ufw reload

Now, PostgreSQL should be up and running on your Ubuntu system! 🚀
