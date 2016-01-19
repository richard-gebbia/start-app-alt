module Main where

import Html exposing (Html)
import RandomGifPair
import StartApp
import Task exposing (Task)

app : Signal RandomGifPair.Output
app = 
    let 
        init : RandomGifPair.Model
        init = 
            RandomGifPair.init "funny cats" "funny dogs"
    in
    StartApp.start
        { init = init
        , inputs = []
        , update = RandomGifPair.update
        , stepOutput = RandomGifPair.stepOutput
        }


main =
    Signal.map .html app


port tasks : Signal (Task () (List ()))
port tasks =
    Signal.map .http app

