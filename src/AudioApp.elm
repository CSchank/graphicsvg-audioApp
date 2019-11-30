port module AudioApp exposing (..)

import GraphicSVG exposing (..)
import GraphicSVG.EllieApp exposing (EllieAppWithTick, GetKeyState, KeyState, ellieAppWithTick)
import Json.Encode as E


type alias InputHandler userMsg =
    Float
    -> GetKeyState
    -> userMsg


port play : E.Value -> Cmd msg


type HiddenMsg userMsg
    = UserMsg userMsg


type alias AudioApp userModel userMsg =
    EllieAppWithTick () userModel (HiddenMsg userMsg)



{-
   initHiddenModel : InputHandler userMsg -> HiddenModel userMsg
   initHiddenModel tick =
       { tick = tick
       , keys = Dict.empty
       , initT = millisToPosix 0
       }
-}


type SoundCmd
    = PlaySound String
    | NoSound


cmdifySound : SoundCmd -> Cmd (HiddenMsg userMsg)
cmdifySound sCmd =
    case sCmd of
        PlaySound url ->
            play (E.string url)

        NoSound ->
            Cmd.none


hiddenAudioUpdate : (userMsg -> userModel -> ( userModel, SoundCmd )) -> HiddenMsg userMsg -> userModel -> ( userModel, Cmd (HiddenMsg userMsg) )
hiddenAudioUpdate userUpdate msg model =
    case msg of
        UserMsg userMsg ->
            let
                ( newModel, soundCmd ) =
                    userUpdate userMsg model
            in
            ( newModel, cmdifySound soundCmd )


audioApp :
    InputHandler userMsg
    ->
        { model : userModel
        , view : userModel -> Collage userMsg
        , update : userMsg -> userModel -> ( userModel, SoundCmd )
        , title : String
        }
    -> AudioApp userModel userMsg
audioApp tickMsg userApp =
    let
        userInit =
            userApp.model

        userUpdate =
            userApp.update

        userView =
            userApp.view
    in
    ellieAppWithTick (\time keystate -> UserMsg <| tickMsg time keystate)
        { init = \_ -> ( userInit, Cmd.none )
        , update = hiddenAudioUpdate userUpdate
        , view = \userModel -> { title = userApp.title, body = mapCollage UserMsg <| userView userModel }
        , subscriptions = \_ -> Sub.none
        }
