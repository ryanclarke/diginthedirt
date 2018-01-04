module Model exposing (..)

import Time exposing (Time)


type Msg
    = Tick Time
    | Act Act
    | Completed (List Action)
    | Chance Float
    | Recieve Item


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
    }
