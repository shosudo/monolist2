class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :following_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  has_many :followed_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followed_users, through: :followed_relationships, source: :follower

  has_many :ownerships , foreign_key: "user_id", dependent: :destroy
  has_many :items ,through: :ownerships
  #user tableとitem tableの中間テーブルであるownerships tableを参照して、:itemsを取得している
  #foreign_keyで関連する外部キーを指定
  has_many :wants, class_name: "Want", foreign_key: "user_id", dependent: :destroy
  #class_name=Wantとすることで、ownerships tableからtyoeがwantであるものを取得
  has_many :want_items , through: :wants, source: :item
  #wantであるものを取得しているため、:want_itemsでwantした商品を取得
  
  has_many :haves, class_name: "Have", foreign_key: "user_id", dependent: :destroy
  has_many :have_items , through: :haves, source: :item


  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following_users.include?(other_user)
  end


  def have(item)
    haves.find_or_create_by(item_id: item.id)
  end

  def unhave(item)
    haves.find_by(item_id: item.id).destroy
  end

  def have?(item)
    have_items.include?(item)
  end

  def want(item)
    wants.find_or_create_by(item_id: item.id)
    #引数としてPOSTされたインスタンス変数itemのitem idをキーに実行
    #インスタンス@itemのidを取得するには、item.idとかく必要がある
  end

  def unwant(item)
    wants.find_by(item_id: item.id).destroy
  end

  def want?(item)
    want_items.include?(item)
  end
end
