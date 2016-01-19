module CounterList where

import Counter
import Html exposing (..)
import Html.Events exposing (..)


-- Model

type alias Model =
    { counters : List ( ID, Counter.Model )
    , nextID : ID
    }

type alias ID = Int


init : Model
init =
    { counters = []
    , nextID = 0
    }


-- Action

type Action
    = Insert
    | Remove ID
    | Modify ID Counter.Action


-- Update

update : Action -> Model -> Model
update action model =
    case action of
        Insert ->
            { model |
                counters = ( model.nextID, Counter.init ) :: model.counters,
                nextID = model.nextID + 1
            }

        Remove id ->
            { model |
                counters = List.filter (\(counterID, _) -> counterID /= id) model.counters
            }

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


-- View

view : Signal.Address Action -> Model -> Html
view address model =
    let 
        insert : Html
        insert = button [ onClick address Insert ] [ text "Add" ]
    in
        div [] (insert :: List.map (viewCounter address) model.counters)


viewCounter : Signal.Address Action -> (ID, Counter.Model) -> Html
viewCounter address (id, model) =
    div []
        [ Counter.view (Signal.forwardTo address (Modify id)) model
        , button [ onClick address (Remove id) ] [ text "Remove" ]
        ]