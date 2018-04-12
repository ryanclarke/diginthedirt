module Processor exposing (finishedAction, finishedActions)

import Model exposing (..)
import Random


type alias Acc =
    { chance : Float
    , item : Maybe Item
    }


finishedActions : Model -> ( Model, Cmd Msg )
finishedActions model =
    ( model
    , Random.generate Roll (Random.float 0 1)
    )


finishedAction : Model -> Float -> ( Model, Cmd Msg )
finishedAction model f =
    let
        newInventoryItem =
            case List.head model.finishedActions of
                Nothing ->
                    Nothing

                Just action ->
                    let
                        itemChance =
                            action.items
                                |> List.map
                                    (\x -> x.chance)
                                |> List.sum

                        score =
                            (action.nullChance + itemChance) * f

                    in
                        Just { action = action
                        , item = getItemFromChance score action.items
                        }

        newFinishedActions =
            Maybe.withDefault [] (List.tail model.finishedActions)

        newOutput =
            case newInventoryItem of
                Nothing ->
                    model.output
                
                Just x ->
                    case x.item of
                        Nothing ->
                            x.action.failure :: model.output

                        Just item ->
                            (x.action.success ++ item.name) :: model.output
                        

        inventory =
            case newInventoryItem of
                Nothing ->
                    model.inventory

                Just x ->
                    case x.item of
                        Nothing ->
                            model.inventory

                        Just item ->
                            item :: model.inventory

        message =
            if (List.isEmpty newFinishedActions) then
                Cmd.none
            else
                Random.generate Roll (Random.float 0 1)
    in
        ( { model
            | inventory = inventory
            , finishedActions = newFinishedActions
            , output = newOutput
          }
        , message
        )


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

