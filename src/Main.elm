module Main exposing (..)

import Html exposing (Html, text, div, img)
import UrlParser exposing (s)
import Navigation
import Page.Home


---- MODEL ----


type alias Model =
    { currentPage : PageState
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        ( page, cmd ) =
            parseLocationToPage location
    in
        Model page ! [ cmd ]



---- UPDATE ----


type Msg
    = UrlChange Navigation.Location
    | HomePageMsg Page.Home.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            model ! []

        HomePageMsg homeMsg ->
            case model.currentPage of
                HomePage homeModel ->
                    let
                        ( model_, msg_ ) =
                            Page.Home.update homeMsg homeModel
                    in
                        { model | currentPage = HomePage model_ } ! [ Cmd.map HomePageMsg msg_ ]

                _ ->
                    Debug.crash "Got a message for another page"


type PageState
    = HomePage Page.Home.Model
    | NotFoundPage


type Route
    = Home
    | NotFound


parseLocationToPage : Navigation.Location -> ( PageState, Cmd Msg )
parseLocationToPage location =
    case fromLocation location of
        Home ->
            let
                ( model, cmd ) =
                    Page.Home.init
            in
                HomePage model ! [ Cmd.map HomePageMsg cmd ]

        NotFound ->
            NotFoundPage ! []


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
    case model.currentPage of
        HomePage model_ ->
            Page.Home.view model_ |> Html.map HomePageMsg

        NotFoundPage ->
            Html.h1 [] [ Html.text "Page not found" ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
