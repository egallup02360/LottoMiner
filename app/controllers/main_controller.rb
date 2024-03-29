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

  def reconfigure_wifi
    fork { system("sh #{Rails.root.join('reconfigure_wifi.sh')}") }
    flash[:success] = "Your LottoMiner will now reboot. When it turns back on, you will need to connect to the network 'LottoMiner-Config' to configure your wifi connection."
    redirect_to root_url
  end

  def api_action
    payload = params[:payload]
    @response = CgminerApi.call(payload)

    flash[:warning] = @response["STATUS"].first["Msg"] if @response["STATUS"].first["STATUS"] == "E"
    redirect_to root_url
  end

  def toggle_leds
    if File.exist?(Rails.root.join('LEDS_OFF'))
      system("sh #{Rails.root.join('start_leds.sh')}")
    else
      system("sh #{Rails.root.join('stop_leds.sh')}")
    end

    redirect_to root_url
  end
end
