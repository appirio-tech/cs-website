web:     bundle exec rails server thin -p $PORT
worker:  env QUEUE=* bundle exec rake resque:work