module ApplicationHelper

  def formata_data(data)
		data_formatada = ""
    if !data.nil?
      data_formatada = data.strftime("%d/%m/%Y")
		end
		data_formatada
	end

end
