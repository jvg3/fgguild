class MembersController < ApplicationController

  skip_before_filter :verify_authenticity_token

  before_action :set_member, only: [:update, :destroy]
  before_action :set_members

  def create

    @new_member = Member.new(member_params).save

    respond_to do |format|
      format.js{ render layout: false, file: "members/render_table", content_type: 'text/javascript' }
    end

  end

  def index

    Member.refresh_data

    respond_to do |format|
      format.js{ render layout: false, file: "members/render_table", content_type: 'text/javascript' }
    end

  end

  def update

    if @member
      @member.pull_data
      respond_to do |format|
        format.js{ render layout: false, file: "members/render_table", content_type: 'text/javascript' }
      end
    end

  end

  def update_dps

    @member = Member.find_by_name(params[:name]) rescue nil
    if @member && params[:dps].present?
      @member.update(dps: params[:dps])
      render json: "ok"
    end

  end

  def destroy

    if @member
      @member.destroy
      respond_to do |format|
        format.js{ render layout: false, file: "members/render_table", content_type: 'text/javascript' }
      end
    end

  end

  private

  def set_member
    @member = Member.find(params[:id]) rescue nil
  end

  def set_members
    @members = Member.all.order(ilvl: :desc)
  end

  def member_params
    params.require(:member).permit!
  end

end