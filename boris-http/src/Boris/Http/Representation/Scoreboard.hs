{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Boris.Http.Representation.Scoreboard (
    GetScoreboard (..)
  , scoreboardHtml
  ) where

import           Boris.Core.Data
import           Boris.Store.Build (BuildData (..))
import           Boris.Http.Representation.Build

import           Data.Aeson (ToJSON (..), object, (.=))

import           P

import           Text.Blaze.Html (Html, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as HA


data GetScoreboard =
  GetScoreboard [BuildData]

instance ToJSON GetScoreboard where
  toJSON (GetScoreboard bs) =
    object [
        "builds" .= fmap GetBuild bs
      ]


scoreboardHtml :: [BuildData] -> Html
scoreboardHtml bs = let
  allOk = all (maybe True (== BuildOk) . buildDataResult) bs
  buildClass = case allOk of
    False -> "notOk"
    True -> "ok"
  in
    H.html $ do
      H.head $ do
        H.link ! HA.rel "stylesheet" ! HA.type_ "text/css" ! HA.href "/assets/css/scoreboard.css"
        H.script ! HA.src "/assets/js/updateSelf.js" $ ""
      H.body ! HA.class_ buildClass $ ""
