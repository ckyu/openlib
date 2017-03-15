# $:.unshift File.expand_path("../..", __FILE__)

require './lib/client'
require './rspec/spec_helper.rb'

describe 'Client' do
  let(:client) { Openlibrary::Client.new }
  
  describe '#search' do
    before do
      stub_get("/search.json?q=neil+gaiman",        "search-neil-gaiman.json")
      stub_get("/search.json?q=neil+gaiman&page=1", "search-neil-gaiman.json")
      stub_get("/search.json?q=neil+gaiman&page=2", "search-neil-gaiman-2.json")
      stub_get("/search.json?q=neil+gaiman&page=3", "search-neil-gaiman-3.json")
      stub_get("/search.json?q=neil+gaiman&page=4", "search-neil-gaiman-4.json")
    end

    it 'should return <= 10 results by default' do
      query = "neil gaiman"
      results = client.search(query)
      expect(results.size).to be <= 10
    end

    it 'limit/offset should work properly' do
      query = "neil gaiman"
      results = client.search(query, 50)
      (0...50).each do |i|
        expect(client.search(query, 1, i)[0].title).to eq results[i].title
      end
    end

    it 'should fetch results from beyond 100' do
      query = "neil gaiman"

      results = client.search(query, 10, 100)
      expect(results.size).to be <= 10
      expect(results[0].title).to eq client.search(query, 1, 100)[0].title
      expect(results[9].title).to eq client.search(query, 1, 109)[0].title

      results = client.search(query, 30, 80)
      expect(results.size).to be <= 30
      expect(results[0].title).to eq client.search(query, 1, 80)[0].title
      expect(results[29].title).to eq client.search(query, 1, 109)[0].title

      results = client.search(query, 100)
      expect(results.size).to be <= 100
      expect(results[99].title).to eq client.search(query, 1, 99)[0].title

      results = client.search(query, 10, 210)
      expect(results[0].title).to eq client.search(query, 1, 210)[0].title
      expect(results[9].title).to eq client.search(query, 1, 219)[0].title
    end

    it 'should return blank if no records found' do
      query = "neil gaiman"
      results = client.search(query, 10, 300)
      expect(results).to be_empty
    end

    it 'should raise an error if invalid limit/offset' do
      query = "neil gaiman"
      expect { client.search(query, -1) }.to raise_error(ArgumentError)
      expect { client.search(query, 101) }.to raise_error(ArgumentError)
      expect { client.search(query, 0) }.to raise_error(ArgumentError)
      expect { client.search(query, 10, -1) }.to raise_error(ArgumentError)
    end
  end
end