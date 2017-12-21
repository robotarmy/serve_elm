defmodule ServeElm.Presence do
  use Phoenix.Presence, otp_app: :my_app,
    pubsub_server: ServeElm.PubSub
end

