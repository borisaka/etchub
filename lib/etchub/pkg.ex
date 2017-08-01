defmodule Etchub.Pkg do

  def install(cn, packages_str) when is_binary packages_str do
    Etchub.Connection.exec(cn, "sudo pkg install -y #{packages_str}")
  end

  def install(cn, packages) when is_list packages do
    packages_str = Enum.join packages, ""
    install(cn, packages_str) 
  end
  
  def installed?(cn, pkg_name) do
    result = Etchub.Connection
      .exec!(cn, "pkg query '%n' #{pkg_name}")
      |> String.trim

    result == pkg_name
  end
end
