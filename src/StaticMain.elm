module StaticMain exposing(..)
import View
import Model exposing(..)
import Html exposing(Html)
import Routing exposing (parse)
import Messages exposing (Msg)
import Decoders

model: Model
model =
    let
        location = -- looks like Navigation.Location
            { href     = ""
            , host     = "0.0.0.0"
            , hostname = "localhost"
            , protocol = "http"
            , origin   = ""
            , port_    = "4000"
            , pathname = "/"
            , search   = ""
            , hash     = ""
            , username = ""
            , password = ""
            }
        route = parse location
    in
        Model.initialModel route

decodeModel = Decoders.contactListDecoder

view: Html Msg
view = View.view model

viewWithModel: ContactList -> Html Msg
viewWithModel contactList = View.view {model| contactList = Success contactList}


