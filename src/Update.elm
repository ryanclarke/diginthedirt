module Update exposing (update)

import Time exposing (..)
import GameTick exposing (gameTick)
import Model exposing (..)
import Processor exposing (finishedAction, isPossible)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            Time.posixToMillis time |> gameTick model

        StartAction actionType ->
            startAction model actionType

        Roll chance ->
            finishedAction model chance


startAction : Model -> String -> ( Model, Cmd Msg )
startAction model actionName =
    let
        initialize action =
            if action.name == actionName && isPossible model.inventory action.recipe then
                { action | progress = At 100 }
            else
                action

        recipe =
            model.actions
            |> List.filter (\a -> a.name == actionName)
            |> List.head
            |> Maybe.andThen (\a -> a.recipe)

        newInventory =
            if isPossible model.inventory recipe then
                model.inventory
                    |> List.map (\x -> 
                        recipe
                            |> Maybe.withDefault []
                            |> List.filter (\i -> i.name == x.name)
                            |> List.head
                            |> Maybe.andThen (\m ->
                                    Just { x
                                    | quantity = x.quantity - m.quantity
                                    }
                                )
                            |> Maybe.withDefault x
                    )
            else
                model.inventory

        actions =
            model.actions
                |> List.map initialize

    in
        ( { model
          | actions = actions
          , inventory = newInventory
          }
        , Cmd.none
        )

