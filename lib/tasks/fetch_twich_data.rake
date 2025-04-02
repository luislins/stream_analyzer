# lib/tasks/fetch_twitch_data.rake
namespace :twitch do
  desc "Busca dados do streamer tacocs e salva no banco"
  task fetch_tacocs: :environment do
    service = TwitchApiService.new
    data = service.fetch_streamer_data("tacocs")

    if data
      streamer = TwitchStreamer.find_or_initialize_by(twitch_id: data[:twitch_id])
      streamer.update!(data)
      puts "Dados atualizados para #{streamer.username}!"
    else
      puts "Não foi possível obter dados para 'tacocs'."
    end
  end
end
