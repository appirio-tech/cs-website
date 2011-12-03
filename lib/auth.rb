class AuthSession
    def initialize (authhash, provider)
        @authhash = Hash.new
        # filling up our uniform hash based on the provider
        if provider == 'facebook'
            authhash['extra']['user_hash']['email'] ? @authhash[:email] =  authhash['extra']['user_hash']['email'] : @authhash[:email] = ''
            authhash['extra']['user_hash']['name'] ? @authhash[:name] =  authhash['extra']['user_hash']['name'] : @authhash[:name] = ''
            authhash['extra']['user_hash']['id'] ? @authhash[:uid] =  authhash['extra']['user_hash']['id'].to_s : @authhash[:uid] = ''
            authhash['extra']['user_hash']['username'] ? @authhash[:username] =  authhash['extra']['user_hash']['username'] : @authhash[:username] = ''
            authhash['provider'] ? @authhash[:provider] = authhash['provider'] : @authhash[:provider] = ''
        elsif provider == 'github'
            authhash['info']['email'] ? @authhash[:email] =  authhash['info']['email'] : @authhash[:email] = ''
            authhash['info']['name'] ? @authhash[:name] =  authhash['info']['name'] : @authhash[:name] = ''
            authhash['uid'] ? @authhash[:uid] =  authhash['uid'].to_s : @authhash[:uid] = ''
            authhash['provider'] ? @authhash[:provider] =  authhash['provider'] : @authhash[:provider] = '' 
            authhash['info']['nickname'] ? @authhash[:username] =  authhash['info']['nickname'] : @authhash[:username] = '' 
        elsif ['google','twitter','linked_in','salesforce'].index(provider) != nil
            authhash['info']['email'] ? @authhash[:email] =  authhash['info']['email'] : @authhash[:email] = ''
            authhash['info']['name'] ? @authhash[:name] =  authhash['info']['name'] : @authhash[:name] = ''
            authhash['info']['nickname'] ? @authhash[:username] =  authhash['info']['nickname'] : @authhash[:username] = ''
            authhash['uid'] ? @authhash[:uid] = authhash['uid'].to_s : @authhash[:uid] = ''
            authhash['provider'] ? @authhash[:provider] = authhash['provider'] : @authhash[:provider] = ''
        end
    end 
    def get_hash
        @authhash
    end
end
