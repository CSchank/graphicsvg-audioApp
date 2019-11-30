module Main exposing (..)

import AudioApp exposing (AudioApp, SoundCmd(..), audioApp)
import GraphicSVG exposing (..)
import GraphicSVG.EllieApp exposing (GetKeyState)


type Msg
    = Tick Float GetKeyState
    | ClickedLeftButton
    | ClickedRightButton


type alias Model =
    { time : Float
    , counter : Int
    }


main : AudioApp Model Msg
main =
    audioApp Tick
        { model = { time = 0, counter = 0 }
        , view = view
        , update = update
        , title = "Audio App Test"
        }


update : Msg -> Model -> ( Model, SoundCmd )
update msg model =
    case msg of
        Tick t _ ->
            ( { model | time = t }, NoSound )

        ClickedLeftButton ->
            ( { model | counter = model.counter - 1 }, PlaySound "Sounds/failure.wav" )

        ClickedRightButton ->
            ( { model | counter = model.counter + 1 }, PlaySound "Sounds/success.wav" )


view : Model -> Collage Msg
view model =
    collage 192
        128
        [ circle 20
            |> filled blue
            |> notifyTap ClickedRightButton
            |> move ( 50, 0 )
        , circle 20
            |> filled red
            |> notifyTap ClickedLeftButton
            |> move ( -50, 0 )
        , text ("Counter: " ++ String.fromInt model.counter)
            |> centered
            |> filled black
        ]
