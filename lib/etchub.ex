defmodule Etchub do
  import SSHEx
  import Apache.Htpasswd
  @moduledoc """
  Documentation for Etchub.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Etchub.hello
      :world

  """
  def hello do
    :world
  end

  def exec(command) do
    {:ok, conn} = SSHEx.connect ip: '46.101.228.236', user: 'freebsd', password: 'freebsd'
    res = SSHEx.cmd! conn, command
    res
  end

  def install_pkg do
    res = exec('sudo pkg install -y squid')
    IO.puts(res)
  end

  def enable_service(service) do
    if enabled?(service) do
      IO.puts "#{service} already enabled"
    else
      exec("echo '#{service}_enable=\"YES\"' | sudo tee -a /etc/rc.conf")
    end
  end

  def enabled?(service) do
    rc_conf = exec("sudo cat /etc/rc.conf") 
    String.contains?(rc_conf, "#{service}_enable") && !String.contains?(rc_conf, '"#{service}_enable=\"NO\"')
  end

  def put_configs do
    {:ok, conf} = File.read("./data/squid/squid.conf") 
    {:ok, htaccess} = Apache.Htpasswd.encode("jimmi", "HJydtsgXVM") 
    exec("echo '#{conf}' | sudo tee /usr/local/etc/squid/squid.conf") 
    exec("echo '#{htaccess}' | sudo tee /usr/local/etc/squid/htaccess")
    IO.puts(exec("sudo service squid start"))
  end
end
