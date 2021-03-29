class PoolsController < ApplicationController
  def index

  end

  def new
    @pool = Pool.new()
    @header = 'New Pool'

    respond_to :js
  end

  def edit
    respond_to :js
  end

  def update
    add_pool = CgminerApi.call("addpool|#{pool_params[:url]},#{pool_params[:user]},#{pool_params[:pass]}")
    save_config = CgminerApi.call("save|#{Rails.root.join('cgminer.conf')}")
    pools = CgminerApi.call("pools")
    pools["POOLS"].each do |pool|
      if pool_params[:url].url == pool["URL"]
        CgminerApi.call("switchpool|#{pool["POOL"]}")
        CgminerApi.call("save|#{Rails.root.join('cgminer.conf')}")
      end
    end
    pools = CgminerApi.call("pools")
    pools["POOLS"].each do |pool|
      next if pool["Priority"] == 0
      remove_pool = CgminerApi.call("removepool|#{pool["POOL"]}")
    end
    CgminerApi.call("save|#{Rails.root.join('cgminer.conf')}")
    flash[:success] = "Pool has been updated"
    redirect_to root_url
  end

  private

    def pool_params
      params.require(:pool).permit(:url, :user, :pass)
    end
end
