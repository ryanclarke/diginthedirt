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
      }
    , { name = "Dream"
      , success = "Deamed of "
      , failure = "Dreamed nothing"
      , progress = Inactive
      , duration = 5000
      , nullChance = 0
      , items = []
      , recipe = Nothing
      }
    ]
