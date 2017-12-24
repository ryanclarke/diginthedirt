module Update exposing (update)

import Time exposing (Time)
import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            gameTick model time

        Act act ->
            case act of
                Idle ->
                    ( model, Cmd.none )

                _ ->
                    startAct model act


gameTick : Model -> Time -> ( Model, Cmd Msg )
gameTick model time =
    let
        sinceLastTick =
            time - model.lastTimestamp

        output =
            model.actions
                |> List.filter
                    (\x -> x.progress == Finished )
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
    in
        ( { model
            | lastTimestamp = time
            , lastTickDuration = sinceLastTick
            , actions = actions
            , output = output
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
        ( { model
            | actions = actions
          }
        , Cmd.none
        )
