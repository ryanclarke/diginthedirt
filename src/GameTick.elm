module GameTick exposing (gameTick)

import Model exposing (..)
import Processor
import Time exposing (Time)


gameTick : Model -> Time -> ( Model, Cmd Msg )
gameTick model time =
    let
        sinceLastTick =
            time - model.lastTimestamp

        actions =
            model.actions
                |> List.map
                    (\a ->
                        case a.progress of
                            Inactive ->
                                a

                            At n ->
                                let
                                    pct =
                                        n - (sinceLastTick / a.duration * 100)
                                in
                                    if pct < 0 then
                                        finished a
                                    else
                                        at pct a

                            Finished ->
                                inactive a
                    )

        processedActions =
            actions
                |> List.map
                    (\a ->
                        if a |> isFinished then
                            inactive a
                        else
                            a
                    )

        allFinishedActions =
            actions
                |> List.filter isFinished
                |> List.append
                    model.finishedActions

        newModel =
            { model
                | lastTimestamp = time
                , lastTickDuration = sinceLastTick
                , actions = processedActions
                , finishedActions = allFinishedActions
            }
    in
        if List.isEmpty allFinishedActions then
            ( newModel, Cmd.none )
        else
            (Processor.finishedActions newModel)


updateProgress : Progress -> Action -> Action
updateProgress progress aaction =
    { aaction
        | progress = progress
    }


finished : Action -> Action
finished =
    updateProgress Finished


inactive : Action -> Action
inactive =
    updateProgress Inactive


at : Float -> Action -> Action
at pct =
    updateProgress (At pct)


checkProgress : Progress -> Action -> Bool
checkProgress progress action =
    action.progress == progress


isFinished : Action -> Bool
isFinished = checkProgress Finished