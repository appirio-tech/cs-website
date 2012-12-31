class MessageBox

	attr_reader :unread, :type

	def initialize(membername, type, messages)
		@membername = membername
		@type = type
		@unread = 0
		process_messages(messages)
	end

	def messages
		@processed_messages
	end

	def to_s
		"#{@processed_messages.count.to_s} #{@type} messages for #{@membername}. #{@unread} unread." 
	end

	private

		def process_messages(messages)
			@processed_messages = []
			messages.each do |m|
				new_message = {}
				new_message['id'] = m['id']
				new_message['datetime'] = m['createddate'] 
				new_message['subject'] = m['subject']
				new_message['replies'] = m['replies'].to_i

				if @membername.eql?(m['to__r']['name'])
					new_message['display_user'] = m['from__r']['name']
					new_message['profile_pic'] = m['from__r']['profile_pic']
				elsif @membername.eql?(m['from__r']['name'])
					new_message['display_user'] = m['to__r']['name']
					new_message['profile_pic'] = m['to__r']['profile_pic']
				end	

				if @type.eql?(:inbox)
					if @membername.eql?(m['to__r']['name'])
						new_message['status'] = m['status_to'].downcase
					else
						new_message['status'] = m['status_from'].downcase
					end
					@unread = @unread + 1 if new_message['status'].eql?('unread')
				elsif @type.eql?(:sent)
					# if we are look in the sent tab, always show the recipient's status
					new_message['status'] = m['status_to'].downcase
				end			
				new_message['icon'] = new_message['status'].eql?('unread') ? 'new_msg.jpg' : 'read_message.jpg'
				@processed_messages << new_message
			end
		end

end