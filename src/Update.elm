module Update exposing (update)

import GameTick exposing (gameTick)
import Model exposing (..)
import Processor exposing (finishedAction)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            gameTick model time

        StartAction actionType ->
            startAction model actionType

        Roll chance ->
            finishedAction model chance


startAction : Model -> String -> ( Model, Cmd Msg )
startAction model actionName =
    let
        initialize action =
            if action.name == actionName then
                { action | progress = At 100 }
            else
                action

        actions =
            model.actions
                |> List.map initialize

    in
        ( { model
          | actions = actions
          }
        , Cmd.none
        )

