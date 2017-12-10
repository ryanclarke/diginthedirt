module View exposing (view)

import Html exposing (..)
import Html.Events exposing (on, onClick)
import Html.Attributes exposing (..)
import Svg exposing (Svg, svg, rect, g)
-- import Svg.Attributes exposing (..)

import Model exposing (..)
import Json.Decode as Decode

view : Model -> Html Msg
view model =
  let
    wrapper = (\body -> div [] [ headerView, body ])
  in
    wrapper (mainView model)

headerView : Html Msg
headerView =
  header []
    [ h1 [] [ text "Dig in the Dirt" ]
    , em []
      [ span [] [ text "a simple game written in " ]
      , a [ href "http://elm-lang.org/" ] [ text "elm" ]
      , span [] [ text " by " ]
      , a [ href "https://www.ryanclarke.net" ] [ text "Ryan Clarke" ]
      , span [] [ text ". (" ]
      , a [ href "https://gitlab.com/ryanclarke/diginthedirt" ] [ text "source" ]
      , span [] [ text ")" ]
      ]
    ]

mainView : Model -> Html Msg
mainView model =
  div [ class "container" ]
    [ p [ class "flex mb-4"] 
      [ span [] [ text "You found: " ]
      , span [] [ text model.text ]
      ]
    , btn Dig "Dig"
    ]

btn : Action -> String -> Html Msg
btn action label =
  button [ onClick (Action action) ] [ text label ]

