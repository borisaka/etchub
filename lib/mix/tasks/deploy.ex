defmodule Mix.Tasks.Deploy do
  use Mix.Task
  alias Etchub, as: Etc
  def run([host, username]) do
    :ssh.start
    {:ok, cn} = Etc.Connection.connect(String.to_charlist(host), String.to_charlist(username))
    Etc.Pkg.install(cn, "squid tor privoxy")
    Etc.Service.enable(cn, "squid")
    Etc.Service.enable(cn, "tor")
    Etc.Service.enable(cn, "privoxy")
    Etc.ConfigDir.upload(cn, "squid")
    Etc.ConfigDir.upload(cn, "privoxy")
    Etc.Service.start(cn, "tor")
    Etc.Service.start(cn, "privoxy")
    Etc.Service.start(cn, "squid")
  end
end
