module Main where

import Html exposing (Html)
import RandomGif
import StartApp
import Task exposing (Task)

app : Signal RandomGif.Output
app = 
    let 
        init : RandomGif.Model
        init = 
            RandomGif.init "funny cats"
    in
    StartApp.start
        { init = init
        , inputs = []
        , update = RandomGif.update
        , stepOutput = RandomGif.stepOutput
        }


main =
    Signal.map .html app


port tasks : Signal (Task () ())
port tasks =
    Signal.map .http app

