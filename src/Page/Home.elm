module Page.Home exposing (Model, init, Msg, update, view)

import Html exposing (Html)
import Html.Events exposing (onClick)


type Model
    = Loaded LoadedModel


type alias LoadedModel =
    Int


type Msg
    = Increment
    | Decrement


init : ( Model, Cmd Msg )
init =
    Loaded 1 ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        Loaded loadedModel ->
            let
                ( loadedModel_, cmd ) =
                    updateLoadedModel msg loadedModel
            in
                Loaded loadedModel_ ! [ cmd ]


updateLoadedModel : Msg -> LoadedModel -> ( LoadedModel, Cmd Msg )
updateLoadedModel msg loadedModel =
    case msg of
        Increment ->
            (loadedModel + 1) ! []

        Decrement ->
            (loadedModel - 1) ! []


view : Model -> Html Msg
view model =
    case model of
        Loaded model_ ->
            viewLoadedModel model_


viewLoadedModel : LoadedModel -> Html Msg
viewLoadedModel model =
    Html.div []
        [ Html.button [ onClick Increment ] [ Html.text "Increment" ]
        , Html.h2 [] [ Html.text (toString model) ]
        , Html.button [ onClick Decrement ] [ Html.text "Decrement" ]
        ]
