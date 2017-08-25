---
comments: true
date: 2017-08-24 20:00:07 +0200
layout: post
title: Deploy a Spring Boot webapp on DigitalOcean
---
I was asked to create a website for a startup company that has created a fire extinguishing training simulator using HTC Vive. Pretty cool, actually. You can see the website at [https://realtraining.no](https://realtraining.no). The requirements were simple; basic company information, a contact-me-form that would trigger an email and some sort of super user editing of the sites content.

Allthough they didn't care about the details of the implementation they had suggested to use Wordpress. My reply to this was that I would help them create the website but not with Wordpress. It's not that Wordpress wouldn't cut it, but I strongly dislike all the extra hassle you have to deal with to keep the site secure and also I had no interest to invest any time into learning a new framework.


## Finally, I can use Heroku! Or...?

At first I went for Heroku which I think is great, but then I got into trouble when configuring the DNS settings for the domain. Heroku doesn't have a static IP address (it will give you something like yoursite.herokuapp.com). The problem with this is that you cannot add a CNAME record on the root domain name. The solution is to use a domain registrar that supports ALIAS records. However, I was unable to find a domain registrar that has ALIAS support that also had Norwegian \*.no domain names. I guess the reason is that \*.no domain names are required to use [DNSSEC](https://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions). At this point I already had the site up and running on the Heroku platform, so I had to go with the DigitalOcean solution instead. More work, yes, but I also learned a lot about setting up a Linux server, deployment routines, etc.


## The stack

### Backend

As the title says, I ended up choosing [Spring Boot](https://projects.spring.io/spring-boot) as the back end. The main arguments for this is that I already know Java, and also that I would end up with a single jar with an embedded web server (Jetty), so the deployment routine would be really easy to create.

For storage I chose to go with a [PostgreSQL](https://www.postgresql.org) database. I also used Flyway for database migration, which I think is great even for small applications.

The site is rendering templates server side with [Handlebars.java](https://github.com/jknack/handlebars.java). When a superuser is logged in it will be easy to render the extra stuff needed for editing the content. For this I'm using the [MediumEditor](https://github.com/yabwe/medium-editor), which is a popular inline editor tool and it's supersweet.

### Frontend

Not much to say here, I'm using the popular choice Bootstrap and jQuery. For laziness I'm using [Intercooler.js](http://intercoolerjs.org) to make AJAX calls simply with HTML attributes.


## Setting up the web server

### NGINX

I [created a Ubuntu server on DigitalOcean](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04), configured passwordless SSH login, a firewall and an NGINX web server to act as a reverse proxy web server. DigitalOcean has a lot of excellent guides on how to setup stuff like this. I also made sure that HTTP traffic get redirected to HTTPS. Here is what my /etc/nginx/sites-enabled/realtraining.no looks like:
```nginx
server {
    listen 443 ssl;
    server_name realtraining.no www.realtraining.no;
    ssl_certificate /etc/letsencrypt/live/realtraining.no/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/realtraining.n/privkey.pem;
    ssl_stapling on;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security "max-age=31536000";
    
    location /admin {
        auth_basic "Authentication required";
        auth_basic_user_file /etc/nginx/.htpasswd;
        proxy_pass http://localhost:8080/admin;
    }
    
    location / {
        proxy_pass http://localhost:8080;
    }
}
server {
    listen 80;
    server_name realtraining.no www.realtraining.no;
    rewrite ^ https://$host$request_uri? permanent;
}
```
Note: Whenever you change your NGINX config, run ```sudo nginx -t``` before you do ```sudo service nginx reload``` just to make sure you don't break stuff.

### Test environment

I also have a test environment available from the test.realtraining.no subdomain, and all configuration related to this site is so similar to the production site that I'm not going to put it here. Only difference is that the whole site is protected with basic auth, not just the /admin uri.

### Let's encrypt

For SSL I used [LetsEncrypt](https://letsencrypt.org) which offers free certificates and it was really easy to setup as well:
```bash
sudo apt-get install letsencrypt
sudo service nginx stop
sudo letsencrypt certonly --standalone -d realtraining.no -d www.realtraining.no
sudo service nginx start
```
Whenever the certificate is about to expire, you will get a warning sent to your email address. Or, you can have them automatically renew them selves with crontab. I have tried but didn't get it right for some reason.

### Create a .htpasswd file for basic auth

```bash
sudo sh -c "echo -n 'username:' >> /etc/nginx/.htpasswd"
sudo sh -c "openssl passwd -apr1 >> /etc/nginx/.htpasswd"
```

### Spring Boot and Systemd

To run the application on the server I created a systemd service. Here is my /etc/systemd/system/website-prod.service:
```ini
[Unit]
Description=Spring boot application
After=syslog.target

[Service]
User=webapp
ExecStart=/usr/bin/java -Xmx256m -Djava.security.egd=file:/dev/./urandom -Djdbc.database.url=jdbc:postgresql:prod?user=dbuser&amp;password=xxx -jar /var/website-prod/realtrainingweb.jar --server.port=8080
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
```
When you create a service like this you also have to enable it by ```systemctl enable website-prod.service```
Again, I have a similar service website-test.service for the test environment, which just uses a different database and a different jar file.

### Push and deploy

I have created a user **git** on the server, and in it's home directory, I created a git repository by doing ```git init --bare```. Then from my computer I'm able to clone the repo from git@realtraining.no:~/website.git. Whenever I push a commit, I can SSH into the server and run a deployment script that looks like this:
```bash
#!/bin/bash
echo "Creating a workspace folder ~/build/prod..."
rm -r ~/build/prod
mkdir -p ~/build/prod
cd ~/build/prod

echo "Cloning repository from /home/git/website.git"
git clone /home/git/website.git
cd website

echo "Invoke Maven build"
mvn -q install

echo "Stoping service website-prod"
sudo service website-prod stop

echo "Copying new jar file to /var/website-prod/realtrainingweb.jar..."
sudo cp target/*.jar /var/website-prod/realtrainingweb.jar

echo "Starting service website-prod..."
sudo service website-prod start
```
Nice, eh? Of course I could write a post receive hook that would automatically trigger the correct deployment script from a git push command based on the current branch, but right now it works for me as it is. You might also notice that this causes some downtime during deployment which of course could be avoided but I didn't spend time on that since it wasn't a requirement.

### Copy data from test to production

Whenever I'm happy with the changes I have done in the test environment I sometimes whish to blindly copy the content from one table in the test environment's database into the production database. Since they are both on the same server, this one's pretty easy:
```bash
sudo -u dbuser pg_dump --clean -t page test | sudo -u dbuser psql prod
```
Here the table is called page, and the clean flag means it will delete the table rows before inserting.

### Search the logs

Now that the java application is running as a service, you can access the log with ```journalctl -f -u website-prod```. If you want to pipe the log into grep, you can do ```sudo cat /var/log/syslog | tr -d '\000' | grep 'ERROR'```.
 
 
 
Hope you found this summary useful, and please comment below if you have any comments or questions. Cheers! :-)