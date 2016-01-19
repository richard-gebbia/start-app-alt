module Counter where

import Html exposing (..)
import Html.Events exposing (..)
import Signal

-- Model

type alias Model = Int

init : Model
init = 0


-- Action

type Action 
    = Increment
    | Decrement


-- Update

update : Action -> Model -> Model
update action model =
    case action of
        Increment ->
            model + 1

        Decrement -> 
            model - 1


-- View

view : Signal.Address Action -> Model -> Html
view address model =
    div []
        [ button [ onClick address Decrement ] [ text "-" ]
        , div [] [ text (toString model) ]
        , button [ onClick address Increment ] [ text "+" ]
        ]
