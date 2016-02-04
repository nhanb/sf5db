module Components.MatchList (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (targetValue, on)
import String exposing (contains, toLower)
import List exposing (map, filter)
import Effects exposing (Effects, Never)
import Signal
import Components.Spinner exposing (spinner)


updateMatchesSignal =
  -- Partial function that will accept a port as its final param. This is an
  -- ugly-ish hack that helps expose UpdateMatches to Main
  Signal.map UpdateMatches



-- MODEL


type alias Model =
  { matches : List (Match)
  , nameFilter1 : String
  , nameFilter2 : String
  , charFilter1 : String
  , charFilter2 : String
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
    , nameFilter1 = ""
    , nameFilter2 = ""
    , charFilter1 = ""
    , charFilter2 = ""
    }
  , Effects.none
  )



-- VIEW


view address model =
  div
    [ class "container" ]
    [ searchForm address
    , matchesTable model
    , foot (.matches model == [])
    ]


searchForm address =
  div
    [ class "search-form" ]
    [ div
        [ class "search-form__vs" ]
        [ text "vs" ]
    , filterInput address FilterPlayer1 "P1 name" "p1-name"
    , filterInput address FilterPlayer2 "P2 name" "p2-name"
    , filterInput address FilterCharacter1 "P1 character" "p1-char"
    , filterInput address FilterCharacter2 "P2 character" "p2-char"
    ]


filterInput address action desc cssClass =
  input
    [ type' "text"
    , placeholder desc
    , on "input" targetValue (Signal.message address << action)
    , class ("search-form__input search-form__" ++ cssClass)
    ]
    []


matchesTableHead =
  thead
    []
    [ tr
        []
        [ th [] [ text "Date" ]
        , th [] [ text "Event" ]
        , th [] [ text "Game version" ]
        , th [] [ text "P1" ]
        , th [] [ text "P2" ]
        , th [] [ text "Winner" ]
        , th [] [ text "Match Type" ]
        , th [] [ text "Video" ]
        , th [] [ text "Notes" ]
        ]
    ]


matchesTable model =
  if (.matches model == []) then
    div [ class "match-list" ] [ spinner ]
  else
    table
      [ class "match-list" ]
      [ matchesTableHead
      , tbody
          []
          (map
            matchDataRow
            ((.matches model)
              |> getMatchesWithPlayer (.nameFilter1 model) (.nameFilter2 model)
              |> getMatchesWithCharacter (.charFilter1 model) (.charFilter2 model)
            )
          )
      ]


matchDataRow match =
  let
    charSpriteName charName =
      case charName of
        "Birdie" ->
          "birdie"

        "M. Bison" ->
          "bison"

        "Cammy" ->
          "cammy"

        "Chun Li" ->
          "chun"

        "Dhalsim" ->
          "dhalsim"

        "F.A.N.G" ->
          "fang"

        "Karin" ->
          "karin"

        "Ken" ->
          "ken"

        "Laura" ->
          "laura"

        "R. Mika" ->
          "mika"

        "Nash" ->
          "nash"

        "Necalli" ->
          "necalli"

        "Rashid" ->
          "rashid"

        "Ryu" ->
          "ryu"

        "Vega" ->
          "vega"

        "Zangief" ->
          "zangief"

        s ->
          s ++ " unknown"

    charCss charName =
      "sprite sprite-" ++ (charSpriteName charName)
  in
    tr
      []
      [ td [] [ text (.date match) ]
      , td [] [ text (.event match) ]
      , td [] [ text (.gameVersion match) ]
      , td
          []
          [ div [ class (charCss (.p1Char match)) ] []
          , text (.p1 match)
          ]
      , td
          []
          [ div [ class (charCss (.p2Char match)) ] []
          , text (.p2 match)
          ]
      , td
          []
          [ let
              winner =
                .winner match

              p1 =
                .p1 match

              p2 =
                .p2 match
            in
              if winner == "P1" then
                text p1
              else if winner == "P2" then
                text p2
              else
                text "<unknown>"
          ]
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


hasSingleField getField1 getField2 query matches =
  -- common logic of getMatchesWithPlayer & getMatchesWithCharacter
  let
    lowerQuery =
      toLower query

    hasMatchingField match =
      contains lowerQuery (toLower (getField1 match))
        || contains lowerQuery (toLower (getField2 match))
  in
    filter hasMatchingField matches


hasBothFields getField1 getField2 name1 name2 matches =
  let
    lowerName1 =
      toLower name1

    lowerName2 =
      toLower name2

    hasMatchingPlayers match =
      let
        lowerP1 =
          toLower (getField1 match)

        lowerP2 =
          toLower (getField2 match)
      in
        (contains lowerName1 lowerP1
          && contains lowerName2 lowerP2
        )
          || (contains lowerName1 lowerP2
                && contains lowerName2 lowerP1
             )
  in
    filter hasMatchingPlayers matches


getMatchesWithPlayer name1 name2 matches =
  if name1 == "" && name2 == "" then
    matches
  else if name1 == "" then
    hasSingleField .p1 .p2 name2 matches
  else if name2 == "" then
    hasSingleField .p1 .p2 name1 matches
  else
    hasBothFields .p1 .p2 name1 name2 matches


getMatchesWithCharacter name1 name2 matches =
  if name1 == "" && name2 == "" then
    matches
  else if name1 == "" then
    hasSingleField .p1Char .p2Char name2 matches
  else if name2 == "" then
    hasSingleField .p1Char .p2Char name1 matches
  else
    hasBothFields .p1Char .p2Char name1 name2 matches


foot initializing =
  if initializing then
    text ""
  else
    footer
      [ class "footer" ]
      [ a [ href "http://github.com/nhanb/sf5db" ] [ text "GitHub" ]
      , text " | "
      , a
          [ href "http://forums.shoryuken.com/discussion/204887/srk-street-fighter-v-match-video-database"
          ]
          [ text "Data Source" ]
      ]



-- UPDATE


type Action
  = FilterPlayer1 String
  | FilterPlayer2 String
  | FilterCharacter1 String
  | FilterCharacter2 String
  | UpdateMatches (List (Match))


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    FilterPlayer1 playerName ->
      ( { model | nameFilter1 = playerName }
      , Effects.none
      )

    FilterPlayer2 playerName ->
      ( { model | nameFilter2 = playerName }
      , Effects.none
      )

    FilterCharacter1 charName ->
      ( { model | charFilter1 = charName }
      , Effects.none
      )

    FilterCharacter2 charName ->
      ( { model | charFilter2 = charName }
      , Effects.none
      )

    UpdateMatches matches ->
      ( { model | matches = matches }
      , Effects.none
      )
