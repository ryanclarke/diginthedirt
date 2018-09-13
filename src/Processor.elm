module Processor exposing (finishedAction, finishedActions)

import Model exposing (..)
import Random
import Dict exposing (..)


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
                        Just
                            { action = action
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
            if (List.isEmpty newFinishedActions) then
                enableActions newModel
            else
                newModel

        message =
            if (List.isEmpty newFinishedActions) then
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
        toInventoryItem item =
            { name = item.name
            , icon = item.icon
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
                ((toInventoryItem item) :: inventory)
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
    let
        build =
            { actionType = Build
            , name = "Build fishing pole"
            , success = "Built a "
            , failure = "Built nothing"
            , progress = Inactive
            , duration = 5000
            , nullChance = 0
            , items =
                [ { name = "fishing pole"
                  , chance = 1
                  , icon = "brick-pile"
                  }
                ]
            , recipe =
                Just [ { name = "string", quantity = 1 }
                     , { name = "stick", quantity = 1 }
                     ]
            }

        ingredients : Dict String InventoryItem
        ingredients =
            model.inventory
                |> List.map (\x -> ( x.name, x ))
                |> Dict.fromList

        hasIngredient : Ingredient -> Bool
        hasIngredient ingredient =
            ingredients
                |> Dict.get ingredient.name
                |> Maybe.map
                    (\y ->
                        y.quantity >= 1
                    )
                |> Maybe.withDefault False
        recipe =
            build.recipe
                |> Maybe.withDefault []

        hasAll =
            recipe
                |> List.map hasIngredient
                |> List.all identity

        notYet =
            model.actions
            |> List.all (\x -> x.name /= build.name)

        newActions =
            if (hasAll && notYet) then
                List.append model.actions [ build ]
            else
                model.actions

        newInventory =
            if (hasAll && notYet) then
                model.inventory
                    |> List.map (\x -> 
                            recipe
                                |> List.filter (\i -> i.name == x.name)
                                |> List.head
                                |> Maybe.andThen (\m ->
                                        Just { x
                                        | quantity = x.quantity - m.quantity
                                        }
                                    )
                                |> Maybe.withDefault x
                        )
            else
                model.inventory
    in
        { model
        | actions = newActions
        , inventory = newInventory
        }