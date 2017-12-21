defmodule ServeElmWeb.Prescience do
  use ServeElmWeb, :channel
  alias ServeElm.Presence

  def join("some:topic", _params, socket) do
    send(self(), :after_join)
    {:ok, assign(socket, :user_id, "value")}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
          online_at: inspect(System.system_time(:seconds))
                              })
    {:noreply, socket}
  end

  def fetch(_topic, entries) do
    meta = 
      %{fetch: %{_topic: _topic, entries: entries }}
      IO.inspect meta

    users = %{"123": %{ metas: [ meta ] } }

    result = for {key, %{metas: metas}} <- entries, into: %{} do
      {key, %{metas: metas, user: users[key]}}
    end

    IO.inspect result
    result
  end
end
