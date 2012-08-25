web:     bundle exec rails server thin -p $PORT
worker:  env QUEUE=* bundle exec rake resque:work
quiz_worker: env QUEUE=quickquiz_answer_queue bundle exec rake resque:work 