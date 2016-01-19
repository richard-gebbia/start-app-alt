module RandomGifPair where

import Html exposing (..)
import Html.Attributes exposing (style)
import RandomGif
import Task exposing (Task)


-- Model 

type alias Model =
    { left: RandomGif.Model
    , right: RandomGif.Model
    }


init : String -> String -> Model
init leftTopic rightTopic =
    { left = RandomGif.init leftTopic
    , right = RandomGif.init rightTopic
    }


-- Action

type Action 
    = Left RandomGif.Action
    | Right RandomGif.Action


-- Update

update : Action -> Model -> Model
update action model =
    case action of
        Left rgAction -> 
            { model | left = RandomGif.update rgAction model.left }

        Right rgAction ->
            { model | right = RandomGif.update rgAction model.right }


-- View

view : Signal.Address Action -> Model -> Html
view address model =
    div [ style [ ("display", "flex") ] ]
        [ RandomGif.view (Signal.forwardTo address Left) model.left
        , RandomGif.view (Signal.forwardTo address Right) model.right
        ]


-- Effects

request : Signal.Address Action -> Model -> Task () (List ())
request address model =
    Task.sequence
        [ RandomGif.request (Signal.forwardTo address Left) model.left
        , RandomGif.request (Signal.forwardTo address Right) model.right
        ]


-- Step

type alias Output =
    { html: Html
    , http: Task () (List ())
    }


stepOutput : Signal.Address Action -> Model -> Output
stepOutput address model =
    { html = view address model
    , http = request address model
    }

