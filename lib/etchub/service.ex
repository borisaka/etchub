defmodule Etchub.Service do
  alias Etchub.Connection, as: Conn
  def enabled?(service, rc_conf) when is_binary service do
    String.contains?(rc_conf, "#{service}_enable") 
  end

  def enabled?(cn, service) do
    enabled?(service, read_rc_conf(cn))
  end

  def enable(cn, service) do
    unless enabled?(cn, service) do
      Conn.exec!(cn, "echo '#{service}_enable=\"YES\"' | sudo tee -a /etc/rc.conf")
    end
  end

  def disable(cn, service) do
    rc_conf = read_rc_conf(cn)
    rc_conf = String.replace(rc_conf, "#{service}_enable=\"YES\"\n", "")
    write_rc_conf(cn, rc_conf)
  end

  def start(cn, service) do
   Conn.exec!(cn, "sudo service #{service} start") 
  end

  def stop(cn, service) do
   Conn.exec!(cn, "sudo service #{service} stop") 
  end

  def restart(cn, service) do
   Conn.exec!(cn, "sudo service #{service} restart") 
  end

  defp read_rc_conf(cn) do
     Conn.exec!(cn, "sudo cat /etc/rc.conf") 
  end

  defp write_rc_conf(cn, rc_conf) do
    Conn.exec!(cn, "echo '#{rc_conf}' | sudo tee  /etc/rc.conf")
  end

end
