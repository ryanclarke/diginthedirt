module Model exposing (..)

import Time exposing (Time)


type Msg
    = Tick Time
    | Act Act
    | Roll Float


type Act
    = Noop
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
    , items : List Item
    }


type alias Item =
    { name : String
    , chance : Float
    }


type alias Model =
    { tickDuration : Float
    , lastTickDuration : Float
    , lastTimestamp : Time
    , actions : List Action
    , items : List Item
    , output : List String
    , inventory : List Item
    , finishedActions : List Action
    }
