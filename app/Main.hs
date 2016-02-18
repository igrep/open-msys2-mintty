module Main where

import qualified Data.List as L
import qualified Control.Monad as M
import qualified System.Environment as E
import qualified System.FilePath as F
import qualified System.Process as P

import Debug.Trace

main :: IO ()
main = do
  msys2Root <- getMsys2Root
  let cygpathPath = getCygpathPath msys2Root
  let minttyPath = getMinttyPath msys2Root
  targetDirectory <- getTargetDirectory
  cygwinTargetDirectory <- runCygpath cygpathPath targetDirectory
  runMintty minttyPath cygwinTargetDirectory


getMsys2Root :: IO String
getMsys2Root =
  E.getEnv "MSYS2_ROOT"


getCygpathPath :: String -> String
getCygpathPath msys2Root =
  F.joinPath [msys2Root, "usr", "bin", "cygpath.exe"]


getMinttyPath :: String -> String
getMinttyPath msys2Root =
  F.joinPath [msys2Root, "usr", "bin", "mintty.exe"]


getTargetDirectory :: IO String
getTargetDirectory =
  head <$> E.getArgs


runCygpath :: String -> String -> IO String
runCygpath cygpathPath targetDirectory = do
  result <- P.readProcess cygpathPath [targetDirectory] ""
  if L.isSuffixOf "\n" result
    then return $ init result
    else return $ result


runMintty :: String -> String -> IO ()
runMintty minttyPath cygwinTargetDirectory = do
  traceIO $ P.showCommandForUser minttyPath ["/bin/sh", "-lc", "'cd \"" ++ cygwinTargetDirectory ++ "\" ; exec bash'"]
  M.void $ P.spawnProcess minttyPath ["/bin/sh", "-lc", "'cd \"" ++ cygwinTargetDirectory ++ "\" ; exec bash'"]
