port module Update exposing (..)

import Window exposing (Size)
import Debug
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)
import String
import Navigation
import Task


--

import Model exposing (..)


port toTop : Bool -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    --case Debug.log "update" msg of
    case msg of
        NoOp ->
            model ! []

        Resize size ->
            { model | size = size } ! []

        ToTop arg ->
            model ! [ toTop True ]


{-| The URL is turned into a result. If the URL is valid, we just update our
model to the new count. If it is not a valid URL, we modify the URL to make
sense.
-}
urlUpdate : Result String Page -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    --case Debug.log "urlUpdate" result of
    case result of
        Err _ ->
            ( model, Navigation.modifyUrl (toHash model.page) )

        Ok page ->
            let
                resizePages =
                    [ Home, Teaching TeachingHome ]

                resizeTask =
                    if List.foldr (||) False (List.map (\x -> x == page) resizePages) then
                        [ Task.perform (\_ -> NoOp) Resize Window.size ]
                    else
                        []

                toTopTask =
                    [ Task.perform (\_ -> NoOp) ToTop (Task.succeed True) ]

                batch =
                    toTopTask ++ resizeTask
            in
                { model | page = page } ! batch


toHash : Page -> String
toHash page =
    case page of
        Home ->
            "#home"

        Programming ->
            "#programming"

        Teaching TeachingHome ->
            "#teaching/home"

        Teaching (Tutor Plug) ->
            "#teaching/tutor/plug"

        Teaching (Tutor MathTen) ->
            "#teaching/tutor/math10"

        Teaching (Tutor MathEleven) ->
            "#teaching/tutor/math11"

        Teaching (Tutor PhysicsEleven) ->
            "#teaching/tutor/physics11"

        Teaching (Tutor PhysicsTwelve) ->
            "#teaching/tutor/physics12"

        Teaching (Tutor PrecalcEleven) ->
            "#teaching/tutor/precalc11"

        Teaching (Tutor PrecalcTwelve) ->
            "#teaching/tutor/precalc12"

        Teaching (Tutor Japanese) ->
            "#teaching/tutor/japanese"

        Writing Archive ->
            "#writing/archive"

        Writing CrossGame ->
            "#writing/cross-game"

        Writing WhatIAmDoingWithMyLife ->
            "#writing/what-i-am-doing-with-my-life"

        Writing MovingBackToJapan ->
            "#writing/moving-back-to-japan"


hashParser : Navigation.Location -> Result String Page
hashParser location =
    UrlParser.parse identity pageParser (String.dropLeft 1 location.hash)


pageParser : Parser (Page -> a) a
pageParser =
    oneOf
        [ format Home (s "home")
        , format Programming (s "programming")
        , format Teaching (s "teaching" </> teachingParser)
        , format Writing (s "writing" </> writingParser)
        ]


teachingParser : Parser (TeachingPage -> a) a
teachingParser =
    oneOf
        [ format TeachingHome (s "home")
        , format Tutor (s "tutor" </> tutorParser)
        ]


tutorParser : Parser (TutorPage -> a) a
tutorParser =
    oneOf
        [ format Plug (s "plug")
        , format MathTen (s "math10")
        , format MathEleven (s "math11")
        , format PhysicsEleven (s "physics11")
        , format PhysicsTwelve (s "physics12")
        , format PrecalcEleven (s "precalc11")
        , format PrecalcTwelve (s "precalc12")
        , format Japanese (s "japanese")
        ]


writingParser : Parser (WritingPage -> a) a
writingParser =
    oneOf
        [ format Archive (s "archive")
        , format CrossGame (s "cross-game")
        , format WhatIAmDoingWithMyLife (s "what-i-am-doing-with-my-life")
        , format MovingBackToJapan (s "moving-back-to-japan")
        ]
