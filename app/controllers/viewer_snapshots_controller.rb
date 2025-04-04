class ViewerSnapshotsController < ApplicationController
  def index
    # Filtro de datas com padrão de 7 dias
    start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : 7.days.ago.to_date
    end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.today

    # Processa hora e minuto para início
    start_hour = params[:start_hour].presence || "00"
    start_minute = params[:start_minute].presence || "00"
    start_time = Time.parse("#{start_date} #{start_hour}:#{start_minute}")

    # Processa hora e minuto para fim
    end_hour = params[:end_hour].presence || "23"
    end_minute = params[:end_minute].presence || "59"
    end_time = Time.parse("#{end_date} #{end_hour}:#{end_minute}")

    # Filtra por streamers selecionados
    base_query = ViewerSnapshot.includes(:streamable)
                              .where(captured_at: start_time..end_time)
                              .order(:captured_at)
    
    # Filtra por streamers específicos se fornecidos
    if params[:streamer_ids].present?
      base_query = base_query.where(streamable_id: params[:streamer_ids])
    end

    # Agrupa por streamer e minuto, mantendo apenas o snapshot mais recente de cada grupo
    @snapshots = base_query.group_by { |s| [s.streamable_id, s.captured_at.strftime("%Y-%m-%d %H:%M")] }
                          .values
                          .map { |group| group.max_by(&:captured_at) }
                          .sort_by(&:captured_at)

    # Para a tabela com barras
    @max_viewers = @snapshots.map(&:viewer_count).max || 1

    # Responde com CSV se solicitado
    respond_to do |format|
      format.html
      format.csv do
        csv_data = CSV.generate(headers: true) do |csv|
          csv << ["Streamer", "Date", "Time", "Viewers"]
          
          @snapshots.each do |snapshot|
            csv << [
              snapshot.streamable.username || snapshot.streamable.channel_name,
              snapshot.captured_at.strftime("%Y-%m-%d"),
              snapshot.captured_at.strftime("%H:%M:%S"),
              snapshot.viewer_count
            ]
          end
        end
        
        send_data csv_data, 
                  filename: "streamer-data-#{Date.today.strftime('%Y-%m-%d')}.csv", 
                  type: 'text/csv'
      end
    end
  end
  
  def analytics
    @streamers = TwitchStreamer.all

    if params[:streamer_id].present?
      @selected_streamer = TwitchStreamer.find(params[:streamer_id])
      @snapshots = @selected_streamer.viewer_snapshots
                                     .where(captured_at: 7.days.ago..Time.current)
                                     .order(:captured_at)

      # Prepara os dados para gráfico com Chartkick
      @chart_data = @snapshots.map { |s| [s.captured_at.strftime("%d/%m %H:%M"), s.viewer_count] }
    end
  end
end