{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE DeriveGeneric   #-}

module Lib
    ( startApp,
      Application
    ) where

import Control.Monad.Trans.Either
import Data.Maybe
import Data.Aeson
import Data.Aeson.TH
import Data.Time.Calendar
import Data.List.Split
import GHC.Generics
import Network.Wai
import Network.Wai.Handler.Warp
import Servant

data OperationResult = OperationResult
  { result        :: Integer
  } deriving (Eq, Show)

-- data FractionalOperationResult = FractionalOperationResult
--   { result        :: Fractional
--   } deriving (Eq, Show)

$(deriveJSON defaultOptions ''OperationResult)

type API =
       "sum" :> QueryParams "operand" Integer :> Get '[JSON] OperationResult
  :<|> "difference" :> QueryParams "operand" Integer :> Get '[JSON] OperationResult
  :<|> "product" :> QueryParams "operand" Integer :> Get '[JSON] OperationResult
  :<|> "quotient" :> QueryParams "operand" Integer :> Get '[JSON] OperationResult

startApp :: IO ()
startApp = run 8080 app

app :: Application
app = serve api server

api :: Proxy API
api = Proxy

server :: Server API
server = getSum
  :<|> getDifference
  :<|> getProduct
  :<|> getQuotient

type Handler = EitherT ServantErr IO OperationResult

getSum :: [Integer] -> Handler
getSum nums = return $ OperationResult $ sum nums

getDifference :: [Integer] -> Handler
getDifference nums = return $ OperationResult $ doSubtract nums
  where doSubtract (n:rest) = foldl (-) n rest

getProduct :: [Integer] -> Handler
getProduct nums = return $ OperationResult $ product nums

getQuotient :: [Integer] -> Handler
getQuotient nums = return $ OperationResult $ doDivide nums
  where doDivide (n:rest) = foldl quot n rest
