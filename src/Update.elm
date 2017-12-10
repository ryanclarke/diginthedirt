module Update exposing (update)

import Array
import Keyboard exposing (KeyCode)
import Random
import Char

import Model exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick _ ->
      gameTick model
    Action a ->
      case a of 
        Dig ->
          dig model
        Dream ->
          dig model

gameTick : Model -> (Model, Cmd Msg)
gameTick model =
  ( model
  , Cmd.none
  )
    
dig : Model -> (Model, Cmd Msg)
dig model =
  let
    tries = model.tries + 1
    text = toString tries
  in
    ( { model
      | text = text
      , tries = tries
      }
    , Cmd.none
    )

