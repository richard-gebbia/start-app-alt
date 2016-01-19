module Main where

import CounterPair
import Html exposing (Html)
import StartApp


main : Signal Html
main = 
    StartApp.start
        { init = CounterPair.init
        , inputs = []
        , update = CounterPair.update
        , stepOutput = CounterPair.view
        }