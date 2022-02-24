{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

module Main where

import qualified ArrayFire as A
import Control.Exception (catch)
import HomingPigeon

main :: IO ()
main = print newArray `catch` (\(e :: A.AFException) -> print e)
  where
    newArray = A.matrix @Double (2, 2) [[1 ..], [1 ..]] * A.matrix @Double (2, 2) [[2 ..], [2 ..]]
