module Items exposing (all)

import Model exposing (..)
import Dict exposing (..)


all : Dict String Item
all =
    [ { name = "brick"
      , chance = 10
      , icon = "brick-pile"
      }
    , { name = "stick"
      , chance = 25
      , icon = "tree-branch"
      }
    , { name = "rock"
      , chance = 25
      , icon = "stone-pile"
      }
    , { name = "string"
      , chance = 10
      , icon = "whiplash"
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
      , icon = "brick-pile"
      }
    ]
        |> List.map (\x -> ( x.name, x ))
        |> Dict.fromList
