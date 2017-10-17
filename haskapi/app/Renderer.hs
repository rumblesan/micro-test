module Renderer where

import           Data.ByteString.Lazy

import           Codec.Picture
import           Codec.Picture.Png

import           RayCaster            (Config (..), Scene (..))
import           RayCaster.Color      (Color (..))
import           RayCaster.Render     (getCoordColor)

renderImage :: Pixel px => (Color -> px) -> Scene -> Image px
renderImage pixelRenderer scene@(Scene _ _ _ config) =
  let width = sceneWidth config
      height = sceneHeight config
  in generateImage
       (\x y -> pixelRenderer $ getCoordColor scene x (height - y))
       width
       height

pixelRGB8 :: Color -> PixelRGB8
pixelRGB8 (Color r g b) =
  PixelRGB8 (truncate (r * 255)) (truncate (g * 255)) (truncate (b * 255))

renderPng :: Scene -> ByteString
renderPng = encodePng . renderImage pixelRGB8
