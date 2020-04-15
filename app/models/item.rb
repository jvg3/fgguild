class Item < ActiveRecord::Base

  belongs_to :member

  def self.slots
    [:head,
    :neck,
    :shoulder,
    :back,
    :chest,
    :wrist,
    :hands,
    :waist,
    :legs,
    :feet,
    :finger_1,
    :finger_2,
    :trinket_1,
    :trinket_2,
    :main_hand,
    :off_hand]
  end

  def self.color_for_ilvl(ilvl)

    rbg = "rgba(0, 129 , 255,"
    rbg = "rgba(198, 0 , 255," if ilvl >= 445
    rbg = "rgba(255, 128, 0," if ilvl >= 460

    # opacity = ((ilvl - 800)/35)*0.4 + 0.3
    # opacity = ((ilvl - 835)/15)*0.4 + 0.3 if ilvl >= 835
    # opacity = ((ilvl - 850))*0.4 + 0.3 if ilvl >= 850
    # opacity = 0.3 if opacity < 0.3
    # opacity = 0.7 if opacity > 0.7

    # str = rbg + opacity.round(1).to_s + ")"
    # puts "\n\n\nSTR"
    # puts str
    # puts "---\n\n\n"

    return "background-color: " + rbg + ".5)"


  end

end