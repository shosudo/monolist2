class RankingController < ApplicationController
    before_action :logged_in_user
    
    def have
        ids = Have.group(:item_id).order('count_item_id desc').limit(10).count(:item_id).keys
        #Haveグループの中から、item_idの数をカウントして並べ替え
        @items = Item.find(ids).sort_by do |element|
        #持ってきたものから並べ替え
            ids.index(element.id)
        end
    end
    
    def want
        ids = Want.group(:item_id).order('count_item_id desc').limit(10).count(:item_id).keys
        @items = Item.find(ids).sort_by do |element|
            ids.index(element.id)
        end
    end
    
end
