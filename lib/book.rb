require_relative './author.rb'

module Openlib
  class Book
    attr_accessor :url
    attr_accessor :title
    attr_accessor :authors
    attr_accessor :thumbnails
    attr_accessor :covers
    attr_accessor :subjects
    attr_accessor :publishers
    attr_accessor :publish_place
    attr_accessor :publish_date
    attr_accessor :classifications
    attr_accessor :goodreads_id
    attr_accessor :librarything_id
    attr_accessor :language

    def initialize(json)
      self.url = "#{Openlib::API_URL}#{json["key"]}"
      self.title = json["title"]
      self.authors =
        begin
          json["author_name"].zip(json["author_key"]).map do |name, url| 
            Author.new(name, url)
          end
        rescue
          []
        end

      self.covers =
        if json["cover_i"].is_a?(Array)
          json["cover_i"].map { |img| "http://covers.openlibrary.org/w/id/#{img}-L.jpg" }
        elsif json["cover_i"].is_a?(Integer)
          "http://covers.openlibrary.org/w/id/#{json["cover_i"]}-L.jpg"
        else
          []
        end

      self.subjects = json["subject"]
      self.publishers = json["publishers"]
      self.publish_place = json["publish_place"]
      self.publish_date = json["publish_date"]
      self.goodreads_id = json["id_goodreads"]
      self.librarything_id = json["id_librarything"]
      self.language = json["language"]

      return self
    end

    def to_s
      authors = self.authors.join(", ")
      "Title: #{self.title}\nAuthor(s): #{authors}\n"
    end

  end
end