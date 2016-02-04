# SF5DB

Database of Street Fighter 5 matches, written as my gateway drug to Elm. Uses
[elm-webpack-starter][5] as a starting point.

Matches are pulled from [a Google Spreadsheet][1] using [Tabletop][2], then passed into Elm using
[a port][3].

## Install:

I used NodeJS 5.4.0. Other versions might just work. Whatever.

If you haven't done so yet, install Elm globally:

```bash
npm install -g elm
```

Install Elm's dependencies:

```bash
npm install
elm package install
```

## Serve locally:

```bash
npm start
```

Then access app at `http://localhost:3000/`.


## Build & bundle for prod:

The push command makes use of [ghp-import][4]. If you don't have it already:

```bash
sudo pip3 install ghp-import
```

Then:

``` bash
npm run build  # compile everything into **./dist/**
npm run push  # use `ghp-import` to deploy onto GitHub Pages
```

Or use the shorthand that runs both of those commands:

```bash
npm run deploy
```

## Disclaimer

This is baby's first step into Elm. Don't look at this source code for inspiration... yet.

[1]: https://docs.google.com/spreadsheets/d/10xfPxMP-w-Ybyy46jUN5VSnSzIap2V_S2UdVmdYg7tM/pub?gid=0#
[2]: https://github.com/jsoma/tabletop
[3]: http://elm-lang.org/guide/interop
[4]: https://github.com/davisp/ghp-import
[5]: https://github.com/pmdesgn/elm-webpack-starter
