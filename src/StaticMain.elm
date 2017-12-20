module StaticMain exposing(..)
import View
import Model exposing(..)
import Html exposing(Html)
import Routing exposing (parse)
import Messages exposing (Msg)
import Decoders
import Json.Decode
model: Model
model =
    let
        --
        -- The Contact Program expects that It will be
        -- able to access the location object
        -- through the Navigation Program interface
        -- that "Main.elm" uses.
        --
        -- In the Static version this is executing on
        -- the server via elm-static-html-lib and
        -- so there will be no Navigation Program
        -- setting up the default Location.
        --
        -- Another implication of executing client code
        -- on the server is that their actuall is no
        -- window.location browser object.
        --
        -- The wrapper script that executes
        -- elm-static-html-lib
        --
        -- needs to establish window.location so that
        -- the Navigation elm code that is part of
        -- the Model definition can operate as if it
        -- was running on a client.

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
--
--
-- Because elm is "Staticly Typed" JSON objects
-- must be fully qualitied by an Elm type and a
-- function must exist to "Marshal" the data from
-- its "wire format" into the Elm type system.
--
--
decodeModel: Json.Decode.Decoder ContactList
decodeModel = Decoders.contactListDecoder


--
-- Elm Static Html Library gives me the ability
-- to execute any elm function I wish that will
-- return "Html Msg" type.
--
-- I need to also input a json structure that will
-- be passed through the decoder function and
-- become the decoders Type - this is important
-- because the "idiomatic" view function in elm
-- takes a single argument that represents a
-- "model"
--
view: ContactList -> Html Msg
view contactList =
    View.view { model | contactList = Success contactList}


