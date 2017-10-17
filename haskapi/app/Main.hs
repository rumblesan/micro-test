{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Web.Spock
import           Web.Spock.Config

import           Codec.Picture
import           Codec.Picture.Png
import           Data.ByteString.Lazy

import           RayCaster              (Config (..), Scene (..))
import           RayCaster.Color        (Color (..))
import           RayCaster.JsonSceneDef
import           RayCaster.Render       (getCoordColor)

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
    let img = renderImage scene
    setHeader "Content-Type" "image/png"
    lazyBytes img

renderImage :: Scene -> ByteString
renderImage scene@(Scene _ _ _ config) =
  let width = sceneWidth config
      height = sceneHeight config
      img =
        generateImage
          (\x y -> pixelRGB8 $ getCoordColor scene x (height - y))
          width
          height
  in encodePng img

pixelRGB8 :: Color -> PixelRGB8
pixelRGB8 (Color r g b) =
  PixelRGB8 (truncate (r * 255)) (truncate (g * 255)) (truncate (b * 255))
