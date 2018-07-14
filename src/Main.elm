module Main exposing (..)

import Html exposing (Html, text, div, img)
import Html.Attributes exposing (src)
import Navigation


---- MODEL ----


type alias Model =
    { history : List Navigation.Location }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    Model [ location ] ! [ Cmd.none ]



---- UPDATE ----


type Msg
    = UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ( { model | history = location :: model.history }
            , Cmd.none
            )



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
