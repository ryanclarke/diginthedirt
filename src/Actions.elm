module Actions exposing (all)

import Model exposing (..)


all : List Action
all =
    [ { actionType = Dig
      , name = "Dig"
      , success = "Digging found a "
      , failure = "Digging found nothing"
      , progress = Inactive
      , duration = 2000
      , nullChance = 10
      , items =
            [ { name = "brick"
              , chance = 5
              , icon = "brick-pile"
              }
            , { name = "stick"
              , chance = 10
              , icon = "tree-branch"
              }
            , { name = "rock"
              , chance = 10
              , icon = "stone-pile"
              }
            , { name = "pirate hat"
              , chance = 1
              , icon = "pirate-hat"
              }
            ]
      }
    , { actionType = Dream
      , name = "Dream"
      , success = "Deamed of "
      , failure = "Dreamed nothing"
      , progress = Inactive
      , duration = 5000
      , nullChance = 0
      , items = []
      }
    ]
