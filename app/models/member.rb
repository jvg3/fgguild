class Member < ActiveRecord::Base

  has_many :items

  def self.refresh_data

    Member.all.each do |member|
      member.pull_data
    end

  end

  def pull_data

    url = "https://us.api.battle.net/wow/character/kelthuzad/#{name}?fields=items&locale=en_US&apikey=ehffa4esdm42e6uqj6u7zxtae3v6qp3b"
    response = HTTParty.get(url)
    data = JSON.parse(response.body)

    self.update(ilvl: data["items"]["averageItemLevelEquipped"], class_id: data["class"])

    data["items"].keys.each do |key|

      unless key == "averageItemLevel" || key == "averageItemLevelEquipped"

        item_data = data["items"][key]
        existing_item = Item.where(member_id: id, slot: key).first rescue nil

        item_params = {
          member_id: id,
          name: item_data["name"],
          ilvl: item_data["itemLevel"],
          slot: key
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