class MainController < ApplicationController
  def index
    @summary = CgminerApi.call("summary")
    if @summary.include?("CGMiner is not running.")
      @not_running = true
    else
      @best_share = @summary["SUMMARY"].first["Best Share"]
      @pools = CgminerApi.call("pools")["POOLS"]
    end
  end

  def api_action
    payload = params[:payload]
    @response = CgminerApi.call(payload)

    flash[:warning] = @response["STATUS"].first["Msg"] if @response["STATUS"].first["STATUS"] == "E"
    redirect_to root_url
  end

  def toggle_leds
    if File.exist?(Rails.root.join('LEDS_OFF'))
      File.delete(Rails.root.join('LEDS_OFF'))
      system("service leds start")
    else
      system("sh -c 'touch #{Rails.root.join('LEDS_OFF')}'")
      system("service leds start")
    end

    redirect_to root_url
  end
end
