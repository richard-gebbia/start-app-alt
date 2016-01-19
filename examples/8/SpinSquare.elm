module SpinSquare where

import Animation exposing (Animation)
import Easing
import Html exposing (Html)
import Svg exposing (svg, rect, g, text, text')
import Svg.Attributes exposing (..)
import Svg.Events exposing (onClick)
import Time exposing (Time)


-- Model

type alias Model =
    { angle: Float
    , startAngle: Float
    , animation: Animation
    }


rotation : Float
rotation = 90

duration : Time
duration = Time.second

init : Model
init = 
    { angle = 0
    , startAngle = 0
    , animation = 
        Animation.easedAnimation (Time.inSeconds duration)
            (Easing.ease Easing.easeOutBounce Easing.float 0 1 (Time.inSeconds duration))
    }


-- Action

type Action 
    = StartSpinning
    | Tick Time


-- Update

update : Action -> Model -> Model
update action model =
    case action of
        StartSpinning ->
            if Animation.isAnimating model.animation then
                model
            else
                { model 
                | startAngle = model.angle
                , animation = Animation.start model.animation
                }

        Tick dt ->
            if Animation.isAnimating model.animation then
                let updatedAnim =
                    Animation.update dt model.animation
                in
                { model
                | animation = updatedAnim
                , angle = 
                    if Animation.isAnimating updatedAnim then
                        Animation.value updatedAnim * rotation + model.startAngle
                    else
                        rotation + model.startAngle
                }
            else
                model


-- View

view : Signal.Address Action -> Model -> Html
view address model =
    svg
      [ width "200", height "200", viewBox "0 0 200 200" ]
      [ g [ transform ("translate(100, 100) rotate(" ++ toString model.angle ++ ")")
          , onClick (Signal.message address StartSpinning)
          ]
          [ rect
              [ x "-50"
              , y "-50"
              , width "100"
              , height "100"
              , rx "15"
              , ry "15"
              , style "fill: #60B5CC;"
              ]
              []
          , text' [ fill "white", textAnchor "middle" ] [ text "Click me!" ]
          ]
      ]

