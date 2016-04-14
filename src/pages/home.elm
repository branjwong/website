module Home where

import Html exposing (..)
import Html.Attributes exposing (..)
import Window

import Style.SharedValues exposing (heightNavBar, heightHeader, heightFooter)
import NavBar
import Header
import Notices
import Footer
import Bootstrap

port title : String
port title = "Home"

type alias Model = Int

model : Signal Model
model = Window.height

main : Signal Html
main =
  Signal.map view model

view : Model -> Html
view model =
  div 
    []
    [ NavBar.navBar 
    , NavBar.navBarSpace
    , home
    , space model
    , Footer.footer
    ]

space : Model -> Html
space model = 
  let 
    heightContainer = 600
    spaceTakenSoFar = heightNavBar + heightContainer + heightFooter
    result =
      if model - spaceTakenSoFar > 0 then
        model - spaceTakenSoFar + 1
      else
        0
  in
    div 
      [ style [ ("height" , toString result ++ "px" ) ] ]
      []


home : Html
home =
  div 
    [ class "container" ]
    [ div
      [ class "HomeContainer" ]
      [ div
        [ class "row" ]
        [ div
          [ class "col-sm-2 col-sm-offset-3"]
          [ block "Teaching" "/teaching" ]
        , div
          [ class "col-sm-2" ]
          [ block "Programming" "/programming" ]
        , div
          [ class "col-sm-2" ]
          [ block "Writing" "/writing" ]
        ]
      , div
        [ class "row" ]
        [ div
          [ class "col-sm-2 col-sm-offset-3"]
          [ block "Tutor Plug" "/tutor-plug" ]
        , div
          [ class "col-sm-2" ]
          [ block "Site Code" "https://github.com/branjwong/bjw-site" ]
        , div
          [ class "col-sm-2" ]
          [ block "Latest Blog" "writing/blog/latest" ]
        ]
      , div
        [ class "row" ]
        [ div
          [ class "col-sm-2 col-sm-offset-5"]
          [ block "Megaman Game" "/megaman" ]
        , div
          [ class "col-sm-2" ]
          [ block "Latest Review" "/writing/reviews/latest" ]
        ]
      , div
        [ class "row" ]
        [ div
          [ class "col-sm-2 col-sm-offset-7"]
          [ block "Latest Pick" "/" ]
        ]
      {-
      , div 
        [ class "row" ]
        [ div
          [ class "HomeExtraSpace" ]
          []
        ]
      -}
      ]
    ]

block : String -> String -> Html
block title link = 
  div
    [ class "BlockDiv" ]
    [ div
      [ style
        [ ("text-align", "center") ]
      ]
      [ a
        [ href link ]
        [ text title ]
      ]
    , div
      [ class "BlockRim" ]
      [ div
        [ class "Block" ]
        []
      ]
    ]
 
