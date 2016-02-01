module Components.MatchList (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (targetValue, on)
import String exposing (contains)
import List exposing (map, filter)
import Array exposing (fromList)


-- MODEL


init =
  { matches = matches
  , nameFilter = ""
  }


type alias Match =
  { date : String
  , event : String
  , gameVersion : String
  , p1 : String
  , p1Char : String
  , p2 : String
  , p2Char : String
  , winner : String
  , matchType : String
  , url : String
  , notes : String
  }


matches : List (Match)
matches =
  [ { date = "10/31/2015"
    , event = "Canada Cup 2015"
    , gameVersion = "Dhalsim build"
    , p1 = "Arturo"
    , p1Char = "Dhalsim"
    , p2 = "Ricki Ortiz"
    , p2Char = "Chun Li"
    , winner = "1"
    , matchType = "Casual"
    , url = "http://youtube.com/watch?v=-XLirBQlMSM"
    , notes = "nope"
    }
  , { date = "10/31/2016"
    , event = "Saigon Cup 2016"
    , gameVersion = "Vietnamese build"
    , p1 = "Daigo"
    , p1Char = "Ryu"
    , p2 = "Justin"
    , p2Char = "Chun Li"
    , winner = "1"
    , matchType = "Casual"
    , url = "http://youtube.com/watch?v=-XLirBQlMSM"
    , notes = "L E T S G O J U S T I N"
    }
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



-- VIEW


getMatchesWithPlayerName name matches =
  let
    hasPlayer match =
      contains name (.p1 match) || contains name (.p2 match)
  in
    filter hasPlayer matches


view address model =
  div
    []
    [ div
        []
        [ input
            [ type' "text"
            , placeholder "filter player name"
            , on "input" targetValue (Signal.message address << FilterPlayer)
            ]
            []
        ]
    , table
        []
        [ thead
            []
            [ tr
                []
                (let
                  ths value =
                    th [] [ text value ]
                 in
                  map ths fields
                )
            ]
        , tbody
            []
            (map
              matchDataRow
              (getMatchesWithPlayerName
                (.nameFilter model)
                (.matches model)
              )
            )
        ]
    ]


matchDataRow match =
  tr
    []
    [ td [] [ text (.date match) ]
    , td [] [ text (.event match) ]
    , td [] [ text (.gameVersion match) ]
    , td [] [ text (.p1 match) ]
    , td [] [ text (.p1Char match) ]
    , td [] [ text (.p2 match) ]
    , td [] [ text (.p2Char match) ]
    , td [] [ text (.winner match) ]
    , td [] [ text (.matchType match) ]
    , td [] [ text (.url match) ]
    , td [] [ text (.notes match) ]
    ]



-- UPDATE


type Action
  = FilterPlayer String


update action model =
  case action of
    FilterPlayer playerName ->
      { model | nameFilter = playerName }
