class BookTranslation < ActiveRecord::Base
  belongs_to :language
  belongs_to :book
end
