module Model exposing (..)

import Time exposing (Time)


type Msg
    = Tick Time
    | Act Act


type Act
    = Idle
    | Dig
    | Dream


type Progress
    = Inactive
    | At Float
    | Finished


type alias Action =
    { act : Act
    , name : String
    , progress : Progress
    , duration : Float
    }


type alias Model =
    { tickDuration : Float
    , lastTickDuration : Float
    , lastTimestamp : Time
    , actions : List Action
    , output : List String
    }
