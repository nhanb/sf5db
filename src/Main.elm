module Main (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import String


-- official 'Elm Architecture' package
-- https://github.com/evancz/start-app

import StartApp.Simple as StartApp


-- component import example

import Components.MatchList exposing (init, view, update)


-- APP KICK OFF!


main =
  StartApp.start
    { model = init
    , view = view
    , update = update
    }
