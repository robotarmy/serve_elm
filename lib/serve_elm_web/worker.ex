defmodule ServeElmWeb.Worker do
  use GenServer

  # Public Impl

  def get_or_render(key) do
    case GenServer.call(__MODULE__, {:get, key}) do
      {:missing, nil} ->
        case ServeElmWeb.Worker.render(key) do
          {:ok, result } ->
            {:ok, result }
          {:error, e }  ->
            {:error, e}
        end
      {:ok, x} ->
        {:ok, x}
    end
  end

  def render(key) do
    GenServer.call(__MODULE__, {:render, key})
  end
  # GenServer Impl

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok , %{}}
  end

  def handle_call({:get, name}, _from_pid, state) do
    ret = case Map.get(state, name)  do
            nil ->
              {:missing, nil}
            x ->
              {:ok, x}
          end
    {:reply, ret, state}
  end


  def handle_call({:render, name}, _from_pid, state) do
    {status, value} = execute_render(name)
    age   = DateTime.utc_now() |> DateTime.to_unix()
    data  = {name, value, age}
    new_state = Map.put(state, name, data)
    {:reply, {status, data } , new_state}
  end

  def run_elm_program do
    generate_model()
    |> Poison.encode!
    |> render_template
    |> Execjs.compile
    |> Execjs.call("ElmRender", [])
  end

  def execute_render(_name) do
    json_output = run_elm_program()
    result = cond do
      json_output["error"] != nil ->
        {:error,  json_output["error"]}
      json_output["error"] == nil ->
        {:ok, json_output["html"]}
    end
  end

  def generate_contacts do
    [
      #Elm : Model.Contact 
      %{
        id: 333,
        first_name: "Robot Army",
        last_name: "Made",
        gender: 3,
        birth_date: "11/20/1979",
        location: "home",
        phone_number: "222-222-2222",
        email: "robotarmy@ram9.cc",
        headline: "RAM9.CC",
        picture: "https://avatars0.githubusercontent.com/u/178963?s=400&v=4"
      },
      %{
        id: 123,
        first_name: "Jaine",
        last_name: "Smitherson",
        gender: 3,
        birth_date: "11/20/1983",
        location: "mt rushmore",
        phone_number: "333-333-3333",
        email: "js@rushmore.com",
        headline: "Nice Person",
        picture: "https://t6.rbxcdn.com/cd18c724efadc4e7a3220c2f098b6420"
      },
      %{
        id: 1333,
        first_name: "Toodles",
        last_name: "Kapital",
        gender: 3,
        birth_date: "11/20/1983",
        location: "wiggle",
        phone_number: "444-333-3333",
        email: "cat@kap.com",
        headline: "Cat Sitter",
        picture: "https://t6.rbxcdn.com/cd18c724efadc4e7a3220c2f098b6420"
      },
      %{
        id: 1311,
        first_name: "Boosh",
        last_name: "Sop",
        gender: 3,
        birth_date: "11/20/1983",
        location: "Dartmouth",
        phone_number: "444-55-3331",
        email: "boo@sop.net",
        headline: "Bitcoin Collector",
        picture: "https://t6.rbxcdn.com/cd18c724efadc4e7a3220c2f098b6420"
      }
    ]
  end
  def generate_model do
    contacts = generate_contacts()
    %{
      # Elm List (Model.Contact)
      entries: contacts,
      page_number: 1,
      total_entries: length(contacts),
      total_pages: 1
    }
  end

  def render_template(model_as_json_string) do
    """

    const elmStaticHtml = require("/Users/o_o/devhome/serve_elm/node_modules/elm-static-html-lib").default;

    async function __elm_render__() {


    //
    // Contruct a representation for location
    //
    //
    global.document = global.document || {};
    global.document.location = global.document.location || {
    hash: "",
    host: "",
    hostname: "",
    href: "",
    origin: "",
    pathname: "",
    port: "",
    protocol: "",
    search: "",
    };



    const options = {
      model: #{model_as_json_string}
    , decoder: "StaticMain.decodeModel"
    };
    let myerror = null;
    let result  = "empty";
    try {
      result = await new Promise(
      function(resolve, reject) {
        elmStaticHtml("/Users/o_o/devhome/serve_elm",
                      "StaticMain.view",
                      options).then(function(html) {
        resolve(html);
      });
      }
     );
     } catch(error) {
      myerror = error;
      console.log("ERROR:"+error)
     }
      return {error: myerror, html:result};
    }

    function ElmRender() {
     return __elm_render__();
    }
    """
  end
end
