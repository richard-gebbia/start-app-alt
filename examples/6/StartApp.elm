module StartApp where

import List
import Maybe exposing (Maybe(Just, Nothing))
import Signal exposing (Signal)

-- A program is:
-- * a model for state
-- * an initial state
-- * a set of inputs from the outside world
-- * a function that maps inputs to an updated model AND side effects

type alias Step inputs state outputs 
    = Signal.Address inputs -> inputs -> state -> (state, outputs)


type alias Program inputs state outputs =
    { initialState: state
    , initialOutput: Signal.Address inputs -> outputs
    , inputs: List (Signal inputs)
    , step: Step inputs state outputs
    }


programStart 
    :  Program inputs state outputs
    -> Signal outputs                           -- a Signal of all of your program's outputs
programStart programModel =
    let mailbox : Signal.Mailbox (Maybe inputs)
        mailbox = 
            Signal.mailbox Nothing

        address : Signal.Address inputs
        address =
            Signal.forwardTo mailbox.address Just

        -- signals : Signal (Maybe inputs)
        signals =
            mailbox.signal
            |> (\x -> x :: List.map (Signal.map Just) programModel.inputs)
            |> Signal.mergeMany

        -- initialStateAndOutput : (state, outputs)
        initialStateAndOutput = 
            (programModel.initialState, (programModel.initialOutput address))

        -- update : Maybe inputs -> (state, outputs) -> (state, outputs)
        update maybeAction (state, _) =
            case maybeAction of 
                Just action ->
                    programModel.step address action state

                Nothing ->
                    initialStateAndOutput

        -- program : Signal (state, outputs)
        program =
            Signal.foldp 
                update 
                initialStateAndOutput
                signals
    in
    Signal.map snd program


toStep 
    :  (inputs -> state -> state)                   -- update
    -> (Signal.Address inputs -> state -> outputs)  -- view
    -> Step inputs state outputs
toStep update view =
    let 
        step address action state =
            let newState = update action state
            in
            (newState, view address newState)
    in
    step


type alias App inputs state outputs =
    { init: state
    , inputs: List (Signal inputs)
    , update: inputs -> state -> state
    , stepOutput: Signal.Address inputs -> state -> outputs
    }

start 
    :  App inputs state outputs
    -> Signal outputs
start app =
    programStart
        { initialState = app.init
        , initialOutput = (\address -> app.stepOutput address app.init)
        , inputs = app.inputs
        , step = toStep app.update app.stepOutput
        }
