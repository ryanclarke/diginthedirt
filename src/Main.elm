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

init : (Model, Cmd msg)
init =
  let
    model = 
      { text = "For my girls"
      , tries = 0
      , tickDuration = 20
      , lastTickDuration = 0
      , lastTimestamp = 0
      , actions =
        [ { act = Dig
          , name = "Dig"
          , progress = Nothing
          , duration = 2000
          }
        , { act = Dream
          , name = "Dream"
          , progress = Nothing
          , duration = 5000
          }
        ]
      }
  in
    (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  let
    delay =
      model.tickDuration
  in
    Sub.batch
      [ every (delay * millisecond) Tick
      ]


