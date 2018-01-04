module Update exposing (update)

import Time exposing (Time)
import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            gameTick model time

        Act act ->
            startAct model act
        
        _ ->
            (model, Cmd.none)


gameTick : Model -> Time -> ( Model, Cmd Msg )
gameTick model time =
    let
        sinceLastTick =
            time - model.lastTimestamp

        totalChance =
            model.items
            |> List.map
                (\y -> y.chance)
            |> List.sum

        finishedActions =
            model.actions
            |> List.filter
                (\x -> x.progress == Finished )

        -- inventory =
        --     finishedActions
        --     |> List.map
        --         (\x ->
        --             model.items
        --             |> List.filter
        --             |> 
        --         )
        --     |> List.foldl
        --         (::)
        --         model.inventory

        output =
            finishedActions
            |> List.map
                (\x -> x.name )
            |> List.foldr
                (::)
                model.output

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

        tweakI : Action -> Model -> Model
        tweakI action model =
            { model
            | inventory = (List.append model.inventory model.items)
            }

        inventory = 
            (model.actions
            |> List.filter
                (\x -> x.progress == Finished )
            |> List.foldr
                tweakI
                model).inventory
            
    in
        ( { model
            | lastTimestamp = time
            , lastTickDuration = sinceLastTick
            , actions = actions
            , output = output
            , inventory = inventory
          }
        , Cmd.none
        )


startAct : Model -> Act -> ( Model, Cmd Msg )
startAct model act =
    let
        initialize action =
            if action.act == act then
                { action | progress = At 100 }
            else
                action

        actions =
            model.actions
                |> List.map initialize
    in
        case act of
            Noop ->
                ( model, Cmd.none )

            _ ->
                ( { model
                    | actions = actions
                }
                , Cmd.none
                )
