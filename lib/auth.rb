class AuthSession
    def initialize (authhash, provider)
      @authhash = Hash.new
      # filling up our uniform hash based on the provider
      authhash['info']['email'] ? @authhash[:email] =  authhash['info']['email'] : @authhash[:email] = ''
      authhash['info']['name'] ? @authhash[:name] =  authhash['info']['name'] : @authhash[:name] = ''
      authhash['info']['nickname'] ? @authhash[:username] =  authhash['info']['nickname'] : @authhash[:username] = ''
      authhash['uid'] ? @authhash[:uid] = authhash['uid'].to_s : @authhash[:uid] = ''
      authhash['provider'] ? @authhash[:provider] = authhash['provider'] : @authhash[:provider] = ''
          
      # set provider to google if open_id returns google uid
      @authhash[:provider] = 'google' if authhash['uid'].to_s.include?('google.com/accounts')
    end

    def get_hash
        @authhash
    end
end
