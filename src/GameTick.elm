module GameTick exposing (gameTick)

import Model exposing (..)
import Processor


gameTick : Model -> Int -> ( Model, Cmd Msg )
gameTick model time =
    let
        sinceLastTick =
            time - model.lastTimestamp

        updatedActions =
            model.actions
                |> List.map
                    (updateProgress sinceLastTick)

        processedActions =
            updatedActions
                |> List.map
                    inactivatedFinished

        finishedActions =
            updatedActions
                |> List.filter isFinished
                |> List.append
                    model.finishedActions

        agedInventory =
            model.inventory
                |> List.map
                    (\i -> { i | newness = i.newness - 1 })

        newModel =
            { model
                | lastTimestamp = time
                , lastTickDuration = sinceLastTick
                , actions = processedActions
                , finishedActions = finishedActions
                , inventory = agedInventory
            }
    in
        if List.isEmpty finishedActions then
            ( newModel, Cmd.none )
        else
            ( Processor.finishedActions newModel )


updateProgress : Int -> Action -> Action
updateProgress sinceLastTick action =
    case action.progress of
        Inactive ->
            action

        At n ->
            let
                pct =
                    n - ( (toFloat sinceLastTick) / action.duration * 100)
            in
                if pct < 0 then
                    setActionProgress Finished action
                else
                    setActionProgress (At pct) action

        Finished ->
            setActionProgress Inactive action


inactivatedFinished : Action -> Action
inactivatedFinished action =
    if action |> isFinished then
        setActionProgress Inactive action
    else
        action


setActionProgress : Progress -> Action -> Action
setActionProgress progress action =
    { action
        | progress = progress
    }


checkProgress : Progress -> Action -> Bool
checkProgress progress action =
    action.progress == progress


isFinished : Action -> Bool
isFinished =
    checkProgress Finished
