---
title: Deploy a Spring Boot webapp on DigitalOcean
layout: post
date: 2017-08-24 00:00:00 +0000
comments: true
---


I was asked to create a website for a family member's company that should display basic company information, it should have a contact me form that would trigger an email and they also wanted to login and edit the content themselves.

Allthough they didn't care about the details of the implementation they had suggested to use Wordpress. My reply to this was that I would help them create the website but not with Wordpress. It's not that Wordpress wouldn't cut it, but I strongly dislike all the extra hassle you have to deal with to keep the site secure and also I had no interest to invest any time into learning a new framework.

## Why not Heroku?

At first I went for Heroku which I think is great, but then I got into trouble when configuring the DNS settings for the domain. Heroku doesn't have a static ip address (it will give you something like yoursite.herokuapp.com), so it means you have to use the CNAME record for the apex domain. This is bad practise, and you won't be able to map www subdomain either. The solution is to use a domain registrar that supports ALIAS records. However, I was unable to find a domain registrar that has ALIAS support that also had norwegian *.no domain names. At this point I already had the site up and running on the Heroku platform, so I had to go with the DigitalOcean solution instead. More work, yes, but I also learned a lot about setting up a linux server, deployment routines, etc.

## The stack

### Backend

As the title says, I ended up choosing Spring Boot as the backend. The main arguments for this is that I already know Java, and that I would end up with a single jar with an embedded web server (Jetty), so the deploymet routine would be really easy to setup.

For storage I chose to go with a PostgreSQL database. I also used Flyway for database migration, which I think is great even for small applications.

The site is rendering templates server side with [Handlebars.java](https://github.com/jknack/handlebars.java). When a superuser is logged in it will be easy to render the extra stuff needed for editing the content. For this I'm using the [MediumEditor](https://github.com/yabwe/medium-editor), which is a popular inline editor tool and it's supersweet.

### Frontend

I always use Bootstrap in my projects because I'm not an css expert. I'm also using jQuery.

## The web server

I created a Ubuntu server on DigitalOcean, and set up a NGINX web server to act as a reverse proxy web server

## Deployment

The code is of course stored in a git repo hosted on the Ubuntu server