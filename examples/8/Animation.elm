module Animation where

type alias Animation =
    { duration: Float
    , easing: Float -> Float
    , elapsedTime: Float
    , isPlaying: Bool
    }


easedAnimation : Float -> (Float -> Float) -> Animation
easedAnimation duration easing =
    { duration = duration
    , easing = easing
    , elapsedTime = 0
    , isPlaying = False
    }


update : Float -> Animation -> Animation
update dt animation =
    if animation.isPlaying then
        let 
            newElapsedTime : Float
            newElapsedTime =
                animation.elapsedTime + dt
        in
        { animation 
        | elapsedTime = newElapsedTime
        , isPlaying = newElapsedTime < animation.duration
        }
    else
        animation


value : Animation -> Float
value animation =
    clamp 0 1 (animation.elapsedTime / animation.duration)
    |> animation.easing


start : Animation -> Animation
start animation =
    { animation 
    | elapsedTime = 0
    , isPlaying = True
    }


isAnimating : Animation -> Bool
isAnimating animation =
    animation.isPlaying
