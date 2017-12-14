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
                None ->
                    ( model, Cmd.none )

                _ ->
                    startAct model act


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
                            Just i ->
                                let
                                    pct =
                                        i - (sinceLastTick / x.duration * 100)
                                in
                                    if pct < 0 then
                                        { x | progress = Nothing }
                                    else
                                        { x | progress = Just pct }

                            Nothing ->
                                x
                    )
    in
        ( { model
            | lastTimestamp = time
            , lastTickDuration = sinceLastTick
            , actions = actions
          }
        , Cmd.none
        )


startAct : Model -> Act -> ( Model, Cmd Msg )
startAct model act =
    let
        initialize action =
            if action.act == act then
                { action | progress = Just 100 }
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
