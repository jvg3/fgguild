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
    :finger1,
    :finger2,
    :trinket1,
    :trinket2,
    :mainHand,
    :offHand]
  end

end