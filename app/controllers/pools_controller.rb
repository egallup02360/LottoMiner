class PoolsController < ApplicationController
  def index

  end

  def new
    @pool = Pool.new()
    @header = 'New Pool'

    respond_to :js
  end

  def edit
    @pool = CgminerApi.call("pools")["POOLS"].first

    respond_to :js
  end

  def update
    @pool = Pool.new(pool_params)
    add_pool = CgminerApi.call("addpool|stratum+tcp://#{@pool.url},#{@pool.user},#{@pool.pass}")
    save_config = CgminerApi.call("save|#{Rails.root.join('cgminer.conf')}")
    pools = CgminerApi.call("pools")
    pools["POOLS"].each do |pool|
      remove_pool = CgminerApi.call("removepool|#{pool["POOL"]}")
    end
    CgminerApi.call("save|#{Rails.root.join('cgminer.conf')}")
    flash[:success] = "Pool has been updated. If the pool you see below is not the one you updated to, double check the settings you entered. The active pool will only update successfully if a connection can be made to it."
    redirect_to root_url
  end

  private

    def pool_params
      params.require(:pool).permit(:url, :user, :pass)
    end
end
