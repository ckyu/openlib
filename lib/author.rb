module Openlib
  class Author
    attr_accessor :name, :url

    def initialize(name, url)
      self.name = name
      self.url = "#{Openlib::API_URL}/author/#{url}"
    end

    def to_s
      "#{self.name} (#{self.url})"
    end

  end
end