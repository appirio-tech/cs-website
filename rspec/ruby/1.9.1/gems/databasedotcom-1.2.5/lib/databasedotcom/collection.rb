module Databasedotcom
  # A collection of Sobject or Record objects that holds a single page of results, and understands how to
  # retrieve the next page, if any. Inherits from Array, thus, behaves as an Enumerable.

  class Collection < Array
    attr_reader :total_size, :next_page_url, :previous_page_url, :current_page_url, :client

    # Creates a paginatable collection. You should never need to call this.
    def initialize(client, total_size, next_page_url=nil, previous_page_url=nil, current_page_url=nil) #:nodoc:
      @client = client
      @total_size = total_size
      @next_page_url = next_page_url
      @previous_page_url = previous_page_url
      @current_page_url = current_page_url
    end

    # Does this collection have a next page?
    def next_page?
      !!self.next_page_url
    end

    # Retrieve the next page of this collection.  Returns the new collection, which is an empty collection if no next page exists
    def next_page
      self.next_page? ? @client.next_page(@next_page_url) : Databasedotcom::Collection.new(self.client, 0)
    end

    # Does this collection have a previous page?
    def previous_page?
      !!self.previous_page_url
    end

    # Retrieve the previous page of this collection. Returns the new collection, which is an empty collection if no previous page exists
    def previous_page
      self.previous_page? ? @client.previous_page(@previous_page_url) : Databasedotcom::Collection.new(self.client, 0)
    end
  end
end