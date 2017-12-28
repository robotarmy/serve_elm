port module Presence exposing (..)

import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Encode exposing (Value)
import Debug exposing (log)


port elmInbox : (Value -> msg) -> Sub msg


type alias Model =
    { socket : Phoenix.Socket.Socket Msg
    }


type Msg
    = PhoenixMsg (Phoenix.Socket.Msg Msg)
    | JSMessage Value
    | ReceiveMessage Value


socketServer : String
socketServer =
    -- http://web.production-elixir-service.36cf5ace.svc.dockerapp.io:8080/socket/websocket
    "wss://localhost:4430/socket/websocket"


initSocket : Phoenix.Socket.Socket Msg
initSocket =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.on "presence" "homepage" receiveMessage


receiveMessage : Value -> Msg
receiveMessage value =
    ReceiveMessage value


init : ( Model, Cmd Msg )
init =
    let
        ( socket, cmd ) =
            joinChannel initSocket
    in
        ( { socket = socket }, Cmd.map PhoenixMsg cmd )


main =
    Platform.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        }


update msg model =
    case msg of
        PhoenixMsg msg ->
            let
                a =
                    log "phoenixmsg" msg
            in
                ( model, Cmd.none )

        ReceiveMessage value ->
            let
                a =
                    log "receivemessage" value
            in
                ( model, Cmd.none )

        JSMessage value ->
            let
                a =
                    log "jsmessage" value
            in
                ( model, Cmd.none )


joinChannel : Phoenix.Socket.Socket Msg -> ( Phoenix.Socket.Socket Msg, Cmd (Phoenix.Socket.Msg Msg) )
joinChannel aSocket =
    let
        channel =
            Phoenix.Channel.init "homepage"
    in
        Phoenix.Socket.join channel aSocket


updatePhoenixMsg : Model -> Phoenix.Socket.Msg Msg -> ( Model, Cmd Msg )
updatePhoenixMsg model msg =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.update (log "msg" msg) model.socket
    in
        ( { model | socket = phxSocket }
        , Cmd.map PhoenixMsg phxCmd
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ elmInbox JSMessage
        , Phoenix.Socket.listen model.socket PhoenixMsg
        ]
