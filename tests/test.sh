#!/bin/bash
elm-package install -y
console_version=$(node -pe 'JSON.parse(process.argv[1])["laszlopandy/elm-console"]' "$(cat elm-stuff/exact-dependencies.json)")

elm make --yes --output elm-stuff/raw-test.js Tests.elm
bash elm-stuff/packages/laszlopandy/elm-console/$console_version/elm-io.sh elm-stuff/raw-test.js elm-stuff/test.js
node elm-stuff/test.js
