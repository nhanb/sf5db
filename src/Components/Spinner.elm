module Components.Spinner (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import List exposing (map)


cubes =
  let
    toDiv num =
      div
        [ class ("sk-cube sk-cube" ++ (toString num))
        ]
        []
  in
    map toDiv [1..9]


spinner =
  div [ class "sk-cube-grid" ] cubes
