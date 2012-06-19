require 'rubygems'
require 'active_support'
require 'oauth'
require 'oauth/client/net_http'
require 'erb'

#
# Helper module for integrating Get Satisfaction's FastPass single-sign-on service into a Ruby web 
# app. Use #url to create a signed FastPass URL, and #script to generate the JS-based integration.
#
module FastPass
  extend ERB::Util
  
  def self.domain
    @domain || "getsatisfaction.com"
  end
  
  def self.domain=(val)
    @domain = val
  end
  
  #
  # Generates a FastPass URL with the given +email+, +name+, and +uid+ signed with the provided
  # consumer +key+ and +secret+. The +key+ and +secret+ should match those provided in the company
  # admin interface.
  #
  def self.url(key, secret, email, name, uid, secure=false, additional_fields={})
    consumer = OAuth::Consumer.new(key, secret)
    uri = URI.parse(secure ? "https://#{domain}/fastpass" : "http://#{domain}/fastpass")
    params = additional_fields.merge(:email => email, :name => name, :uid => uid)
    
    uri.query = params.to_query
    
    http      = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"
    request   = Net::HTTP::Get.new(uri.request_uri)
    request.oauth!(http, consumer, nil, :scheme => 'query_string')
    
    signature = request.oauth_helper.signature
    #re-apply params with signature to the uri
    query = params.merge(request.oauth_helper.oauth_parameters).merge("oauth_signature" => signature)
    uri.query = query.to_query
    return uri.to_s
  end
  
  #
  # Generates a FastPass IMG tag. This integration method is likely to be deprecated, unless strong
  # use cases are presented. Be warned.
  #
  def self.image(*args)
    url = url(*args)
    %Q{<img src="#{h url}" alt="" />}
  end
  
  #
  # Generates a FastPass SCRIPT tag. The script will automatically rewrite all GetSatisfaction
  # URLs to include a 'fastpass' query parameter with a signed fastpass URL.
  #
  def self.script(key, secret, email, name, uid, secure=false, additional_fields={})
    url = url(key, secret, email, name, uid, secure, additional_fields)
    
    <<-EOS
    <script type="text/javascript">
      var GSFN;
      if(GSFN == undefined) { GSFN = {}; }

      (function(){
        add_js = function(jsid, url) {
          var head = document.getElementsByTagName("head")[0];
          script = document.createElement('script');
          script.id = jsid;
          script.type = 'text/javascript';
          script.src = url;
          head.appendChild(script);
        }
        add_js("fastpass_common", document.location.protocol + "//#{domain}/javascripts/fastpass.js");

        if(window.onload) { var old_load = window.onload; }
        window.onload = function() {
          if(old_load) old_load();
          add_js("fastpass", #{url.to_json});
        }
      })()

    </script>
    EOS
  end
end