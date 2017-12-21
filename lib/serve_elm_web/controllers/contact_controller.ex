
defmodule ServeElmWeb.ContactController do
  use ServeElmWeb, :controller


  def index(conn, params) do
    contacts = ServeElmWeb.Worker.generate_model()


    json conn, contacts
  end

  def show(conn, %{"id" => id}) do
    contact = %{
      id: 1311,
      first_name: "Hardcoded Api",
      last_name: "Responder",
      gender: 3,
      birth_date: "11/20/1983",
      location: "Elixir Server",
      phone_number: "444-55-3331",
      email: "boo@faker.com",
      headline: "Functional Programmer",
      picture: "https://t6.rbxcdn.com/cd18c724efadc4e7a3220c2f098b6420"
    }
    json conn, contact
  end
end

