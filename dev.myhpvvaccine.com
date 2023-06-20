#login to sql root
sudo mysql -u root -p

#create database
CREATE DATABASE childcare;

#add database
CREATE USER 'childcare_user'@'localhost' IDENTIFIED BY 'asbfffccevevn232edddfefdqs22';

#database permisions
GRANT ALL ON childcare.* TO 'childcare_user'@'localhost' WITH GRANT OPTION;

#flushing
FLUSH PRIVILEGES;

#exiting from sql
EXIT;



#change to temp folder
cd /tmp

#download zip
wget https://wordpress.org/latest.tar.gz

#extract zip
unzip archive.zip 

#remove downloaded package
rm -r latest.tar.gz

cd /var/www
mkdir laravel
ls 



#move wordpress cms to required domain folder
sudo mv wordpress /var/www/laravel/dev.myhpvvaccine.com

#add read & write permisions
sudo chown -R www-data:www-data /var/www/laravel/dev.myhpvvaccine.com

#add permissions
sudo chmod -R 755 /var/www/laravel/dev.myhpvvaccine.com




#create virtual config file for domain name (example: visosys.com.conf)

sudo nano /etc/nginx/sites-available/dev.myhpvvaccine.com.conf

			server {
			    listen 80;
			    listen [::]:80;

			    #replace with domain location
			    root /var/www/laravel/dev.myhpvvaccine.com
			    index  index.php index.html index.htm;

			    #replace with domain name
			    server_name  dev.myhpvvaccine.com www.dev.myhpvvaccine.com;

			    client_max_body_size 200M;
			    autoindex off;
			    location / {
			        try_files $uri $uri/ /index.php?$args;
			    }

			    location ~ \.php$ {
			         include snippets/fastcgi-php.conf;
			         fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
			         fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
			         include fastcgi_params;
			    }
			}

#enable v-config to original config
sudo ln -s /etc/nginx/sites-available/dev.myhpvvaccine.com.conf /etc/nginx/sites-enabled/

#test nginx 
nginx -t

#restart nginx 
sudo systemctl restart nginx.service

#install ssl
sudo certbot --nginx -d dev.myhpvvaccine.com 

#check ssl
sudo systemctl status certbot.timer

#check ssl 2
sudo certbot renew --dry-run