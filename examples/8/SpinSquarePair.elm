module SpinSquarePair where

import Html exposing (..)
import Html.Attributes exposing (..)
import SpinSquare
import Time exposing (Time)

-- Model

type alias Model =
    { left: SpinSquare.Model
    , right: SpinSquare.Model
    }


init : Model
init = 
    { left = SpinSquare.init
    , right = SpinSquare.init
    }

-- Action

type Action 
    = Left SpinSquare.Action
    | Right SpinSquare.Action
    | Tick Time


-- Update

update : Action -> Model -> Model
update action model =
    case action of
        Left ssAction ->
            { model | left = SpinSquare.update ssAction model.left }

        Right ssAction ->
            { model | right = SpinSquare.update ssAction model.right }

        Tick dt ->
            { left = SpinSquare.update (SpinSquare.Tick dt) model.left
            , right = SpinSquare.update (SpinSquare.Tick dt) model.right
            }


-- View

(=>) = (,)


view : Signal.Address Action -> Model -> Html
view address model =
  div [ style [ "display" => "flex" ] ]
    [ SpinSquare.view (Signal.forwardTo address Left) model.left
    , SpinSquare.view (Signal.forwardTo address Right) model.right
    ]
