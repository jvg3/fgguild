class Member < ActiveRecord::Base

  has_many :items

  def self.refresh_data
    Member.all.each do |member|
      member.pull_data
    end
  end

  def pull_data
    uri = Addressable::URI.parse("https://us.api.blizzard.com/profile/wow/character/kelthuzad/#{self.name.downcase}/equipment?namespace=profile-us&locale=en_US&access_token=USN29wImNeOAKQOHrsf1bMTVgHVdmkuI6d")
    response = HTTParty.get(uri.normalize)
    data = JSON.parse(response.body)

    data["equipped_items"].each do |item|
      next unless Item.slots.include?(item["slot"]["type"].downcase.to_sym)
      existing_item = Item.where(member_id: id, slot: item["slot"]["type"].downcase).first rescue nil

      item_params = {
        item_id: item["item"]["id"],
        member_id: id,
        name: item["name"],
        ilvl: item["level"]["value"],
        slot: item["slot"]["type"].downcase,
        # enchant: (item_data["tooltipParams"]["enchant"] rescue nil),
        # gem0: (item_data["tooltipParams"]["gem0"] rescue nil),
        # gem1: (item_data["tooltipParams"]["gem1"] rescue nil),
        # gem2: (item_data["tooltipParams"]["gem2"] rescue nil),
        # bonus: (item_data["bonusLists"].first rescue nil)
      }

      if existing_item
        existing_item.update(item_params)
      else
        Item.create(item_params)
      end
    end
  end

  def self.get_all_sims

    base_url = "http://fgguild.herokuapp.com/"
    # base_url = "http://localhost:3001/"

    uri = Addressable::URI.parse(base_url + "members/get_ids")
    response = HTTParty.get(uri.normalize)
    data = JSON.parse(response.body)

    data.each do |member|
      puts "\n\n\nMEMBER:"
      puts member[0]
      puts member[1]
      Member.get_sims(member[0], member[1])
      puts "\n\n\n"
    end

    return ""
  end

  def self.get_sims(id, name)
    value = `sh scripts/simcraft.sh #{name}`
    file = File.read("#{name}.json") rescue nil

    if file
      data = JSON.parse(file)

      puts "\n\n\nSIM:"
      dps = (data["sim"]["players"][0]["collected_data"]["dps"]["mean"]).to_f.to_i
      puts dps
      uri = Addressable::URI.parse("http://fgguild.herokuapp.com/members/#{id}/update_dps?dps=#{dps}")
      HTTParty.post(uri)

      # File.delete("#{name}.json")
    end
  end

  def self.get_all_sims_cloud
    Member.all.each do |member|
      # ./simc/engine/simc armory=us,kelthuzad,Dolfin calculate_scale_factors=1 json=tmp/reports/Dolfin.json html=tmp/reports/Dolfin.html iterations=400 report_details=0
      value = `sh scripts/simcraft_prod.sh #{member.name}`

      json_file = File.read("tmp/reports/#{member.name}.json") rescue nil
      html_file = File.read("tmp/reports/#{member.name}.html") rescue nil

      if json_file
        data = JSON.parse(json_file)

        puts "\n\n\nSIM:"
        dps = (data["sim"]["players"][0]["collected_data"]["dps"]["mean"]).to_f.to_i
        puts dps
        member.update(dps: dps)
      end

      if html_file
        member.update(sim_results: html_file)
      end
    end
  end

end