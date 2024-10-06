.PHONY: up
up:
	@cd joey-blog && bundle exec jekyll serve 


.PHONY: deps 
deps:
	@cd joey-blog && bundle install

