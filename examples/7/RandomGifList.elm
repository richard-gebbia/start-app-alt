module RandomGifList where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import RandomGif
import Task exposing (Task)

-- Model

type alias Model =
    { topic: String
    , gifList: List (Int, RandomGif.Model)
    , uid: Int
    }


init : Model
init = 
    { topic = ""
    , gifList = []
    , uid = 0
    }


-- Action

type Action
    = Topic String
    | Create
    | SubMsg Int RandomGif.Action


-- Update

update : Action -> Model -> Model
update action model =
    case action of
        Topic topic ->
            { model | topic = topic }

        Create ->
            let 
                uid : Int
                uid = 
                    model.uid + 1
            in
            { topic = ""
            , gifList = model.gifList ++ [(uid, RandomGif.init model.topic)]
            , uid = uid
            }

        SubMsg msgId msg ->
            let 
                subUpdate : (Int, RandomGif.Model) -> (Int, RandomGif.Model)
                subUpdate (id, subModel) =
                    if msgId == id then
                        (id, RandomGif.update msg subModel)
                    else
                        (id, subModel)
            in
            { model | gifList = List.map subUpdate model.gifList }


-- View

(=>) = (,)


view : Signal.Address Action -> Model -> Html
view address model =
    div []
        [ input
            [ placeholder "What kind of gifs do you want?"
            , value model.topic
            , onEnter address Create
            , on "input" targetValue (Signal.message address << Topic)
            , inputStyle
            ]
            []
        , div [ style [ "display" => "flex", "flex-wrap" => "wrap" ] ]
            (List.map (elementView address) model.gifList)
        ]


elementView : Signal.Address Action -> (Int, RandomGif.Model) -> Html
elementView address (id, model) =
    RandomGif.view (Signal.forwardTo address (SubMsg id)) model


inputStyle : Attribute
inputStyle =
    style
        [ ("width", "100%")
        , ("height", "40px")
        , ("padding", "10px 0")
        , ("font-size", "2em")
        , ("text-align", "center")
        ]


onEnter : Signal.Address a -> a -> Attribute
onEnter address value =
    on "keydown"
        (Json.customDecoder keyCode is13)
        (\_ -> Signal.message address value)


is13 : Int -> Result String ()
is13 code =
    if code == 13 then
        Ok ()

    else
        Err "not the right key code"


-- Effects

request : Signal.Address Action -> Model -> Task () (List ())
request address model =
    let 
        subRequest : (Int, RandomGif.Model) -> Task () ()
        subRequest (id, subModel) = 
            RandomGif.request (Signal.forwardTo address (SubMsg id)) subModel
    in
    List.map subRequest model.gifList
    |> Task.sequence


-- Step

type alias Output =
    { html: Html
    , http: Task () (List ())
    }


stepOutput : Signal.Address Action -> Model -> Output
stepOutput address model =
    { html = view address model
    , http = request address model
    }

