module Processor exposing (finishedAction, finishedActions, isPossible)

import Dict exposing (..)
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
                        actionItems =
                            action.items
                                |> List.filterMap
                                    (\x -> Dict.get x model.items)

                        itemChance =
                            actionItems
                                |> List.map .chance
                                |> List.sum

                        score =
                            (action.nullChance + itemChance) * f
                    in
                    Just
                        { action = action
                        , item = getItemFromChance score actionItems
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

        newInventory =
            case newInventoryItem of
                Nothing ->
                    model.inventory

                Just x ->
                    case x.item of
                        Nothing ->
                            model.inventory

                        Just item ->
                            addToInventory model.inventory item

        newModel =
            { model
                | inventory = newInventory
                , finishedActions = newFinishedActions
                , output = newOutput
            }

        newNewModel =
            if List.isEmpty newFinishedActions then
                enableActions newModel

            else
                newModel

        message =
            if List.isEmpty newFinishedActions then
                Cmd.none

            else
                Random.generate Roll (Random.float 0 1)
    in
    ( newNewModel
    , message
    )


addToInventory : List InventoryItem -> Item -> List InventoryItem
addToInventory inventory item =
    let
        toInventoryItem : Item -> InventoryItem
        toInventoryItem i =
            { name = i.name
            , icon = i.icon
            , quantity = 1
            , newness = 10
            }

        il =
            inventory
                |> List.filter
                    (\i -> i.name == item.name)
                |> List.head
    in
    case il of
        Nothing ->
            (toInventoryItem item :: inventory)
                |> List.sortBy .name

        Just inventoryItem ->
            inventory
                |> updateIf
                    (\i -> i.name == item.name)
                    (\i ->
                        { i
                            | quantity = i.quantity + 1
                            , newness = 10
                        }
                    )


updateIf : (InventoryItem -> Bool) -> (InventoryItem -> InventoryItem) -> List InventoryItem -> List InventoryItem
updateIf predicate update list =
    List.map
        (\item ->
            if predicate item then
                update item

            else
                item
        )
        list


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


enableActions : Model -> Model
enableActions model =
    { model
        | actions =
            model.actions
                |> List.map
                    (\a ->
                        if not a.unlocked && isPossible model.inventory a.recipe then
                            { a | unlocked = True }

                        else
                            a
                    )
    }


isPossible : List InventoryItem -> Maybe (List Ingredient) -> Bool
isPossible inventory ingredients =
    let
        hasIngredient : Ingredient -> Bool
        hasIngredient ingredient =
            inventory
                |> List.map (\x -> ( x.name, x ))
                |> Dict.fromList
                |> Dict.get ingredient.name
                |> Maybe.map
                    (\y ->
                        y.quantity >= ingredient.quantity
                    )
                |> Maybe.withDefault False
    in
    ingredients
        |> Maybe.withDefault []
        |> List.map hasIngredient
        |> List.all identity
