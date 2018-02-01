module Update exposing (update)

import Random
import Time exposing (Time)
import Model exposing (..)


type alias Acc =
    { chance : Float
    , item : Maybe Item
    }


tryItemForSuccess : Item -> Acc -> Acc
tryItemForSuccess item acc =
    let
        newChance =
            acc.chance - item.chance

        newItem =
            if newChance <= 0 then
                Just (Maybe.withDefault item acc.item)
            else
                Nothing

    in
        { chance = newChance
        , item = newItem
        } 



getItemFromChance : Float -> List Item -> Maybe Item
getItemFromChance chance items =
    let
        seed =
            { chance = chance, item = Nothing }

        result =
            List.foldl tryItemForSuccess seed items

    in
        if result.chance <= 0 then
            result.item
        else
            Nothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            gameTick model time

        Act act ->
            startAct model act

        Roll chance ->
            roll model chance


roll : Model -> Float -> ( Model, Cmd Msg )
roll model f =
    let
        newInventoryItem =
            case List.head model.finishedActions of
                Nothing ->
                    Just {name = "air", chance = 0}

                Just action ->
                    let
                        totalChance =
                            action.items
                                |> List.map
                                    (\x -> x.chance)
                                |> List.sum

                        score =
                            totalChance * f

                    in
                        getItemFromChance score action.items

        newFinishedActions =
            Maybe.withDefault [] (List.tail model.finishedActions)

        newOutput =
            case newInventoryItem of
                Nothing ->
                    model.output
                
                Just x ->
                    x.name :: model.output
                        

        inventory =
            case newInventoryItem of
                Nothing ->
                    model.inventory

                Just x ->
                    x :: model.inventory

        message =
            if (List.isEmpty newFinishedActions) then
                Cmd.none
            else
                Random.generate Roll (Random.float 0 1)
    in
        ( { model
            | inventory = inventory
            , finishedActions = newFinishedActions
          }
        , message
        )


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

        output =
            finishedActions
                |> List.map
                    (\x -> x.name)
                |> List.foldr
                    (::)
                    model.output

        allFinishedActions =
            List.append
                model.finishedActions
                finishedActions

        message =
            if List.isEmpty allFinishedActions then
                Cmd.none
            else
                Random.generate Roll (Random.float 0 1)
    in
        ( { model
            | lastTimestamp = time
            , lastTickDuration = sinceLastTick
            , actions = processedActions
            , output = output
            , finishedActions = allFinishedActions
          }
        , message
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
