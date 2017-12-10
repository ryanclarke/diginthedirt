module Update exposing (update)

import Time exposing (Time)
-- import Array
-- import Keyboard exposing (KeyCode)
-- import Random
-- import Char

import Model exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick time ->
      gameTick model time
    Act act ->
      case act of 
        None ->
          (model, Cmd.none)
        Dig ->
          dig model
        Dream ->
          dig model

gameTick : Model -> Time -> (Model, Cmd Msg)
gameTick model time =
  let
    sinceLastTick =
      time - model.lastTimestamp
    actions =
      model.actions
      |> List.map
        (\x ->
          case x.progress of
            Just i ->
              let
                pct = i - (sinceLastTick / x.duration * 100)
              in
                if pct < 0 then
                  { x | progress = Nothing }
                else
                  { x | progress = Just pct }
            Nothing ->
              x
        )
  in  
    ( { model
      | lastTimestamp = time
      , lastTickDuration = sinceLastTick
      , actions = actions
      }
    , Cmd.none
    )
    
dig : Model -> (Model, Cmd Msg)
dig model =
  let
    tries = model.tries + 1
    text = toString tries
    actions =
      model.actions
      |> List.map
        (\x -> 
          case x.act of
            Dig ->
              { x | progress = Just 100}
            _ ->
              x
        )
  in
    ( { model
      | text = text
      , tries = tries
      , actions = actions
      }
    , Cmd.none
    )

