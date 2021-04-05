class PoolsController < ApplicationController
  def index

  end

  def new
    @model = Pool.new()
    @header = 'New Pool'

    respond_to :js
  end

  def edit
    unless params[:id].to_i == -1
      @pool = CgminerApi.call("pools")["POOLS"].first
      @model = Pool.new(url: @pool["URL"].gsub("stratum+tcp://", ""), user: @pool["User"])
    end

    respond_to :js
  end

  def update
    @pool = Pool.new(pool_params)
    add_pool = CgminerApi.call("addpool|stratum+tcp://#{@pool.url},#{@pool.user},#{@pool.pass}")
    save_config = CgminerApi.call("save|/root/LottoMiner/cgminer.conf")
    flash[:success] = "Pool has been added."
    redirect_to root_url
  end

  def make_active
    CgminerApi.call("enablepool|#{params[:id]}")
    pools = CgminerApi.call("pools")["POOLS"]
    pools.each do |pool|
      next if pool["POOL"].to_s == params[:id].to_s
      CgminerApi.call("disablepool|#{pool["POOL"]}")
    end
    CgminerApi.call("save|/root/LottoMiner/cgminer.conf")
    flash[:success] = "Pool has been activated"
    redirect_to root_url
  end

  def destroy
    CgminerApi.call("removepool|#{params[:id]}")
    flash[:success] = "Pool has been removed"
    redirect_to root_url
  end

  private
    def pool_params
      params.require(:pool).permit(:url, :user, :pass)
    end
end
