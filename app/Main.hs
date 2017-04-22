{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified System.Environment as OS
import qualified Data.ByteString.Char8 as S8
import Network.Wreq
import Control.Lens

main :: IO ()
main = do
  token <- OS.getEnv "TOKEN"
  let opts =
        defaults & header "Authorization" .~ [S8.pack $ "Bearer " ++ token]
  r <- getWith opts "https://api.digitalocean.com/v2/droplets"
  putStrLn $ show r



