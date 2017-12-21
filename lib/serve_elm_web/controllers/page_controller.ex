defmodule ServeElmWeb.PageController do
  use ServeElmWeb, :controller


  def index(conn, _params) do
    case ServeElmWeb.Worker.render("index") do
      {:error, {_, error, _}} ->
        text conn, error
      {:ok, {name, html, age}} ->
        render conn, "index.html",
          %{name: name, html: html}
    end
  end










  def cached(conn, _params) do
    case ServeElmWeb.Worker.get_or_render("index") do
      {:error, {_, error, _}} ->
        text conn, error
      {:ok, {name, html, age}} ->
        render conn, "index.html", %{name: "#{name} (cached@#{age})", html: html}
    end
  end
end
