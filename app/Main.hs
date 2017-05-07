{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Main where

import qualified System.Environment as OS
import qualified Data.ByteString.Char8 as S8
import Network.Wreq
import Control.Lens hiding ((.=))
import Data.Aeson
import Data.Aeson.Lens
import GHC.Generics (Generic)

main :: IO ()
main = do
  token <- OS.getEnv "TOKEN"
  let opts = defaults
         & header "Content-Type" .~ ["application/json"]
         & header "Authorization" .~ [S8.pack . concat $ "Bearer " : lines token]
  print opts
  r <- getWith opts url
  let ds = parseDroplets $ r ^. responseBody
  print ds
  r <- traverse (traverse (deleteWith opts . (url++) . show)) ds
  r <- postWith opts url (toJSON createDroplet)
  print r
  print "end"


parseDroplets :: AsValue s => s -> Maybe [Integer]
parseDroplets json =
  sequenceA
  $ json ^.. key "droplets"
  . _Array
  . traverse
  . to (^? key "id" . _Integer)

data Droplet =
  Droplet {name :: String
  , region :: String
  , size :: String
  , image :: String
  } deriving (Generic, Show)
  
instance ToJSON Droplet

createDroplet =
  Droplet "ainur-lon" "lon1" "512mb" "ubuntu-17-04-x64"
  

url :: String
url =
  "https://api.digitalocean.com/v2/droplets/"

