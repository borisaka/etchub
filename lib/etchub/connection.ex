defmodule Etchub.Connection do
  import SSHEx
  def connect(ip, user) do
    SSHEx.connect(ip: ip, user: user)
  end

  def exec(conn, cmd) do
    SSHEx.run(conn, cmd)
  end

  def exec!(conn, cmd) do
    SSHEx.cmd!(conn, cmd)
  end
end
