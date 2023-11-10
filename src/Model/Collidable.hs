module Model.Collidable where
import Data.List (intersect)

type Position = (Float, Float)

type HitBox = [Position]

-- | Every entity in the game that can be collided with needs derive from this class
class (Eq a) => Collidable a where
  hitBox :: a -> HitBox         -- Defines the size and position of the hitbox relative to the entity
  collisions :: a -> [String]   -- Defines the entities it can collide with
  name :: a -> String           -- Defines it's own name for other collision derivations

-- | Checks if a collision has occurred between two collidables
collides :: (Collidable a, Collidable b) => a -> b -> Bool
collides x y = hitBox x `intersects` hitBox y && collidesWith x y (collisions x)

-- | Checks if a collision has occurred between an entity and a list of collidables
--   Returns the collidable that the entity has collided with
collidesReturn :: (Collidable a, Collidable b) => a -> [b] -> Maybe b
collidesReturn x = foldr f Nothing
  where
        f c r =
          if x `collides` c
            then Just c
            else r

-- | Checks if a collidable collides with another collidable that has a specific tag
collidesWith :: (Collidable a, Collidable b) => a -> b -> [String] -> Bool
collidesWith x y tags = x `collides` y && name y `elem` tags

-- | Checks if a hitbox intersects with another hitbox
intersects :: HitBox -> HitBox -> Bool
intersects hitbox s = any (`inSquare` s) hitbox || any (`inSquare` hitbox) s where
  -- | Checks if a position is inside a hitbox
  inSquare :: Position -> HitBox -> Bool
  inSquare _ [] = False
  inSquare (x, y) [(bLX, bLY), _, (tRX, tRY), _] = x > bLX && y > bLY && x <= tRX && y <= tRY