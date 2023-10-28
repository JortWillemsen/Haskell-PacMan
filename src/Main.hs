module Main where

import Controller
import Graphics.Gloss (loadBMP)
import Graphics.Gloss.Interface.Environment (getScreenSize)
import Graphics.Gloss.Interface.IO.Game
import Maze (getMazeSize)
import Model
import View
import World

main :: IO ()
main = do
  state <- createWorldState 1
  playIO
    (InWindow "Puck-Man" (calculateScreenSize state) (0, 0)) -- Or FullScreen
    black -- Background color
    30 -- Frames per second
    state -- Initial state
    view
    input -- Event function
    step -- Step function
