module View exposing (view)

import Html exposing (..)
import Html.Events exposing (on, onClick)
import Html.Attributes exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    let
        css =
            Html.node "link"
                [ Html.Attributes.rel "stylesheet"
                , Html.Attributes.href "https://cdn.jsdelivr.net/npm/tailwindcss/dist/tailwind.min.css"
                ]
                []

        wrapper =
            (\body -> div [ class "container mx-auto    " ] [ css, headerView, body ])
    in
        wrapper (mainView model)


headerView : Html Msg
headerView =
    header
        [ class "bg-green-dark p-4 text-justify w-full" ]
        [ h1
            [ class "text-white inline pr-4" ]
            [ text "Dig in the Dirt" ]
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
    div [ class "text-center flex -m-2" ]
        [ panel "Actions"
            (div [] (List.map btn model.actions))
        , panel "Action Log"
            (div [] (List.map (\x -> p [] [ text x ]) model.output ))
        , panel "Inventory"
            (div [] (List.map (\x -> p [] [ text x.name ]) model.inventory ))
        ]


panel : String -> Html Msg -> Html Msg
panel title html =
    div [ class "w-1/2 inline m-2 mt-6" ]
        [ h2
            [ class "bg-green-light rounded-t-lg border-solid border-2 border-green-dark border-b-0 p-1" ]
            [ text title ]
        , div
            [ class "border-solid border-2 border-green-dark border-t-0" ]
            [ html ]
        ]


btn : Action -> Html Msg
btn action =
    let
        ( pct, isDisabled ) =
            case action.progress of
                At n ->
                    ( n |> toString
                    , { cursor = "progress"
                      , action = Act Noop
                      }
                    )

                _ ->
                    ( "0"
                    , { cursor = "default"
                      , action = Act action.act
                      }
                    )
    in
        button
            [ onClick isDisabled.action
            , type_ "button"
            , class "rounded-full p-2 m-2 w-32 border-solid border border-black"
            , style
                [ ( "background-color", "transparent" )
                , ( "background-image", "linear-gradient(lightgray 0, lightgray 100%)" )
                , ( "background-repeat", "no-repeat" )
                , ( "background-size", pct ++ "% 100%" )
                , ( "cursor", isDisabled.cursor )
                ]
            ]
            [ text action.name ]
