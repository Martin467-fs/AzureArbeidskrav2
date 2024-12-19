#!/bin/bash

# Variables
WEB_SERVER_IP="10.0.0.5"
DB_NAME="ansatte"
username="python" # Bytt til et passende brukernavn (Se READMS)
password="passord" # Bytt til et passende passord (Se README)

sudo sed -i "s/^bind-address\s*=.*$/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl restart mariadb

# Secure installation
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '';"
sudo mysql -e "CREATE USER '${username}'@'10.0.0.5' IDENTIFIED BY '${password}';"
sudo mysql -e "CREATE USER '${username}'@'localhost' IDENTIFIED BY '${password}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${username}'@'10.0.0.5' IDENTIFIED BY '${password}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${username}'@'localhost' IDENTIFIED BY '${password}';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Create database and table
sudo mysql -e "CREATE DATABASE ${DB_NAME};"
sudo mysql -e "USE ${DB_NAME}; CREATE TABLE employees (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100), position VARCHAR(100), salary DECIMAL(10,2));"

# Insert sample data
sudo mysql -e "USE ${DB_NAME}; INSERT INTO employees (name, position, salary) VALUES ('Martin', 'Engineer', 75000), ('Dan', 'Manager', 85000), ('Havard', 'Janitor', 76000), ('Michael', 'Director', 95000);"