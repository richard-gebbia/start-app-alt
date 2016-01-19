module CounterPair where

import Counter
import Html exposing (..)
import Signal


-- Model

type alias Model = 
    { top: Counter.Model
    , bottom: Counter.Model
    }

init : Model
init = 
    { top = Counter.init
    , bottom = Counter.init
    }


-- Action

type Action
    = Top Counter.Action
    | Bottom Counter.Action


-- Update

update : Action -> Model -> Model
update action model =
    case action of
        Top counterAction ->
            { model | top = Counter.update counterAction model.top }

        Bottom counterAction ->
            { model | bottom = Counter.update counterAction model.bottom }


-- View

view : Signal.Address Action -> Model -> Html
view address model =
    div []
        [ Counter.view (Signal.forwardTo address Top) model.top
        , Counter.view (Signal.forwardTo address Bottom) model.bottom
        ]
