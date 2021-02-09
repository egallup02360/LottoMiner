class PoolsController < ApplicationController
  before_action :set_pool, only: [:edit, :update, :destroy]

  def index

  end

  def new
    @pool = Pool.new()
    @header = 'New Pool'

    respond_to :js
  end

  def create
    @pool = Pool.new(pool_params)
    if Pool.maximum("cg_id").nil?
      @pool.cg_id = 0
    else
      @pool.cg_id = Pool.maximum("cg_id") + 1
    end

    if @pool.save
      flash[:success] = "Pool has been added"
      redirect_to root_url
    end
  end

  def edit

    respond_to :js
  end

  def update
    @pool.delete
    @pool = Pool.new(pool_params)
    @pool.cg_id = 0
    if @pool.save
      pools = CgminerApi.call("pools")
      pools["POOLS"].each do |pool|
        if @pool.url == pool["URL"]
          CgminerApi.call("switchpool|#{pool["POOL"]}")
          CgminerApi.call("save|#{Rails.root.join('bin', 'cgminer.conf')}")
        end
      end
      pools = CgminerApi.call("pools")
      pools["POOLS"].each do |pool|
        next if pool["Priority"] == 0
        remove_pool = CgminerApi.call("removepool|#{pool["POOL"]}")
      end
      CgminerApi.call("save|#{Rails.root.join('bin', 'cgminer.conf')}")
      flash[:success] = "Pool has been updated"
      redirect_to root_url
    end
  end

  def destroy
    @pool.delete
    flash[:success] = "Pool has been removed"
    redirect_to root_url
  end

  private

    def set_pool
      begin
        @pool = Pool.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:danger] = 'Pool does not exist'
        redirect_to root_path
        return
      end
    end

    def pool_params
      params.require(:pool).permit(:url, :user, :pass)
    end
end
