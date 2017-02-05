class Item < ActiveRecord::Base
  has_many :ownerships  , foreign_key: "item_id" , dependent: :destroy
  has_many :users , through: :ownerships
  #user tableとitem tableの中間テーブルであるownerships tableを参照して、:usersを取得している
  
  has_many :wants, class_name: "Want", foreign_key: "item_id", dependent: :destroy
  #class_name=Wantとすることで、ownerships tableからtyoeがwantであるものを取得
  has_many :want_users , through: :wants, source: :user
  #wantであるものを取得しているため、:want_itemsでwantした商品を取得
  
  has_many :haves, class_name: "Have", foreign_key: "item_id", dependent: :destroy
  has_many :have_users , through: :haves, source: :user
end
