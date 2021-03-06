module ElmHtml.ToString
    exposing
        ( nodeToString
        , nodeRecordToString
        , nodeToStringWithOptions
        , FormatOptions
        , defaultFormatOptions
        )

{-| Convert ElmHtml to string.

@docs nodeRecordToString, nodeToString, nodeToStringWithOptions

@docs FormatOptions, defaultFormatOptions
-}

import String
import Dict exposing (Dict)
import ElmHtml.InternalTypes exposing (..)


{-| Formatting options to be used for converting to string
-}
type alias FormatOptions =
    { indent : Int
    , newLines : Bool
    }


{-| default formatting options
-}
defaultFormatOptions : FormatOptions
defaultFormatOptions =
    { indent = 0
    , newLines = False
    }


nodeToLines : FormatOptions -> ElmHtml -> List String
nodeToLines options nodeType =
    case nodeType of
        TextTag { text } ->
            [ text ]

        NodeEntry record ->
            nodeRecordToString options record

        CustomNode record ->
            []

        MarkdownNode record ->
            [ record.model.markdown ]

        NoOp ->
            []


{-| Convert a given html node to a string based on the type
-}
nodeToString : ElmHtml -> String
nodeToString =
    nodeToStringWithOptions defaultFormatOptions


{-| same as nodeToString, but with options
-}
nodeToStringWithOptions : FormatOptions -> ElmHtml -> String
nodeToStringWithOptions options =
    nodeToLines options
        >> String.join
            (if options.newLines then
                "\n"
             else
                ""
            )


{-| Convert a node record to a string. This basically takes the tag name, then
    pulls all the facts into tag declaration, then goes through the children and
    nests them under this one
-}
nodeRecordToString : FormatOptions -> NodeRecord -> List String
nodeRecordToString options { tag, children, facts } =
    let
        openTag : List (Maybe String) -> String
        openTag extras =
            let
                trimmedExtras =
                    List.filterMap (\x -> x) extras
                        |> List.map String.trim
                        |> List.filter ((/=) "")

                filling =
                    case trimmedExtras of
                        [] ->
                            ""

                        more ->
                            " " ++ (String.join " " more)
            in
                "<" ++ tag ++ filling ++ ">"

        closeTag =
            "</" ++ tag ++ ">"

        childrenStrings =
            List.map (nodeToLines options) children
                |> List.concat
                |> List.map ((++) (String.repeat options.indent " "))

        styles =
            case Dict.toList facts.styles of
                [] ->
                    Nothing

                styles ->
                    styles
                        |> List.map (\( key, value ) -> key ++ ":" ++ value ++ ";")
                        |> String.join ""
                        |> (\styleString -> "style=\"" ++ styleString ++ "\"")
                        |> Just

        classes =
            Dict.get "className" facts.stringAttributes
                |> Maybe.map (\name -> "class=\"" ++ name ++ "\"")

        stringAttributes =
            Dict.filter (\k v -> k /= "className") facts.stringAttributes
                |> Dict.toList
                |> List.map (\( k, v ) -> k ++ "=\"" ++ v ++ "\"")
                |> String.join " "
                |> Just

        boolAttributes =
            Dict.toList facts.boolAttributes
                |> List.map (\( k, v ) -> k ++ "=" ++ (String.toLower <| toString v))
                |> String.join " "
                |> Just
    in
        case toElementKind tag of
            {- Void elements only have a start tag; end tags must not be
               specified for void elements.
            -}
            VoidElements ->
                [ openTag [ classes, styles, stringAttributes, boolAttributes ] ]

            {- TODO: implement restrictions for RawTextElements,
               EscapableRawTextElements. Also handle ForeignElements correctly.
               For now just punt and use the previous behavior for all other
               element kinds.
            -}
            _ ->
                [ openTag [ classes, styles, stringAttributes, boolAttributes ] ]
                    ++ childrenStrings
                    ++ [ closeTag ]
