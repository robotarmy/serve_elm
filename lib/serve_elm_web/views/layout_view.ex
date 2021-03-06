defmodule ServeElmWeb.LayoutView do
  use ServeElmWeb, :view
  def script(conn, path) do
    path = static_path(conn,path)
    content_tag(:script, "", src: path)
  end
  def inline_script(conn, path) do
    path = Path.expand(
      "../../../priv/static/#{path}",
      __DIR__
    )
    content_tag(:script, "", src: data_url(
        "application/javascript",
        File.read!(path)
      )
    )
  end
  def data_url(mimetype,content) do
    "data:#{mimetype};base64,#{Base.encode64(content)}"
  end
end
