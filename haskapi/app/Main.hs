{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Web.Spock
import           Web.Spock.Config

import           RayCaster              (Scene)
import           RayCaster.JsonSceneDef

import           Renderer               (renderPng)

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
    scene <- jsonBody' :: ApiAction Scene
    let img = renderPng scene
    setHeader "Content-Type" "image/png"
    lazyBytes img
