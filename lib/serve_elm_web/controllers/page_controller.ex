defmodule ServeElmWeb.PageController do
  use ServeElmWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def main(conn, _params) do
    case ServeElmWeb.Worker.render("main") do
      {:error, {_, error, _}} ->
        text conn, error
      {:ok, {name, html, age}} ->
        render conn, "main.html", %{name: name, html: html}
    end
  end
  def cached(conn, _params) do
    case ServeElmWeb.Worker.get_or_render("main") do
      {:error, {_, error, _}} ->
        text conn, error
      {:ok, {name, html, age}} ->
        render conn, "main.html", %{name: "#{name} (cached@#{age})", html: html}
    end
  end
end
