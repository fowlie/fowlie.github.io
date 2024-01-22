install:
	sudo apt-get install ruby-dev
	sudo gem install jekyll bundler
	bundle install

run:
	bundle exec jekyll serve --baseurl="" 2>&1 &
	sleep 2 && open http://127.0.0.1:4000

stop:
	ps aux | grep jekyll | awk '{print $$2}' | head -1 | xargs kill -9
