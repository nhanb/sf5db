module Main (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import String
import Signal
import StartApp


-- component import example

import Components.MatchList exposing (init, view, update, Match, updateMatchesSignal)


-- APP KICK OFF!


port updateMatches : Signal (List (Match))
app =
  StartApp.start
    { init = init
    , view = view
    , update = update
    , inputs = [ updateMatchesSignal updateMatches ]
    }


main =
  app.html
