CREATE DATABASE redmine CHARACTER SET utf8;
CREATE USER 'redmine'@'localhost' IDENTIFIED BY 'red@abc123';
GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'localhost';

