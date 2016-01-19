module Main where

import Html exposing (Html)
import RandomGifList
import StartApp
import Task exposing (Task)

app : Signal RandomGifList.Output
app = 
    StartApp.start
        { init = RandomGifList.init
        , inputs = []
        , update = RandomGifList.update
        , stepOutput = RandomGifList.stepOutput
        }


main =
    Signal.map .html app


port tasks : Signal (Task () (List ()))
port tasks =
    Signal.map .http app

