web:     bundle exec rails server mongrel -p $PORT
worker:  QUEUE=* bundle exec rake resque:work
quiz_worker: QUEUE=quickquiz_answer_queue bundle exec rake resque:work 