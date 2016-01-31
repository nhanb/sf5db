module Components.MatchList (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import String
import List exposing (map)


matches =
  [ [ "10/31/2015"
    , "Canada Cup 2015"
    , "Dhalsim build"
    , "Arturo"
    , "Dhalsim"
    , "Ricki Ortiz"
    , "Chun Li"
    , "1"
    , "Casual"
    , "http://youtube.com/watch?v=-XLirBQlMSM"
    , "nope"
    ]
  , [ "1/1/2016"
    , "Saigon Cup 2016"
    , "Vietnamese Build"
    , "Daigo"
    , "Ryu"
    , "Justin Wong"
    , "Chun Li"
    , "2"
    , "Casual"
    , "http://youtube.com/watch?v=-XLirBQlMSM"
    , "L E T S G O J U S T I N"
    ]
  ]


fields =
  [ "date"
  , "event"
  , "gameVersion"
  , "p1"
  , "p1Char"
  , "p2"
  , "p2Char"
  , "winner"
  , "matchType"
  , "url"
  , "notes"
  ]


ths value =
  th [] [ text value ]


tds value =
  td [] [ text value ]


rowCells cells =
  tr [] (map tds cells)



-- matchlist component


matchlist model =
  div
    [ class "mt-h2" ]
    [ text "Hello, World~"
    , table
        [ class "mt-table" ]
        [ thead
            []
            [ tr
                []
                (map ths fields)
            ]
        , tbody
            []
            (map rowCells matches)
        ]
    ]
