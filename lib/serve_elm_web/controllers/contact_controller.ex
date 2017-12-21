
defmodule ServeElmWeb.ContactController do
  use ServeElmWeb, :controller


  def index(conn, params) do
    contacts = ServeElmWeb.Worker.generate_model()


    json conn, contacts
  end
end

