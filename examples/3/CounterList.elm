module CounterList where

import Counter
import Html exposing (..)
import Html.Events exposing (..)


-- Model

type alias ID = Int

type alias Model =
    { counters : List ( ID, Counter.Model )
    , nextID : ID
    }


init : Model
init =
    { counters = []
    , nextID = 0
    }


-- Action

type Action
    = Insert
    | Remove
    | Modify ID Counter.Action


-- UPDATE

update : Action -> Model -> Model
update action model =
    case action of
        Insert ->
            let 
                newCounter : (ID, Counter.Model)
                newCounter = (model.nextID, Counter.init)

                newCounters : List (ID, Counter.Model)
                newCounters = model.counters ++ [ newCounter ]
            in
                { model |
                    counters = newCounters,
                    nextID = model.nextID + 1
                }

        Remove ->
            { model | counters = List.drop 1 model.counters }

        Modify id counterAction ->
            let 
                updateCounter : (ID, Counter.Model) -> (ID, Counter.Model)
                updateCounter (counterID, counterModel) =
                    if counterID == id then
                        (counterID, Counter.update counterAction counterModel)
                    else
                        (counterID, counterModel)
            in
                { model | counters = List.map updateCounter model.counters }


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
    let 
        counters : List Html
        counters = List.map (viewCounter address) model.counters

        remove : Html
        remove = button [ onClick address Remove ] [ text "Remove" ]

        insert : Html
        insert = button [ onClick address Insert ] [ text "Add" ]
    in
        div [] ([remove, insert] ++ counters)


viewCounter : Signal.Address Action -> (ID, Counter.Model) -> Html
viewCounter address (id, model) =
    Counter.view (Signal.forwardTo address (Modify id)) model