module Components.MatchList (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import String


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
                [ th
                    []
                    [ text "Balls"
                    ]
                , th
                    []
                    [ text "shit"
                    ]
                ]
            , tr
                []
                [ td
                    []
                    [ text "Balls"
                    ]
                , td
                    []
                    [ text "shit"
                    ]
                ]
            ]
        ]
    ]
