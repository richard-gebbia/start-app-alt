module RandomGif where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json
import Task exposing (Task)


-- Model

type alias Model =
    { topic : String
    , gifUrl : String
    , shouldRequest : Bool
    }


init : String -> Model
init topic =
    { topic = topic
    , gifUrl = "assets/waiting.gif"
    , shouldRequest = True
    }


-- Action

type Action
    = RequestMore
    | NewGif (Maybe String)


-- Update

update : Action -> Model -> Model
update action model =
    case action of
        RequestMore ->
            { model | shouldRequest = True }

        NewGif maybeGifUrl ->
            Model model.topic (Maybe.withDefault model.gifUrl maybeGifUrl) False


-- View

(=>) = (,)


view : Signal.Address Action -> Model -> Html
view address model =
    div [ style [ "width" => "200px" ] ]
        [ h2 [headerStyle] [text model.topic]
        , div [imgStyle model.gifUrl] []
        , button [ onClick address RequestMore ] [ text "More Please!" ]
        ]


headerStyle : Attribute
headerStyle =
    style
        [ "width" => "200px"
        , "text-align" => "center"
        ]


imgStyle : String -> Attribute
imgStyle url =
    style
        [ "display" => "inline-block"
        , "width" => "200px"
        , "height" => "200px"
        , "background-position" => "center center"
        , "background-size" => "cover"
        , "background-image" => ("url('" ++ url ++ "')")
        ]


-- Effects

getRandomGif : Signal.Address Action -> String -> Task () ()
getRandomGif address topic =
    Http.get decodeUrl (randomUrl topic)
    |> Task.toMaybe
    |> Task.map NewGif
    |> flip Task.andThen (Signal.send address)


randomUrl : String -> String
randomUrl topic =
    Http.url "http://api.giphy.com/v1/gifs/random"
        [ "api_key" => "dc6zaTOxFJmzC"
        , "tag" => topic
        ]


decodeUrl : Json.Decoder String
decodeUrl =
    Json.at ["data", "image_url"] Json.string


request : Signal.Address Action -> Model -> Task () ()
request address model =
    if model.shouldRequest then
        getRandomGif address model.topic
    else
        Task.succeed ()


-- Step

type alias Output =
    { html: Html
    , http: Task () ()
    }


stepOutput : Signal.Address Action -> Model -> Output
stepOutput address model = 
    { html = view address model
    , http = request address model
    }

