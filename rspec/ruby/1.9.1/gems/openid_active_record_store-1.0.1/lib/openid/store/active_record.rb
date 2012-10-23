require 'openid/util'
require 'openid/store/interface'
require 'openid/association'
require 'openssl'

module OpenID
  module Store
    class ActiveRecord < Interface

      # Put a Association object into storage.
      # When implementing a store, don't assume that there are any limitations
      # on the character set of the server_url.  In particular, expect to see
      # unescaped non-url-safe characters in the server_url field.
      def store_association(server_url, association)
        OpenidAssociation.create!(
          :server_url => server_url,
          :target     => targetize(server_url),
          :handle     => association.handle,
          :secret     => association.secret,
          :issued_at  => association.issued,
          :lifetime   => association.lifetime,
          :assoc_type => association.assoc_type
        )
        true
      end

      # Returns a Association object from storage that matches
      # the server_url.  Returns nil if no such association is found or if
      # the one matching association is expired. (Is allowed to GC expired
      # associations when found.)
      def get_association(server_url, handle=nil)
        oas = OpenidAssociation.find_all_by_target targetize(server_url)
        return nil if oas.empty?
        unless handle.nil?
          return nil unless oas.collect(&:handle).include? handle
          return build_association(oas.find { |oa| oa.handle == handle })
        end
        oas.sort_by(&:issued_at).collect { |oa| build_association(oa) }.last
      end

      # If there is a matching association, remove it from the store and
      # return true, otherwise return false.
      def remove_association(server_url, handle)
        oas = OpenidAssociation.find_all_by_target targetize(server_url)
        return false unless oas.collect(&:handle).include? handle
        oas.find_all { |oa| oa.handle == handle }.each(&:delete).size > 0
      end

      # Return true if the nonce has not been used before, and store it
      # for a while to make sure someone doesn't try to use the same value
      # again.  Return false if the nonce has already been used or if the
      # timestamp is not current.
      # You can use OpenID::Store::Nonce::SKEW for your timestamp window.
      # server_url: URL of the server from which the nonce originated
      # timestamp: time the nonce was created in seconds since unix epoch
      # salt: A random string that makes two nonces issued by a server in
      #       the same second unique
      def use_nonce(server_url, timestamp, salt)
        return false if (timestamp - Time.now.to_i).abs > Nonce.skew
        params = [timestamp, salt, targetize(server_url)]
        return false if OpenidNonce.exists_by_target?(*params)
        return create_nonce(server_url, timestamp, salt)
      end

      # Remove expired nonces and associations from the store
      # Not called during normal library operation, this method is for store
      # admins to keep their storage from filling up with expired data
      def cleanup
        cleanup_nonces
        cleanup_associations
      end

      # Remove expired associations from the store
      # Not called during normal library operation, this method is for store
      # admins to keep their storage from filling up with expired data
      def cleanup_associations
        oas = OpenidAssociation.all.collect do |oa|
          oa.id if build_association(oa).expires_in == 0
        end
        OpenidAssociation.delete oas.compact
      end

      # Remove expired nonces from the store
      # Discards any nonce that is old enough that it wouldn't pass use_nonce
      # Not called during normal library operation, this method is for store
      # admins to keep their storage from filling up with expired data
      def cleanup_nonces
        now = Time.now.to_i
        nonces = OpenidNonce.all
        ids = nonces.collect { |n| n.id if (n.timestamp - now).abs > Nonce.skew }
        OpenidNonce.delete ids.compact
      end

      private

      def targetize(server_url)
        OpenSSL::Digest::MD5.hexdigest(server_url)
      end

      def build_association(open_id_association)
        OpenID::Association.new(
          open_id_association.handle,
          open_id_association.secret,
          open_id_association.issued_at,
          open_id_association.lifetime,
          open_id_association.assoc_type
        )
      end

      def create_nonce(server_url, timestamp, salt)
        OpenidNonce.create!(
          :target     => targetize(server_url),
          :server_url => server_url,
          :timestamp  => timestamp
        )
        true
      end

    end
  end
end
