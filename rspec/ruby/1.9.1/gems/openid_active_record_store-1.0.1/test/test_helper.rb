require 'test/unit'
require 'rails'
require 'openid_active_record_store'
require 'active_record'

db = {
  :adapter  => :mysql2,
  :database => 'openid_active_record_store'
}

# XXX  yes, there are better ways. patches please!

system "echo 'drop   database #{db[:database]};' | mysql5 -uroot" rescue nil
system "echo 'create database #{db[:database]};' | mysql5 -uroot"

ActiveRecord::Base.establish_connection db

Dir['db/migrate/*.rb'].each do |migration|
  require migration
  Object.const_get(File.basename(migration, '.rb').camelize).up
end

Dir['app/models/*.rb'].each do |model|
  require File.expand_path(model)
end