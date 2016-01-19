module Main where

import Html exposing (Html)
import SpinSquarePair
import StartApp
import Time


main : Signal Html
main = 
    StartApp.start
        { init = SpinSquarePair.init
        , inputs = [Time.fps 60 |> Signal.map (Time.inSeconds >> SpinSquarePair.Tick)]
        , update = SpinSquarePair.update
        , stepOutput = SpinSquarePair.view
        }