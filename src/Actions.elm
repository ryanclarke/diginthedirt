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
      , nullChance = 25
      , items =
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
            ]
      , recipe = Nothing
      }
    , { actionType = Dream
      , name = "Dream"
      , success = "Deamed of "
      , failure = "Dreamed nothing"
      , progress = Inactive
      , duration = 5000
      , nullChance = 0
      , items = []
      , recipe = Nothing
      }
    ]
