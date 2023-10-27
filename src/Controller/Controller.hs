module Controller.Controller where

import Model.Ghost (Ghost (Blinky))
import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Game
import Model.Maze
import Model.Model
import Model.Move (Move, Position, down, left, right, up, Moveable (move))
import Model.Player
import Model.Score (updateScore)
import View.World

-- | Handle one iteration of the game
step :: Float -> WorldState -> IO WorldState
step interval ws@WorldState {gameState = state}
  | isPaused state == Pause = return ws
  | otherwise =
      return $
        ws
          { gameState =
              state
                { player = move $ player state,
                  score = fst updatedScore,
                  maze = snd updatedScore,
                  -- blinky = moveAlgorithm (blinky state) (player state) (maze state),
                  ticks = ticks state + 1,
                  time = time state + interval
                }
          }
  where
    updatedScore = updateScore (position (player state)) (maze state) (score state)
