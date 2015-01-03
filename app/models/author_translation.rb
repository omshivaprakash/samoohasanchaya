class AuthorTranslation < ActiveRecord::Base
  belongs_to :author
  validates_presence_of  :name  
end
