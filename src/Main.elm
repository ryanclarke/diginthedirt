module Main exposing (main)

import Html exposing (program)
import Time exposing (every, millisecond)
import Model exposing (..)
import Update exposing (update)
import View exposing (view)


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : ( Model, Cmd msg )
init =
    let
        model =
            { tickDuration = 20
            , lastTickDuration = 0
            , lastTimestamp = 0
            , actions =
                [ { act = Dig
                  , name = "Dig"
                  , progress = Inactive
                  , duration = 2000
                  }
                , { act = Dream
                  , name = "Dream"
                  , progress = Inactive
                  , duration = 5000
                  }
                ]
            , output = ["Nothing"]
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
            [ every (delay * millisecond) Tick
            ]
