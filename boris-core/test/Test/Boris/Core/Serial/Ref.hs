{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Test.Boris.Core.Serial.Ref where

import           Boris.Core.Data
import           Boris.Core.Serial.Ref

import qualified Data.Text.IO as T

import           Disorder.Core.IO

import           P

import           Test.QuickCheck



prop_parse_ok =
  conjoin [
      check "test/data/config/ref/v1/empty.toml" . Right $ [
        ]
    , check "test/data/config/ref/v1/basic.toml" . Right $ [
          BuildQuery
            (Build "basic")
            (Query "refs/heads/basic")
        ]
    , check "test/data/config/ref/v1/multiple.toml" . Right $ [
          BuildQuery
            (Build "basic")
            (Query "refs/heads/basic")
        , BuildQuery
            (Build "second")
            (Query "refs/heads/*")
        ]
    ]

prop_parse_error =
  conjoin [
      check "test/data/config/ref/v1/invalid.no-version.toml" . Left $
        QueryConfigMissingVersionError
    , check "test/data/config/ref/v1/invalid.unknown-version.toml" . Left $
        QueryConfigUnknownVersionError 2
    , check "test/data/config/ref/v1/invalid.no-reference.toml" . Left $
        QueryConfigNoReference (Build "basic")
    ]

check path expected =
  testIO $ do
    f <- T.readFile path
    pure $ (fmap (sortOn buildName) $ parseQueryConfig f) === fmap (sortOn buildName) expected


return []
tests = $quickCheckAll