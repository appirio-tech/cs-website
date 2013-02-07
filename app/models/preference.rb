class Preference

	def initialize(preferences)
		self.on_private_message = get_pref(preferences, 'private message')
		self.on_reviewer_has_question = get_pref(preferences, 'not implemented')
		self.on_registered_challenge_near_expiry = get_pref(preferences, 'not implemented')
		self.on_registered_challenge_extenstion_granted = get_pref(preferences, 'not implemented')
		self.on_challenge_extension_granted = get_pref(preferences, 'not implemented')
		self.on_challenge_results_final = get_pref(preferences, 'not implemented')
		self.on_cloud_spokes_newsletter_sent_out = get_pref(preferences, 'newsletter')
		# get any categories
		self.categories = get_categories(preferences)
	end	

	def get_categories(preferences)
		categories = {}
		preferences.each do |p|
			categories.merge!({ p['event'].gsub!('Category|','') => p['notification_method']}) if p['event'].include?('Category|')
		end
		categories
	end

	def get_pref(preferences, event_type)
		preferences.select {|f| f['event'].downcase == event_type }.first['notification_method']
	rescue
		''
	end

  # Overrides the attr_accesssor class method so we are able to capture and
  # then save the defined fields as column_names
  def self.attr_accessor(*vars)
    @column_names ||= []
    @column_names.concat( vars )
    super
  end

  # Returns the previously defined attr_accessor fields
  def self.column_names
    @column_names
  end

  # The list of possible notification options. Can be changed so that the source
  # is from an API call or database storage (or even a configuration file)
  # This is used by the check_box_tag helper methods
  def self.notification_options
    ['Email', 'Site']
  end

  # Each attribute is an array of either ['email'], ['popup'], or ['email', 'popup']
  # We use an array to give us flexibility when we need to add other notification types
  # (e.g. 'sms' or 'private_message')
  attr_accessor :on_private_message, # Notify me when a member sends me a private message.
    :on_reviewer_has_question, # Notify me when a reviewer has a question about my submission.
    :on_registered_challenge_near_expiry, # Notify me when a challenge I am registered for ends in the next 24 hours.
    :on_registered_challenge_extenstion_granted, # Notify me when a challenge extension is requested for a challenge I am registered for.
    :on_challenge_extension_granted, # Notify me when a challenge extension is granted.
    :on_challenge_results_final, # Notify me when a challenge results are final.
    :on_cloud_spokes_newsletter_sent_out # Notify me when the CloudSpokes newsletter is sent out.

  # Note that the printable text for these are available as a translation file in config/locales
  # (I work in a multi-language company and I receive translation requests all the time :P)

  # Array of category names and their corresponding notification type
  # e.g. ["Salesforce.com" => ['email'], "Google" => ['email', 'popup']]
  def categories
    @categories ||= Hashie::Mash.new
  end

  def categories=(val)
    @categories = Hashie::Mash.new(val)
  end

  # pretty print
  def to_s
    static_fields = Preference.column_names.map do |name|
      "#{name} => #{self.send(name) || []}"
    end.join("\n")
    dynamic_fields = categories.map do |name|
      "#{name.first} => #{self.categories[name.first]}"
    end.join("\n")
    [static_fields, dynamic_fields].join("\n")
  end

end