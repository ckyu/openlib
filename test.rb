require './lib/openlibrary.rb'

client = Openlibrary::Client.new
results = client.search({title: "Harry Potter"}, 5, 5)
# results = client.search("neil gaiman", 20, 59)

# results.each.with_index { |book, i| print "#{i}\t#{book.title}\n\tby #{book.authors.join(", ") if !book.authors.empty?}\n\tcover: #{book.covers}\n" }
results.each.with_index { |book, i| print book }