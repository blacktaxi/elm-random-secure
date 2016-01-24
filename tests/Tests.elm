module Main where

import Task
import Console
import ElmTest exposing (..)

import Random.Secure exposing (..)

hello : Test
hello =
  suite "hello suite" <|
    [ test "hello test" <|
        assertEqual 5 5
    ]

consoleTests : Console.IO ()
consoleTests =
  consoleRunner <|
    suite "All" <|
      [ hello
      ]

port runner : Signal (Task.Task x ())
port runner = Console.run consoleTests
