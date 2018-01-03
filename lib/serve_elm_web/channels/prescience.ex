defmodule ServeElmWeb.Prescience do
  use ServeElmWeb, :channel
  alias ServeElm.Presence

  def join(_, _params, socket) do
    send(self(), :register_join)
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:register_join, socket) do
    push socket, "register:self", socket.assigns.user
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(
      socket, socket.assigns.user.id, %{
        user_ref: socket.assigns.user.id
      }
    )
    {:noreply, socket}
  end

  def fetch(_topic, entries) do
    IO.inspect "fetch"
    meta = %{fetch: %{_topic: _topic, entries: entries }}
    IO.inspect meta

    users = %{"123": %{ metas: [ meta ] } }

    result = for {key, %{metas: metas}} <- entries, into: %{} do
      {key, %{metas: metas, user: users[key]}}
    end

    IO.inspect result
    result
  end
end
