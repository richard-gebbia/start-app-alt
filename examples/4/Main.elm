module Main where

import CounterList
import Html exposing (Html)
import StartApp


main : Signal Html
main = 
    StartApp.start
        { init = CounterList.init
        , inputs = []
        , update = CounterList.update
        , stepOutput = CounterList.view
        }