require 'csv'

desc "Import all books info from csv"
task :import_books_from_csv => :environment do
  file_name = Rails.root.to_s + '/lib/booksinfo.csv'
  puts 'started importing'
  language_id = Language.find_by(language_code: 'en').id
  CSV.foreach(file_name, :col_sep => ',', :headers => true) do |row|
    author = Author.create(name: row[0], language_id: language_id) unless author = Author.find_by(name: row[0])
    publisher = Publisher.create(name: row[5], language_id: language_id) unless publisher = Publisher.find_by(name: row[5])
    book = Book.create(author_id: author.id, publisher_id: publisher.id, book_title: row[8], language_id: language_id)
    BookDescription.create(
      :date_accessioned => row[1], 
      :date_available => row[2],
      :date_issued => row[3],
      :link => row[4],
      :rights => row[6],
      :subjects => row[7],
      :file_name => row[9],
      :file_size => row[10],
      :category => row[11],
      :book_id => book.id
      )
  end
end



desc "Import dli books info from csv"
# Import DLI books and info from CSV
task :import_dli_books_from_csv => :environment do
  file_name = Rails.root.to_s + '/lib/DLI.csv'
  puts 'started importing'
  language_id = Language.find_by(language_code: 'en').id
  CSV.foreach(file_name, :col_sep => ',', :headers => true) do |row|
    author = DliAuthor.create(name: row['Author1'], language_id: language_id) unless author = DliAuthor.find_by(name: row['Author1'])
    publisher = DliPublisher.create(name: row['DigitalPublisher'], language_id: language_id) unless publisher = DliPublisher.find_by(name: row['DigitalPublisher'])
    book = DliBook.create(author_id: author.id, publisher_id: publisher.id, book_title: row['Title'], language_id: language_id)
    DliBookDescription.create(
      :book_id => book.id, 
      :contributor => row['Contributor'],
      :scanning_center => row['ScanningCenter'],
      :barcode => row['Barcode'],
      :copyright => row['CopyrightOwner'],
      :rights => row['Rights'],
      :year => row['Year'],
      :pages => row['Pages'],
      :url => row['Url'],
      :no_of_pages => row['NumberPages'],
      :vendor => row['Vendor'],
      :subject => row['Subject'],
      :digital_pub_date => row['DigitalPublisherDate'],
      :link => row['Link'],
      :identifier => row['Identifier'],
      :unnumber_pages => row['UnnumberedPages']
      )
  end
end

desc "Update nil column as noname"
task :Update_nil_as_noname => :environment do
  %w(DliAuthor  DliPublisher).each do |model|
    model.constantize.where(name: nil).each do |i|
      i.name = 'noname'
      i.save
    end
  end
end


desc "Import category and translations"
task :import_category1 => :environment do
  file_name = Rails.root.to_s + '/lib/category.csv'
  puts "started"
  CSV.foreach(file_name, :col_sep => "\t", :headers=> true) do |row|
    p "#{row[0]} == #{row[2]}"
    Category.create(name: row[0], kn: row[2])  unless Category.find_by(name: row[0]) 
  end
end

desc "Import category and translations"
task :import_category2 => :environment do
  file_name = Rails.root.to_s + '/lib/category1.csv'
  puts "started"
  CSV.foreach(file_name, :col_sep => "\t", :headers=> true) do |row|
    p "#{row[0]} == #{row[1]}"
    Category.create(name: row[0], kn: row[1])  unless Category.find_by(name: row[0]) 
  end
end


desc "Assign association"
task :assign_association1 => :environment do
  BookDescription.find_each do |book|
    p ">>>>>>>>>>>>>>>>>>>>>>>>>>"
    p book
    book.subjects.split(';').each do |sub|
      cat = Category.find_or_create_by(name: sub)
      BookCategory.create(book_id: book.book_id, category_id: cat.id)  
    end
  end
end

desc "Assign association"
task :assign_association2 => :environment do
  DliBookDescription.find_each do |book|
    p ">>>>>>>>>>>>>>>>>>>>>>>>>>"
    p book
    subject = book.subject
    cat = if subject 
      Category.find_or_create_by(name: subject)
    else
      Category.find_by(name: 'NULL')
    end
    DliBookCategory.create(dli_book_id: book.book_id, category_id: cat.id)  
  end
end