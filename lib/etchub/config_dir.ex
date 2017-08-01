defmodule Etchub.ConfigDir do
  alias Etchub.Connection, as: Conn
  def upload(cn, service) do
    File.ls!("./data/#{service}")
    |> Enum.each fn file_name -> 
      put_config(cn, service, file_name)
    end
  end

  defp put_config(cn, service, file_name) do
    content = File.read!("./data/#{service}/#{file_name}")
    path = "/usr/local/etc/#{service}/#{file_name}"
    Conn.exec!(cn, "echo '#{content}' | sudo tee #{path}")
  end


end
