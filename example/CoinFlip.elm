module CoinFlip where

import Effects exposing (Effects)
import Signal exposing (Signal, Address)
import Task exposing (Task)
import StartApp
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import SecureRandom

type alias Model = { coin : Maybe Bool }

type Action = Toss | Catch (Maybe Bool)

initModel : Model
initModel = { coin = Nothing }

initAction : (Model, Effects Action)
initAction = (initModel, Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Toss ->
      ( model
      , SecureRandom.bool
          |> Task.toMaybe
          |> Task.map Catch
          |> Effects.task
      )

    Catch coin ->
      ({ model | coin = coin }, Effects.none)

view : Address Action -> Model -> Html
view addr model =
  div [] <|
    case model.coin of
      Nothing ->
        [ button
            [ onClick addr Toss ]
            [ text "Toss a coin..." ]
        ]

      Just coin ->
        [ p
            []
            [ text <| if coin then "Heads!" else "Tails!" ]
        , button
            [ onClick addr Toss]
            [ text "Toss again!" ]
        ]

app : StartApp.App Model
app =
  StartApp.start
    { init = initAction
    , update = update
    , view = view
    , inputs = []
    }

main : Signal Html
main = app.html

port tasks : Signal (Task.Task Effects.Never ())
port tasks = app.tasks
