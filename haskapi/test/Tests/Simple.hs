module Tests.Simple where

import           Test.Framework                       (Test, testGroup)
import           Test.Framework.Providers.HUnit       (testCase)
import           Test.Framework.Providers.QuickCheck2 (testProperty)
import           Test.HUnit                           (Assertion, assertEqual)

simpleTests :: Test
simpleTests =
  testGroup "Simple tests" [testCase "First simple tests" test_first_simple]

test_first_simple :: Assertion
test_first_simple =
  let expected = "Simple"
  in assertEqual "" expected "Simple"
