# elm-random-secure [![Build Status](https://travis-ci.org/blacktaxi/elm-random-secure.svg)](https://travis-ci.org/blacktaxi/elm-random-secure)

Cryptographic random number generation for Elm.

A simple wrapper around the [`window.crypto.getRandomValues`](https://developer.mozilla.org/en-US/docs/Web/API/RandomSource/getRandomValues)
API to generate cryptographic random values in Elm.

## Example

Random generation function return a `Task`. Depending on your use case, you might want to convert
the task to an `Effects` or otherwise use it.

Assuming you're using [start-app](https://github.com/evancz/start-app), in your `update` function:

```elm
update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Toss ->
      ( model
      , SecureRandom.bool -- generating a random Bool value here
          |> Task.toMaybe
          |> Task.map Catch
          |> Effects.task
      )

    Catch coin ->
      ({ model | coin = coin }, Effects.none)
```

### TODO

-   Tests
-   Invalid argument handling
