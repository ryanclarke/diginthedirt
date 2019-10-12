module Actions exposing (all)

import Model exposing (..)


all : List Action
all =
    [ { name = "Dig"
      , success = "Digging found a "
      , failure = "Digging found nothing"
      , progress = Inactive
      , duration = 2000
      , nullChance = 25
      , items =
            [ "brick"
            , "stick"
            , "rock"
            , "string"
            , "pirate hat"
            , "cowboy hat"
            , "sombrero"
            ]
      , recipe = Nothing
      , unlocked = True
      }
    , { name = "Dream"
      , success = "Deamed of "
      , failure = "Dreamed nothing"
      , progress = Inactive
      , duration = 5000
      , nullChance = 0
      , items = []
      , recipe = Nothing
      , unlocked = True
      }
    , { name = "Build fishing pole"
      , success = "Built a "
      , failure = "Built nothing"
      , progress = Inactive
      , duration = 5000
      , nullChance = 0
      , items =
            [ "fishing pole"
            ]
      , recipe =
            Just
                [ { name = "string", quantity = 1 }
                , { name = "stick", quantity = 1 }
                ]
      , unlocked = False
      }
    ]
