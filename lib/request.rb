require_relative './book.rb'

module Openlib
  module Request
    def request(path, params={})
      request_url = "#{Openlib::API_URL}#{path}"
      RestClient.get request_url, { params: params }
    end

    def find_by_isbn(key)
      find("ISBN", key)
    end

    def find_book(type, key)
      type_uri = URI.encode_www_form_component(type)
      key_uri = URI.encode_www_form_component(key)

      book_api = "/api/books"

      response = JSON.parse(request(book_api+"", {format: "json"}))

      Book.new(response)

    end

    def find_author()
    end

    def search(query, limit=10, offset=0)
      if limit > 100 || limit <= 0
        raise ArgumentError, 'limit should be in range (1,100)'
      end

      if offset < 0
        raise ArgumentError, 'offset should be at least 0'
      end

      query = format_query(query)

      if offset + limit > 100 
        startPage = offset >= 100 ? (offset/100) + 1 : 1
        endPage = (offset + limit)/100 < 2 ? 2 : (offset + limit)/100 + 1

        response = fetch_multiple(query, startPage, endPage)
      else
        response = JSON.parse(request("/search.json", query))
      end

      offset %= 100
      numFound = response["docs"].count

      # if number of entries found is less than the limit
      if offset + limit > numFound
        limit = numFound - offset
      end

      parsed_response = response["docs"][offset...offset+limit].map { |doc| Book.new(doc) }
      return parsed_response

    end

    private

      def fetch_multiple(query, start, ending)
        response = nil
        (start..ending).each do |page| 
          new_query = query.merge({ page: page })

          if response == nil
            response = JSON.parse(request("/search.json", new_query))
          else
            temp = JSON.parse(request("/search.json", new_query))
            response["docs"] += temp["docs"]
          end

        end
        return response
      end

      def format_query(query)
        return query.is_a?(String) ? { q: query } : query
      end

  end
end