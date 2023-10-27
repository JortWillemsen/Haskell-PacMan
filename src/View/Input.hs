module View.Input where

import Graphics.Gloss.Interface.IO.Game (Event (EventKey), Key (Char), KeyState (Down, Up))
import Model.Model
import View.World
import Model.Player (Player(Player), InputBuffer, Toggled (Depressed, Released))

input :: Event -> WorldState -> IO WorldState
input e ws@WorldState {gameState = state} = return ws {gameState = handleKey e state}

-- Handle pause key
handleKey :: Event -> GameState -> GameState
handleKey (EventKey (Char 'p') t _ _) state
  | t == Down = state {isPaused = pauseGame (isPaused state)}
  | t == Up = state

-- Handle Player movement keys
handleKey (EventKey (Char c) _ _ _) state = state {player = updateInputForPlayer c (player state)}
handleKey _ state = state

-- updates the input buffer of a player when a key is pressed
updateInputForPlayer :: Char -> Player -> Player
updateInputForPlayer c (Player s pos ibs d) = Player s pos (updateInputBuffer' c ibs) d
  where
    -- updates the input buffer list of a player, making sure one key is depressed at a time
    updateInputBuffer' :: Char -> [InputBuffer] -> [InputBuffer]
    updateInputBuffer' c [] = []
    updateInputBuffer' c (ib@(k, t, a) : ibs)
      | c == k = (k, Depressed, a) : updateInputBuffer' c ibs
      | otherwise = (k, Released, a) : updateInputBuffer' c ibs