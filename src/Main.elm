module Main exposing (main)

import Actions
import Browser
import Items exposing (all)
import Model exposing (Model, Msg(..))
import Time exposing (every)
import Update exposing (update)
import View exposing (view)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : () -> ( Model, Cmd msg )
init _ =
    let
        model =
            { tickDuration = 20
            , lastTickDuration = 0
            , lastTimestamp = 0
            , actions = Actions.all
            , items = Items.all
            , output = List.range 0 9 |> List.map (\x -> " ")
            , inventory = []
            , finishedActions = []
            }
    in
        ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        delay =
            model.tickDuration
    in
        Sub.batch
            [ every (toFloat delay) Tick
            ]
