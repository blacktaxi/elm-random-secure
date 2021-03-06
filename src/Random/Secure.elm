module Random.Secure exposing (int, ints, bool, bools, float, floats)

{-| A library for generating cryptographically random values.

Contrary to the [`Random`](#Random) module, which provides purely functional,
and therefore repeatable random generators, this module allows you to
generate cryptographically random values that can be used in applications
where security is required.

All generation functions return a [`Task`](#Task), as the
generation algorithm is dependent on the browser's global state
(the [`getRandomValues`](https://developer.mozilla.org/en-US/docs/Web/API/RandomSource/getRandomValues) function])
and is not referentially transparent.

*Note:* As this library depends on the
[`window.crypto.getRandomValues`](https://developer.mozilla.org/en-US/docs/Web/API/RandomSource/getRandomValues)
JavaScript API, it therefore will share all the randomness qualities with the underlying
implementation.

# Primitive random values
@docs int, bool, float

# Lists of random values
@docs ints, bools, floats

-}

import Native.SecureRandom
import Task exposing (Task)

type Error
  = NoGetRandomValues
  | Exception String String

{-| Generate a random 32-bit integer in a given range.

    int 0 10            -- an integer between zero and ten
    int -5 5            -- an integer between -5 and 5
    int 0 (2 ^ 32 - 1)  -- an integer in the widest range feasible

This function can *not* produce sufficiently random values if `abs (to - from)` is
greater than the largest unsigned 32-bit integer (usually `4294967295`).

Moreover, the quality of the produced output is dependent on
`window.crypto.getRandomValues` – which is what this function uses under the hood.
-}
int : Int -> Int -> Task Error Int
int from to =
  Native.SecureRandom.getRandomInt ()
  |> Task.map (compressInt from to)

{-| Generate a list of random 32-bit integers in a given range.

    ints 3 133 7        -- a list of 7 integers between 3 and 133
-}
ints : Int -> Int -> Int -> Task Error (List Int)
ints from to n =
  -- @TODO how do we arg check here? do we throw errors in JS? Task.fail? etc?
  Native.SecureRandom.getRandomInts (min 0 n)
  |> Task.map (List.map (compressInt from to))

{-| Generate a random boolean value.

    type Flip = Heads | Tails

    coinFlip : Task x Flip
    coinFlip = map (\x -> if x then Heads else Tails) bool
-}
bool : Task Error Bool
bool =
  Native.SecureRandom.getRandomInt ()
  |> Task.map (\x -> x % 2 == 0)

{-| Generate a list of random boolean values.
-}
bools : Int -> Task Error (List Bool)
bools n =
  Native.SecureRandom.getRandomInts (min 0 n)
  |> Task.map (List.map (\x -> x % 2 == 0))

{-| Generate a random floating point number in a given range.

    float 3.1 33.7      -- a floating point number between 3.1 and 33.7
-}
float : Float -> Float -> Task Error Float
float from to =
  Native.SecureRandom.getRandomInt ()
  |> Task.map (compressFloat from to)

{-| Generate a list of random floating point numbers in a given range.

    floats 3.1 3.3 7    -- a list of 7 floating point numbers between 3.1 and 3.3
-}
floats : Float -> Float -> Int -> Task Error (List Float)
floats from to n =
  Native.SecureRandom.getRandomInts (min 0 n)
  |> Task.map (List.map (compressFloat from to))

compressInt : Int -> Int -> Int -> Int
compressInt from to x = x % (to - from + 1) + from

compressFloat : Float -> Float -> Int -> Float
compressFloat from to x = from + (to - from) * (toFloat x / toFloat maxUint32)

maxUint32 : Int
maxUint32 = 2 ^ 32 - 1
