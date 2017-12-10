module Model exposing (..)

import Time exposing (Time)

type Msg 
  = Tick Time
   | Action Action

type Action
  = Dig
  | Dream

type alias Model =
  { text : String 
  , tries : Int
  }


