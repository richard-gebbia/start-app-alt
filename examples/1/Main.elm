module Main where

import Counter
import Html exposing (Html)
import StartApp


main : Signal Html
main = 
    StartApp.start
        { init = Counter.init
        , inputs = []
        , update = Counter.update
        , stepOutput = Counter.view
        }