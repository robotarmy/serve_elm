
port module PrivateMainef19abcd484c249fb42d9301440e34a7 exposing (..)

import Platform
import Html exposing (Html)
import ElmHtml.InternalTypes exposing (decodeElmHtml)
import ElmHtml.ToString exposing (nodeToStringWithOptions, defaultFormatOptions)
import Json.Decode as Json
import Native.Jsonify

import StaticMain



asJsonView : Html msg -> Json.Value
asJsonView = Native.Jsonify.stringify

options = { defaultFormatOptions | newLines = True, indent = 4 }

decode : Html msg -> String
decode view =
    case Json.decodeValue decodeElmHtml (asJsonView view) of
        Err str -> "ERROR:" ++ str
        Ok str -> nodeToStringWithOptions options str


init : Json.Value -> ((), Cmd msg)
init _ =
    ((), htmlOutef19abcd484c249fb42d9301440e34a7 <| decode <| StaticMain.view)


main = Platform.programWithFlags
    { init = init
    , update = (\_ b -> (b, Cmd.none))
    , subscriptions = (\_ -> Sub.none)
    }

port htmlOutef19abcd484c249fb42d9301440e34a7 : String -> Cmd msg
