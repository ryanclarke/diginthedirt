module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Model exposing (..)
import Processor exposing (isPossible)
import String exposing (fromFloat, fromInt)


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
            \body -> div [ class "container mx-auto max-w-3xl" ] [ css, headerView, body ]
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
    div [ class "flex -m-2" ]
        [ panel "Actions"
            "w-1/4"
            (div [] (model.actions |> List.filter (\a -> a.unlocked) |> List.map (btn model.inventory)))
        , panel "Action Log"
            "w-1/2"
            (div [] (actionLog model.output))
        , panel "Backpack"
            "w-1/4"
            (div [] (List.map inventoryItem model.inventory))
        ]


panel : String -> String -> Html Msg -> Html Msg
panel title width html =
    div [ class (String.append "inline m-2 mt-6 " width) ]
        [ h2
            [ class "bg-green-light rounded-t-lg border-solid border-2 border-green-dark border-b-0 p-1 text-center" ]
            [ text title ]
        , div
            [ class "border-solid border-2 border-green-dark border-t-0" ]
            [ div
                [ class "p-4" ]
                [ html ]
            ]
        ]


btn : List InventoryItem -> Action -> Html Msg
btn inventory action =
    let
        ( pct, isProgressing, color ) =
            case action.progress of
                At n ->
                    ( n |> fromFloat
                    , { cursor = "progress"
                      , action = StartAction ""
                      }
                    , "border-black text-black"
                    )

                _ ->
                    ( "0"
                    , { cursor = "default"
                      , action = StartAction action.name
                      }
                    , if isPossible inventory action.recipe then
                        "border-black text-black"

                      else
                        "border-gray-400 text-gray-400"
                    )
    in
    button
        [ onClick isProgressing.action
        , type_ "button"
        , class ("rounded-full p-2 m-2 w-32 border-solid border " ++ color)
        , style "background-color" "transparent"
        , style "background-image" "linear-gradient(lightgray 0, lightgray 100%)"
        , style "background-repeat" "no-repeat"
        , style "background-size" (pct ++ "% 100%")
        , style "cursor" isProgressing.cursor
        ]
        [ text action.name ]


actionLog : List String -> List (Html Msg)
actionLog output =
    let
        grad =
            [ "#000"
            , "#666"
            , "#777"
            , "#888"
            , "#999"
            , "#aaa"
            , "#bbb"
            , "#ccc"
            , "#ddd"
            , "#eee"
            ]
    in
    output
        |> List.take 10
        |> List.map2
            (\c t ->
                p
                    [ style "color" c ]
                    [ text t ]
            )
            grad


inventoryItem : InventoryItem -> Html Msg
inventoryItem item =
    let
        ani =
            if item.newness > 0 then
                "bg-green-200"

            else
                ""
    in
    div [ class ("w-full " ++ ani) ]
        [ img
            [ src (String.concat [ "svg/", item.icon, ".svg" ])
            , class "inline mr-2 w-4"
            ]
            []
        , div [ class "align-top inline w-1/2" ] [ text item.name ]
        , div [ class "align-top float-right inline" ] [ item.quantity |> fromInt |> text ]
        ]
