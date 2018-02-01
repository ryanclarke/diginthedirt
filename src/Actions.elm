module Actions exposing (all)

import Model exposing (..)


all : List Action
all =
    [ { act = Dig
      , name = "Dig"
      , progress = Inactive
      , duration = 2000
      , items =
            [ { name = "dirt"
              , chance = 10
              }
            , { name = "brick"
              , chance = 5
              }
            ]
      }
    , { act = Dream
      , name = "Dream"
      , progress = Inactive
      , duration = 5000
      , items = []
      }
    ]
