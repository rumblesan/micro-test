module Main where

import           Test.Framework

import           Data.Monoid

import           Tests.Simple   (simpleTests)

main :: IO ()
main = defaultMainWithOpts [simpleTests] mempty
