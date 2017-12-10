module Model exposing (..)

import Time exposing (Time)

type Msg 
  = Tick Time
   | Act Act

type Act
  = None
  | Dig
  | Dream

type alias Action =
  { act : Act
  , name : String
  , progress : Maybe Float
  , duration : Float
  }

type alias Model =
  { text : String 
  , tries : Int
  , tickDuration : Float
  , lastTickDuration : Float
  , lastTimestamp : Time
  , actions : List Action
  }
