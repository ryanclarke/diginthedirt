module Model exposing (..)

import Time exposing (Time)


type Msg
    = Tick Time
    | StartAction ActionType
    | Roll Float


type ActionType
    = Noop
    | Dig
    | Dream


type Progress
    = Inactive
    | At Float
    | Finished


type alias Action =
    { actionType : ActionType
    , name : String
    , success : String
    , failure : String
    , progress : Progress
    , duration : Float
    , nullChance : Float
    , items : List Item
    }


type alias Item =
    { name : String
    , chance : Float
    , icon : String
    }

type alias InventoryItem =
    { name : String
    , icon : String
    , quantity : Int
    , newness : Float
    }


type alias Model =
    { tickDuration : Float
    , lastTickDuration : Float
    , lastTimestamp : Time
    , actions : List Action
    , items : List Item
    , output : List String
    , inventory : List InventoryItem
    , finishedActions : List Action
    }
