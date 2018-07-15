module Main exposing (..)

import Html exposing (Html, text, div, img)
import UrlParser exposing (s)
import Navigation


---- MODEL ----


type alias Model =
    { history : List Route }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    Model [ fromLocation location ] ! [ Cmd.none ]



---- UPDATE ----


type Msg
    = UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            { model | history = (fromLocation location) :: model.history } ! []


type Route
    = Home
    | NotFound


urlParser : UrlParser.Parser (Route -> a) a
urlParser =
    UrlParser.oneOf
        [ UrlParser.map Home (s "home")
        ]


fromLocation : Navigation.Location -> Route
fromLocation location =
    UrlParser.parsePath urlParser location
        |> Maybe.withDefault NotFound



---- VIEW ----


view : Model -> Html Msg
view model =
    div [] [ text (toString model) ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
