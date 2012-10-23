# OmniAuth: Standardized Multi-Provider Authentication

**OmniAuth 1.0 has several breaking changes from version 0.x. You can set
the dependency to `~> 0.3.2` if you do not wish to make the more difficult
upgrade. See [the wiki](https://github.com/intridea/omniauth/wiki/Upgrading-to-1.0)
for more information.**

## An Introduction

OmniAuth is a libary that standardizes multi-provider authentication for
web applications. It was created to be powerful, flexible, and do as
little as possible. Any developer can create **strategies** for OmniAuth
that can authenticate users via disparate systems. OmniAuth strategies
have been created for everything from Facebook to LDAP.

In order to use OmniAuth in your applications, you will need to leverage
one or more strategies. These strategies are generally released
individually as RubyGems, and you can see a [community maintained list](https://github.com/intridea/omniauth/wiki/List-of-Strategies) 
on the wiki for this project.

One strategy, called `Developer`, is included with OmniAuth and provides
a completely unsecure, non-production-usable strategy that directly
prompts a user for authentication information and then passes it
straight through. You can use it as a placeholder when you start
development and easily swap in other strategies later.

## Getting Started

Each OmniAuth strategy is a Rack Middleware. That means that you can use
it the same way that you use any other Rack middleware. For example, to
use the built-in Developer strategy in a Sinatra application I might do
this:

```ruby
require 'sinatra'
require 'omniauth'

class MyApplication < Sinatra::Base
  use Rack::Session
  use OmniAuth::Strategies::Developer
end
```

Because OmniAuth is built for *multi-provider* authentication, I may
want to leave room to run multiple strategies. For this, the built-in
`OmniAuth::Builder` class gives you an easy way to specify multiple
strategies. Note that there is **no difference** between the following
code and using each strategy individually as middleware. This is an
example that you might put into a Rails initializer at
`config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end
```

You should look to the documentation for each provider you use for
specific initialization requirements.

## Integrating OmniAuth Into Your Application

OmniAuth is an extremely low-touch library. It is designed to be a
black box that you can send your application's users into when you need
authentication and then get information back. OmniAuth was intentionally
built not to automatically associate with a User model or make
assumptions about how many authentication methods you might want to use
or what you might want to do with the data once a user has
authenticated. This makes OmniAuth incredibly flexible. To use OmniAuth,
you need only to redirect users to `/auth/:provider`, where `:provider`
is the name of the strategy (for example, `developer` or `twitter`).
From there, OmniAuth will take over and take the user through the
necessary steps to authenticate them with the chosen strategy.

Once the user has authenticated, what do you do next? OmniAuth simply
sets a special hash called the Authentication Hash on the Rack
environment of a request to `/auth/:provider/callback`. This hash
contains as much information about the user as OmniAuth was able to
glean from the utilized strategy. You should set up an endpoint in your
application that matches to the callback URL and then performs whatever
steps are necessary for your application. For example, in a Rails app I
would add a line in my `routes.rb` file like this:

```ruby
match '/auth/:provider/callback', to: 'sessions#create'
```

And I might then have a `SessionsController` with code that looks
something like this:

```ruby
class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    self.current_user = @user
    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
```

The `omniauth.auth` key in the environment hash gives me my
Authentication Hash which will contain information about the just
authenticated user including a unique id, the strategy they just used
for authentication, and personal details such as name and email address
as available. For an in-depth description of what the authentication
hash might contain, see the [Auth Hash Schema wiki page](https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema).

Note that OmniAuth does not perform any actions beyond setting some
environment information on the callback request. It is entirely up to
you how you want to implement the particulars of your application's
authentication flow.

## Resources

The [OmniAuth Wiki](https://github.com/intridea/omniauth/wiki) has
actively maintained in-depth documentation for OmniAuth. It should be
your first stop if you are wondering about a more in-depth look at
OmniAuth, how it works, and how to use it.

## Supported Rubies

OmniAuth is tested under 1.8.7, 1.9.2, 1.9.3, JRuby, Rubinius (1.8
mode), and Ruby Enterprise Edition.

[![CI Build Status](https://secure.travis-ci.org/intridea/omniauth.png)](http://travis-ci.org/intridea/omniauth)


## License

Copyright (c) 2011 Intridea, Inc.

Permission is hereby granted, free of charge, to any person obtaining a 
copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included 
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE.
