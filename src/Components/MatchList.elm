module Components.MatchList (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (targetValue, on)
import String exposing (contains, toLower)
import List exposing (map, filter)
import Effects exposing (Effects, Never)
import Signal


updateMatchesSignal =
  -- Partial function that will accept a port as its final param. This is an
  -- ugly-ish hack that helps expose UpdateMatches to Main
  Signal.map UpdateMatches



-- MODEL


type alias Model =
  { matches : List (Match)
  , nameFilter : String
  , charFilter : String
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


init : ( Model, Effects Action )
init =
  ( { matches = []
    , nameFilter = ""
    , charFilter = ""
    }
  , Effects.none
  )


fields =
  [ "Date"
  , "Event"
  , "Game version"
  , "P1"
  , "P1 Character"
  , "P2"
  , "P2 Character"
  , "Winner"
  , "Match Type"
  , "Video"
  , "Notes"
  ]



-- VIEW


filterMatchByString field1 field2 query matches =
  -- common logic of getMatchesWithPlayerName & getMatchesWithCharacter
  if query == "" then
    matches
  else
    let
      lowerQuery =
        toLower query

      hasMatchingField match =
        contains lowerQuery (toLower (field1 match))
          || contains lowerQuery (toLower (field2 match))
    in
      filter hasMatchingField matches


getMatchesWithPlayerName name matches =
  filterMatchByString .p1 .p2 name matches


getMatchesWithCharacter character matches =
  filterMatchByString .p1Char .p2Char character matches


applyAllFilters playerName charName matches =
  getMatchesWithCharacter charName matches
    |> getMatchesWithPlayerName playerName


matchesTable model =
  if (.matches model == []) then
    div [] [ text "Loading..." ]
  else
    table
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
    , matchesTable model
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
    , td
        []
        [ a
            [ href (.url match)
            ]
            [ text "Watch" ]
        ]
    , td [] [ text (.notes match) ]
    ]



-- UPDATE


type Action
  = FilterPlayer String
  | FilterCharacter String
  | UpdateMatches (List (Match))


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    FilterPlayer playerName ->
      ( { model | nameFilter = playerName }
      , Effects.none
      )

    FilterCharacter charName ->
      ( { model | charFilter = charName }
      , Effects.none
      )

    UpdateMatches matches ->
      ( { model | matches = matches }
      , Effects.none
      )
