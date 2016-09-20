class Member < ActiveRecord::Base

  has_many :items

  def self.refresh_data

    Member.all.each do |member|
      member.pull_data
    end

  end

  def pull_data

    uri = Addressable::URI.parse("https://us.api.battle.net/wow/character/kelthuzad/#{name}?fields=items&locale=en_US&apikey=ehffa4esdm42e6uqj6u7zxtae3v6qp3b")
    uri.normalize
    response = HTTParty.get(uri.normalize)
    data = JSON.parse(response.body)

    if (data["items"] && data["items"]["averageItemLevelEquipped"] && data["class"])
      self.update(ilvl: data["items"]["averageItemLevelEquipped"], class_id: data["class"])
    end

    data["items"].keys.each do |key|

      unless key == "averageItemLevel" || key == "averageItemLevelEquipped"

        item_data = data["items"][key]
        existing_item = Item.where(member_id: id, slot: key).first rescue nil

        item_params = {
          item_id: item_data["id"],
          member_id: id,
          name: item_data["name"],
          ilvl: item_data["itemLevel"],
          slot: key,
          enchant: (item_data["tooltipParams"]["enchant"] rescue nil),
          gem0: (item_data["tooltipParams"]["gem0"] rescue nil),
          gem1: (item_data["tooltipParams"]["gem1"] rescue nil),
          gem2: (item_data["tooltipParams"]["gem2"] rescue nil),
          bonus: (item_data["bonusLists"].first rescue nil)
        }

        if existing_item
          existing_item.update(item_params)
        else
          Item.create(item_params)
        end

      end

    end

  end

end