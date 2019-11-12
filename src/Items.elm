module Items exposing (all)

import Dict exposing (Dict)
import Model exposing (..)


all : Dict String Item
all =
    [ { name = "brick"
      , chance = 10
      , icon = "stone-block"
      }
    , { name = "stick"
      , chance = 25
      , icon = "wood-stick"
      }
    , { name = "rock"
      , chance = 25
      , icon = "rock"
      }
    , { name = "string"
      , chance = 10
      , icon = "whiplash"
      }
    , { name = "paperclip"
      , chance = 10
      , icon = "paper-clip"
      }
    , { name = "pirate hat"
      , chance = 1
      , icon = "pirate-hat"
      }
    , { name = "cowboy hat"
      , chance = 1
      , icon = "western-hat"
      }
    , { name = "sombrero"
      , chance = 1
      , icon = "sombrero"
      }
    , { name = "fishing pole"
      , chance = 1
      , icon = "fishing-pole"
      }
    ]
        |> List.map (\x -> ( x.name, x ))
        |> Dict.fromList
