{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Web.Spock
import           Web.Spock.Config

import           RayCaster              (Scene)
import           RayCaster.JsonSceneDef

import           Renderer               (createCoords, renderPngPortion)

type Api = SpockM () () () ()

type ApiAction a = SpockAction () () () a

main :: IO ()
main = do
  spockCfg <- defaultSpockCfg () PCNoDatabase ()
  runSpock 8080 (spock spockCfg app)

app :: Api
app = do
  get root $ text "Hello World!"
  post "scene" $ do
    x1 <- param "x1"
    y1 <- param "y1"
    x2 <- param "x2"
    y2 <- param "y2"
    scene <- jsonBody' :: ApiAction Scene
    let coords = createCoords scene (x1, y1, x2, y2)
    let img = renderPngPortion scene coords
    setHeader "Content-Type" "image/png"
    lazyBytes img
