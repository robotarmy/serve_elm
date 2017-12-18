defmodule ServeElmWeb.PageController do
  use ServeElmWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def main(conn, _params) do
    case ServeElmWeb.Worker.get_or_render("main") do
      {:error, {_, error, _}} ->
        text conn, error
      {:ok, {name, html, age}} ->
        #text conn, "#{name} has #{inspect(val)} with age #{age}"
        render conn, "main.html", %{name: name, age: age, html: html}
    end
  end
end
