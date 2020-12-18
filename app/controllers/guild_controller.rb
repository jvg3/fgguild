class GuildController < ApplicationController

  def show
    @new_member = Member.new
    @members = Member.all.order(ilvl: :desc)
  end
end