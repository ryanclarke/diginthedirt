module Actions exposing (all)

import Model exposing (..)


all : List Action
all =
    [ { actionType = Dig
      , name = "Dig"
      , success = "Digging found "
      , failure = "Digging found nothing"
      , progress = Inactive
      , duration = 2000
      , nullChance = 10
      , items =
            [ { name = "brick"
              , chance = 5
              , icon = "brick-pile"
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
