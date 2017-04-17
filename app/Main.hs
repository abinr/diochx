{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified System.Environment as OS
import Network.HTTP.Simple
import qualified Data.ByteString.Char8 as S8

main :: IO ()
main = do
  env <- OS.getEnv "TOKEN"
  let
    request =
      setRequestHeader "Authorization" [S8.pack $ "Bearer " ++ env]
      $ "GET https://api.digitalocean.com/v2/droplets"
  response <- httpJSON request
  putStrLn $ getResponseBody response
