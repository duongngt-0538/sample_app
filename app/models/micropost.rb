class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: [Settings.micropost.image_height,
                                        Settings.micropost.image_width]
  end

  validates :content, presence: true,
            length: {maximum: Settings.micropost.content.max_length}
  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: I18n.t("message.image_format")},
            size: {less_than: Settings.micropost.image_max_size.megabytes,
                   message: I18n.t("message.size_max")}

  scope :recent_posts, ->{order created_at: :desc}
end
