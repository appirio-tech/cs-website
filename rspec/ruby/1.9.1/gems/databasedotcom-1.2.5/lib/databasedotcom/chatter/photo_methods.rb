module Databasedotcom
  module Chatter
    # Defines methods for entities that can have photos i.e. Users, Groups.
    module PhotoMethods
      def self.included(base)
        base.extend ClassMethods
      end

      # Defines class methods for resources that can have photos.
      module ClassMethods
        # Returns a Hash with urls for the small and large versions of the photo for a resource.
        def photo(client, resource_id)
          url = "/services/data/v#{client.version}/chatter/#{self.resource_name}/#{resource_id}/photo"
          result = client.http_get(url)
          JSON.parse(result.body)
        end

        # Uploads a photo for a resource with id _resource_id_.
        #
        #    User.upload_photo(@client, "me", File.open("SomePicture.png"), "image/png")
        def upload_photo(client, resource_id, io, file_type)
          url = "/services/data/v#{client.version}/chatter/#{self.resource_name}/#{resource_id}/photo"
          result = client.http_multipart_post(url, {"fileUpload" => UploadIO.new(io, file_type)})
          JSON.parse(result.body)
        end

        # Deletes the photo for the resource with id _resource_id_.
        def delete_photo(client, resource_id)
          client.http_delete "/services/data/v#{client.version}/chatter/#{self.resource_name}/#{resource_id}/photo"
        end
      end

      # Returns a Hash with urls for the small and large versions of the photo for this resource.
      #
      #  User.find(@client, "me").photo  #=>  {"smallPhotoUrl"=>"/small/photo/url", "largePhotoUrl"=>"/large/photo/url"}
      def photo
        self.raw_hash["photo"]
      end

      # Uploads a photo for this resource.
      #
      #    me = User.find(@client)
      #    me.upload_photo(File.open("SomePicture.png"), "image/png")
      def upload_photo(io, file_type)
        self.class.upload_photo(self.client, self.id, io, file_type)
      end

      # Deletes the photo for this resource.
      def delete_photo
        self.class.delete_photo(self.client, self.id)
        photo
      end
    end
  end
end