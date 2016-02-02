// Main entrypoint file
require( '../dist/index.html' );

// pull in desired CSS/SASS files
require( './styles/app.css' );

var Elm = require( './Main' );
var elmApp = Elm.embed(Elm.Main, document.getElementById('main'), {
  updateMatches: []
});

// Fetch match list from Google Spreadsheet
var Tabletop = require('tabletop/src/tabletop.js');
Tabletop.init({
  key: '10xfPxMP-w-Ybyy46jUN5VSnSzIap2V_S2UdVmdYg7tM',
  callback: function(data, tabletop) {
    // Send match list to elm app
    var formattedData = data.map(function(match) {
      return {
        date: match['Date'],
        event: match['Event'],
        gameVersion: match['Game version'],
        p1: match['Player 1'],
        p1Char: match['P1 Character'],
        p2: match['Player 2'],
        p2Char: match['P2 Character'],
        winner: match['Winner'],
        matchType: match['Match type'],
        url: match['URL'],
        notes: match['Notes'],
      };
    });
    console.log(formattedData);
    elmApp.ports.updateMatches.send(formattedData);
  },
  simpleSheet: true
});
