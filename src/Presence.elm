module Presence exposing(..)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push


type alias Model = {
        socket : Phoenix.Socket.Socket Msg
    }

type Msg = PhoenixMsg (Phoenix.Socket.Msg Msg)


socketServer : String
socketServer =
    -- http://web.production-elixir-service.36cf5ace.svc.dockerapp.io:8080/socket/websocket
    "ws://localhost:4000/socket/websocket"

initSocket : Phoenix.Socket.Socket Msg
initSocket =
    Phoenix.Socket.init socketServer
    -- |> Phoenix.Socket.withDebug
    |> Phoenix.Socket.on "presence" "homepage" ReceiveMailCheck

init : ( Model, Cmd Msg )
init =
    let
        (socket, cmd) = joinChannel initSocket
    in
      let
          initModel = {
                      , socket = socket
          }

joinChannel : (Phoenix.Socket.Socket Msg) -> ( Phoenix.Socket.Socket Msg , Cmd (Phoenix.Socket.Msg Msg) )
joinChannel aSocket =
    let
        channel = Phoenix.Channel.init "homepage"
    in
        Phoenix.Socket.join channel aSocket

updatePhoenixMsg: Model -> (Phoenix.Socket.Msg Msg) -> (Model , Cmd Msg)
updatePhoenixMsg model msg =
    let
      ( phxSocket, phxCmd ) = Phoenix.Socket.update (log "msg" msg) model.socket
    in
      ( { model | socket = phxSocket }
      , Cmd.map PhoenixMsg phxCmd
      )

subscriptions Model -> Sub Msg
subscriptions model =
        Phoenix.Socket.listen model.socket PhoenixMsg
