![](http://defuze.me/images/logo.png)

defuze.me website
=================

This project holds all the source code of the web service/website [defuze.me](http://defuze.me)

It is not very useful to run your own unless you need really custom setup with [defuze.me's desktop application](https://github.com/defuzeme/desktop).

What is it for?
---------------

This website provides:

* Remote control features for defuze.me's desktop application
* Some public pages to introduce the projet
* Online support for desktop application users

How to run it
-------------

It's a pretty standard Rails 3 application, all you have to do is:

1. install `ruby`, `rubygems` and `bundler` if not already done (we use ruby 1.8.7)
2. setting up your `config/database.yml` (follow [this guide](http://guides.rubyonrails.org/getting_started.html#configuring-a-database) if you don't know how)
3. run `$> bundle install` to install all needed gems
4. run `$> bundle exec rake db:recreate` to create & migrate your database
5. run `$> bundle exec thin start` or whatever server you prefer
6. run (optional) `$> ./script/push` to launch the push server (real-time sync)
7. browse to [localhost:3000](http://localhost:3000)

License
-------
This program is free software covered by the [GNU LGPLv3 license](http://defuze.me/en/license)
