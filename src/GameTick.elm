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
                    (\x ->
                        case x.progress of
                            Inactive ->
                                x

                            At n ->
                                let
                                    pct =
                                        n - (sinceLastTick / x.duration * 100)
                                in
                                    if pct < 0 then
                                        { x | progress = Finished }
                                    else
                                        { x | progress = At pct }

                            Finished ->
                                { x | progress = Inactive }
                    )

        finishedActions =
                actions
                |> List.filter
                    (\x -> x.progress == Finished)

        processedActions =
            actions
                |> List.map
                    (\x ->
                        if x.progress == Finished then
                            { x | progress = Inactive }
                        else
                            x
                    )

        -- output =
        --     finishedActions
        --         |> List.map
        --             (\x -> x.name)
        --         |> List.foldr
        --             (::)
        --             model.output

        allFinishedActions =
            List.append
                model.finishedActions
                finishedActions

        newModel =
            { model
            | lastTimestamp = time
            , lastTickDuration = sinceLastTick
            , actions = processedActions
            -- , output = output
            , finishedActions = allFinishedActions
            }
    in
        if List.isEmpty allFinishedActions then
            (newModel, Cmd.none)
        else
            (Processor.finishedActions newModel)