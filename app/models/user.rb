class User < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  validates :first_name, presence: true, length: { maximum: 10 }
  validates :last_name, presence: true, length: { maximum: 10 }
  validates :gender, presence: true
  validates :birthdate, presence: true
  validates :prefecture_id, presence: true

  enum gender: { male: 0, female: 1 }

  # 新しい順
  scope :order_by_latest, -> { order(id: :desc) }
  # 古い順
  scope :order_by_oldest, -> { order(id: :asc) }

  # フルネーム（姓 + 名）
  def full_name
    "#{last_name} #{first_name}"
  end

  # 年齢（生年月日から計算）
  def age
    return if birthdate.blank?

    date_format = "%Y%m%d"
    (Date.today.strftime(date_format).to_i - birthdate.strftime(date_format).to_i) / 10_000
  end
end
