class Ownership < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :item, class_name: "Item"
  #あるユーザーがあるアイテムを所持している
  #あるアイテムを持っている複数のユーザーが存在する
end
