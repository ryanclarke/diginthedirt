module View exposing (view)

import Html exposing (..)
import Html.Events exposing (on, onClick)
import Html.Attributes exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    let
        wrapper =
            (\body -> div [] [ headerView, body ])
    in
        wrapper (mainView model)


headerView : Html Msg
headerView =
    header []
        [ h1 [] [ text "Dig in the Dirt" ]
        , em []
            [ span [] [ text "a simple game written in " ]
            , a [ href "http://elm-lang.org/" ] [ text "elm" ]
            , span [] [ text " by " ]
            , a [ href "https://www.ryanclarke.net" ] [ text "Ryan Clarke" ]
            , span [] [ text ". (" ]
            , a [ href "https://github.com/ryanclarke/diginthedirt" ] [ text "source" ]
            , span [] [ text ")" ]
            ]
        ]


mainView : Model -> Html Msg
mainView model =
    div [ class "container" ]
        [ p []
            [ span [] [ text "You found: " ]
            , span [] [ text model.text ]
            ]
        , div [] (List.map btn model.actions)
        ]


btn : Action -> Html Msg
btn action =
    let
        pct =
            Maybe.withDefault 0 action.progress
                |> toString

        isDisabled =
            case action.progress of
                Just _ ->
                    { cursor = "progress"
                    , action = Act None
                    }

                Nothing ->
                    { cursor = "default"
                    , action = Act action.act
                    }
    in
        button
            [ onClick isDisabled.action
            , type_ "button"
            , style
                [ ( "background-color", "lightgray" )
                , ( "background-image", "linear-gradient(darkgray 0, darkgray 100%)" )
                , ( "background-repeat", "no-repeat" )
                , ( "background-size", pct ++ "% 100%" )
                , ( "border-color", "gray" )
                , ( "border-style", "solid" )
                , ( "width", "200px" )
                , ( "height", "40px" )
                , ( "cursor", isDisabled.cursor )
                ]
            ]
            [ text action.name ]
