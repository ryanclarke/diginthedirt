module Model exposing (..)

import Dict exposing (Dict)
import Time exposing (Posix)


type Msg
    = Tick Posix
    | StartAction String
    | Roll Float


type Progress
    = Inactive
    | At Float
    | Finished


type alias Action =
    { name : String
    , success : String
    , failure : String
    , progress : Progress
    , duration : Float
    , nullChance : Float
    , items : List String
    , recipe : Maybe (List Ingredient)
    , unlocked : Bool
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


type alias Ingredient =
    { name : String
    , quantity : Int
    }


type alias Model =
    { tickDuration : Int
    , lastTickDuration : Int
    , lastTimestamp : Int
    , actions : List Action
    , items : Dict String Item
    , output : List String
    , inventory : List InventoryItem
    , finishedActions : List Action
    }
