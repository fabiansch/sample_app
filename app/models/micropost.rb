class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order created_at: :desc }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  private

    # validates the size of an uploaded picture.
    def picture_size
      max_size = 5.megabytes
      if picture.size > max_size
        errors.add(:picture, "should be less than #{max_size.to_s} bytes")
      end
    end
end
