module Renderer where

import           Data.ByteString.Lazy
import           Data.Maybe           (fromMaybe)

import           Codec.Picture
import           Codec.Picture.Png

import           RayCaster            (Config (..), Scene (..))
import           RayCaster.Color      (Color (..))
import           RayCaster.Render     (getCoordColor)

type ImgCoord = (Int, Int, Int, Int)

renderImage :: Pixel px => (Color -> px) -> Scene -> Image px
renderImage pixelRenderer scene@(Scene _ _ _ config) =
  let width = sceneWidth config
      height = sceneHeight config
  in renderImagePortion pixelRenderer scene (0, 0, width, height)

{--
  portion coords are given in pixels
--}
renderImagePortion :: Pixel px => (Color -> px) -> Scene -> ImgCoord -> Image px
renderImagePortion pixelRenderer scene@(Scene _ _ _ config) (x1, y1, x2, y2) =
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

renderPngPortion :: Scene -> ImgCoord -> ByteString
renderPngPortion scene coords =
  encodePng $ renderImagePortion pixelRGB8 scene coords

createCoords ::
     Scene -> (Maybe Int, Maybe Int, Maybe Int, Maybe Int) -> ImgCoord
createCoords scene@(Scene _ _ _ config) (mx1, my1, mx2, my2) =
  let x1 = fromMaybe 0 mx1
      y1 = fromMaybe 0 my1
      x2 = fromMaybe (sceneWidth config) mx2
      y2 = fromMaybe (sceneHeight config) my2
  in (min x1 x2, min y1 y2, max x1 x2, max y1 y2)
