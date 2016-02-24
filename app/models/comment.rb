#
class Comment < ActiveRecord::Base
  belongs_to :article, inverse_of: :comments

  validates :article, presence: true
end
