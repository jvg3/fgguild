class MembersController < ApplicationController

  def create

    @members = Member.all
    @new_member = Member.new(member_params).save

    respond_to do |format|
      format.js{ render layout: false, file: "members/create" }
    end

  end

  def index

    @members = Member.all
    Member.refresh_data

    respond_to do |format|
      format.js{ render layout: false, file: "members/index" }
    end

  end

  def destroy
    member = Member.find(params[:id]) rescue nil
    if member
      member.destroy
      respond_to do |format|
        format.js{ render layout: false, file: "members/destroy" }
      end
    end
  end

  private

  def member_params
    params.require(:member).permit!
  end

end