module Main where

import qualified Control.Monad as M
import qualified System.Environment as E
import qualified System.Process as P

import Debug.Trace

main :: IO ()
main =
  getTargetDirectory >>= runMinttyAt


getTargetDirectory :: IO String
getTargetDirectory =
  head <$> E.getArgs


runMinttyAt :: String -> IO ()
runMinttyAt targetDirectory = do
  let mintty = (P.proc "mintty" []){ P.cwd = Just targetDirectory }
  M.void $ P.createProcess mintty
