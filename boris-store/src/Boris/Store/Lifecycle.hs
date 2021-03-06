{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Boris.Store.Lifecycle (
    initialise
  , destroy
  ) where

import           Boris.Core.Data
import qualified Boris.Store.Schema as Schema

import           Mismi (AWS)

import           P

import qualified Spine.Schema as Spine

import           X.Control.Monad.Trans.Either

initialise :: Environment -> EitherT Text AWS ()
initialise e =
  firstT Spine.renderInitialisationError .
    Spine.initialise $ Schema.schema e

destroy :: Environment -> AWS ()
destroy e =
  Spine.destroy $ Schema.schema e
