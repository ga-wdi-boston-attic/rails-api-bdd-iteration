class Article < ActiveRecord::Base
  has_many :comments, inverse_of: :article, dependent: :destroy
  validates_associated :comments
  validates_presence_of :title, :content
end
