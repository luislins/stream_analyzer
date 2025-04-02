class TwitchStreamersController < ApplicationController
  def index
    @twitch_streamers = TwitchStreamer.all
  end

  def show
    @streamer = TwitchStreamer.find(params[:id])
  end

  def new
    @streamer = TwitchStreamer.new
  end

  def create
    service = TwitchApiService.new
    data = service.fetch_streamer_data(twitch_streamer_params[:username])

    if data
      @streamer = TwitchStreamer.find_or_initialize_by(twitch_id: data[:twitch_id])
      @streamer.assign_attributes(data)
      
      if @streamer.save
        redirect_to twitch_streamers_path, notice: 'Streamer adicionado com sucesso!'
      else
        render :new, status: :unprocessable_entity
      end
    else
      @streamer = TwitchStreamer.new(twitch_streamer_params)
      @streamer.errors.add(:username, "não encontrado na Twitch")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @streamer = TwitchStreamer.find(params[:id])
    @streamer.destroy
    redirect_to twitch_streamers_path, notice: 'Streamer removido com sucesso!'
  end

  private

  def twitch_streamer_params
    params.require(:twitch_streamer).permit(:username)
  end
end
