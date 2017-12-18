
port module PrivateMain423af06d5326eac851ea30e6ddf46216 exposing (..)

import Platform
import Html exposing (Html)
import ElmHtml.InternalTypes exposing (decodeElmHtml)
import ElmHtml.ToString exposing (nodeToStringWithOptions, defaultFormatOptions)
import Json.Decode as Json
import Native.Jsonify

import StaticMain
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
init values =
    case Json.decodeValue StaticMain.decodeModel values of
        Err err -> ((), htmlOut423af06d5326eac851ea30e6ddf46216 ("ERROR:" ++ err))
        Ok model ->
            ((), htmlOut423af06d5326eac851ea30e6ddf46216 <| decode <| StaticMain.viewWithModel model)


main = Platform.programWithFlags
    { init = init
    , update = (\_ b -> (b, Cmd.none))
    , subscriptions = (\_ -> Sub.none)
    }

port htmlOut423af06d5326eac851ea30e6ddf46216 : String -> Cmd msg
