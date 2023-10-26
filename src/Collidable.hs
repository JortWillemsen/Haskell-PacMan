module Collidable where
import Maze

type HitBox = [Position]

class Collidable a where
  hitBox :: a -> HitBox

-- hitBox :: Postition -> HitBox
-- hitBox p@(x, y) = [p, (x, y + tileSize - 0.1), (x + tileSize - 0.1, y + tileSize - 0.1), (x + tileSize - 0.1, y)]

collides :: Collidable a => a -> a -> Bool
collides x y = hitBox x `intersects` hitBox y

intersects :: HitBox -> HitBox -> Bool
intersects hitbox s = any (`inSquare` s) hitbox where
  inSquare :: Position -> [Position] -> Bool
  inSquare (x, y) [(bLX, bLY), _, (tRX, tRY), _] = x > bLX && y > bLY && x <= tRX && y <= tRY