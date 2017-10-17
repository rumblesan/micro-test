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
  in renderImagePortion pixelRenderer scene (0, 0) (width, height)

{--
  portion coords are given in pixels
--}
renderImagePortion ::
     Pixel px => (Color -> px) -> Scene -> (Int, Int) -> (Int, Int) -> Image px
renderImagePortion pixelRenderer scene@(Scene _ _ _ config) (x1, y1) (x2, y2) =
  let imgWidth = x2 - x1
      imgHeight = y2 - y1
  in generateImage coordColor imgWidth imgHeight
  where
    coordColor x y =
      pixelRenderer $
      getCoordColor scene (x + x1) (sceneHeight config - (y + y1))

pixelRGB8 :: Color -> PixelRGB8
pixelRGB8 (Color r g b) =
  PixelRGB8 (truncate (r * 255)) (truncate (g * 255)) (truncate (b * 255))

renderPng :: Scene -> ByteString
renderPng = encodePng . renderImage pixelRGB8
