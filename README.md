# start-app-alt

An opinionated re-work of Elm's start-app.

## Objectives
* Generalize start-app to fit more programs than just browser UIs. start-app-alt can be used to model most any sort of program: command-line utilities, web servers, robots, desktop apps, etc.
* Create a scalable architecture that can fit that general program model.
* Don't use the `Effects` package. Its integration within start-app is strange and not really necessary. It also does not have a directed focus, making it awkward to use.

## Philosophy changes in start-app-alt
* The `update` function is *always* `Action -> Model -> Model`, none of this `(Model, Effects)` business. The update function should have one and only one purpose, and that is to change the program's state based on input from the outside world. It should not also encapsulate side-effects.
* All side effects are relegated to their own functions of type `Signal.Address Context -> Model -> output`.
    - The `view` function generates `Html`, so its type is `Signal.Address Context -> Model -> Html`.
    - Similarly, the `request` function generates HTTP Requests of type `Task () something`, so its type is `Signal.Address Context -> Model -> Task () something`
* There is a type `Output` that is a record of all outputs of a component. There is a function `stepOutput : Signal.Address Context -> Model -> Output` that simply collects each output.

Examples 1-4 didn't change from the original. To see this philosophy in action, check out examples 5-7. 

## Current issues as I see them
* On average, programs written in this style are slightly bigger (we're talking ~10-20 lines per file here). This is primarily because the user must make a separate function for each output type and an extra function `stepOutput` collecting all the outputs.
* I don't like the name `stepOutput`. There's probably a much better name, but I couldn't think of one.
* Due to the move of side effects from `update` to the output functions, the user might need to store extra data in the model for output. In example 5, for instance, I added an extra `Bool` to the model to denote whether I should send a request. This feels icky, but much less icky than constructing a tuple inside `update`, especially considering this already had to happen for the `view` function anyway.
* One of the benefits of the `Effects` module was the `tick` function, which allowed the user to create individual timers for animation and piping them to an `Action` of the component type. Without `Effects`, I am currently threading the `Tick` action all the way through to the component that needs it. This definitely feels wrong, since the parent component must know an individual action value constructor of the child. This can be fixed, though, in a more general way, perhaps by allowing the creation of a `Signal` that is diverted to the `Address` in the child component. To see what I'm talking about, check out example 8.