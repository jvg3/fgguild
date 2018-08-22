class Member < ActiveRecord::Base

  has_many :items

  def self.refresh_data
    Member.all.each do |member|
      member.pull_data
    end
  end

  def pull_data
    uri = Addressable::URI.parse("https://us.api.battle.net/wow/character/kelthuzad/#{name}?fields=items&locale=en_US&apikey=ehffa4esdm42e6uqj6u7zxtae3v6qp3b")
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

  def self.get_all_sims
    base_url = "http://fgguild.herokuapp.com/"
    # base_url = "http://localhost:3001/"

    uri = Addressable::URI.parse(base_url + "members/ids.json")
    response = HTTParty.get(uri.normalize)

    data = JSON.parse(response.body)

    data.each do |member|
      puts "\n\n\nMEMBER:"
      puts member[0]
      puts member[1]
      Member.get_sims(member[0], member[1])
      puts "\n\n\n"
    end
  end


  def self.get_sims(id, name)
    # Member.get_sims(1, "Dolfin")
    # ./simc/engine/simc armory=us,kelthuzad,Dolfin calculate_scale_factors=1 json=reports/Dolfin.json html=./reports/Dolfin.html iterations=400 report_details=0
    value = `sh scripts/simcraft.sh #{name}`
    json_file = File.read("reports/#{name}.json") rescue nil
    html_file = File.read("reports/#{name}.html") rescue nil

    if json_file
      data = JSON.parse(json_file)

      puts "\n\n\nSIM:"
      dps = (data["sim"]["players"][0]["collected_data"]["dps"]["mean"]).to_f.to_i
      puts dps
      # uri = Addressable::URI.parse("http://localhost:3001/members/#{id}/update_dps?dps=#{dps}")
      uri = Addressable::URI.parse("http://fgguild.herokuapp.com/members/#{id}/update_dps?dps=#{dps}")
      response = HTTParty.post(uri.normalize)
    end

    if html_file
      # uri = Addressable::URI.parse("http://localhost:3001/members/#{id}/update_sims")
      uri = Addressable::URI.parse("http://fgguild.herokuapp.com/members/#{id}/update_sims")
      response = HTTParty.post(uri.normalize, body: { sim_html: html_file })
    end
  end
end
