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
  , charFilter = ""
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
  , { date = "10/31/2016"
    , event = "Saigon Cup 2016"
    , gameVersion = "Vietnamese build"
    , p1 = "Daigo"
    , p1Char = "Ryu"
    , p2 = "Rauden"
    , p2Char = "Dhalsim"
    , winner = "1"
    , matchType = "Casual"
    , url = "http://youtube.com/watch?v=-XLirBQlMSM"
    , notes = "NO JUSTIN"
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


getMatchesWithCharacter char matches =
  let
    hasChar match =
      contains char (.p1Char match) || contains char (.p2Char match)
  in
    filter hasChar matches


applyAllFilters playerName charName matches =
  getMatchesWithCharacter charName matches
    |> getMatchesWithPlayerName playerName


view address model =
  div
    []
    [ div
        []
        [ input
            [ type' "text"
            , placeholder "Filter player name"
            , on "input" targetValue (Signal.message address << FilterPlayer)
            ]
            []
        , input
            [ type' "text"
            , placeholder "Filter character name"
            , on "input" targetValue (Signal.message address << FilterCharacter)
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
              (applyAllFilters
                (.nameFilter model)
                (.charFilter model)
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
  | FilterCharacter String


update action model =
  case action of
    FilterPlayer playerName ->
      { model | nameFilter = playerName }

    FilterCharacter charName ->
      { model | charFilter = charName }
