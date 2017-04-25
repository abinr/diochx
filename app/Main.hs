{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified System.Environment as OS
import qualified Data.ByteString.Char8 as S8
import Network.Wreq
import Control.Lens
import Data.Aeson
import Data.Aeson.Lens

main :: IO ()
main = do
  token <- OS.getEnv "TOKEN"
  let opts =
        defaults & header "Authorization" .~ [S8.pack $ "Bearer " ++ token]
  r <- getWith opts $ url ++ "droplets"
  print $ listDroplets $ r ^. responseBody

listDroplets :: AsValue s => s -> Maybe [Integer]
listDroplets json =
  sequenceA
  $ json ^.. key "droplets"
  . _Array
  . traverse
  . to (^? key "id" . _Integer)

url :: String
url =
  "https://api.digitalocean.com/v2/"

