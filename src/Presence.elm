port module Presence exposing (..)

import Dict
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Phoenix.Presence exposing (PresenceState, syncState, syncDiff, presenceStateDecoder, presenceDiffDecoder)
import Json.Decode exposing (decodeValue)
import Json.Encode exposing (Value, string, object)
import Debug exposing (log)


port presenceInbox : (Value -> msg) -> Sub msg


port identityInbox : Value -> Cmd msg


type alias Identity =
    { id : String
    , token : String
    , created_online_at : String
    }


type alias UserPresence =
    { phx_ref : String
    , user_ref : String
    }


type alias Model =
    { socket : Phoenix.Socket.Socket Msg
    , phxPresences : PresenceState UserPresence
    }


type Msg
    = PhoenixMsg (Phoenix.Socket.Msg Msg)
    | JSMessage Value
    | ReceiveMessage Value
    | RegisterSelf Value


socketServer : String
socketServer =
    -- http://web.production-elixir-service.36cf5ace.svc.dockerapp.io:8080/socket/websocket
    "wss://localhost:4430/socket/websocket"


initSocket : Phoenix.Socket.Socket Msg
initSocket =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.on "incoming" "presence:elm" ReceiveMessage
        |> Phoenix.Socket.on "register:self" "presence:elm" RegisterSelf


init : ( Model, Cmd Msg )
init =
    let
        ( socket, cmd ) =
            joinChannel initSocket
    in
        ( { socket = socket
          , phxPresences = Dict.empty
          }
        , Cmd.map PhoenixMsg cmd
        )


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

        RegisterSelf value ->
            case decodeValue identityDecoder value of
                Ok identity ->
                    let
                        sendIdentityCmd =
                            identityInbox
                                (object
                                    [ ( "id"
                                      , string identity.id
                                      )
                                    , ( "created_online_at"
                                      , string identity.created_online_at
                                      )
                                    , ( "token"
                                      , string identity.token
                                      )
                                    ]
                                )

                        loopBackCmd =
                            Cmd.none
                    in
                        ( model
                        , Cmd.batch [ sendIdentityCmd, loopBackCmd ]
                        )

                Err error ->
                    let
                        _ =
                            Debug.log "Error[RegisterSelf]" error
                    in
                        model ! []


identityDecoder : Json.Decode.Decoder Identity
identityDecoder =
    Json.Decode.map3 Identity
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "token" Json.Decode.string)
        (Json.Decode.field "created_online_at" Json.Decode.string)


joinChannel : Phoenix.Socket.Socket Msg -> ( Phoenix.Socket.Socket Msg, Cmd (Phoenix.Socket.Msg Msg) )
joinChannel aSocket =
    let
        channel =
            Phoenix.Channel.init "presence:elm"
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
        [ presenceInbox JSMessage
        , Phoenix.Socket.listen model.socket PhoenixMsg
        ]
