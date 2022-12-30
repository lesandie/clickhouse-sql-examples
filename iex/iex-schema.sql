#!/bin/bash
CH_CLIENT="clickhouse-client --host=logos3 --user=demo --password=demo -n -m"
set -ex
$CH_CLIENT --database=iex << SQL
DROP TABLE IF EXISTS iex.quote
;
CREATE TABLE iex.quote (
avgTotalVolume UInt64,
calculationPrice String,
change Decimal64(2), 
changePercent Float64,
close Decimal64(2),
closeSource String,
closeTime UInt64,
companyName String,
currency String,
delayedPrice Decimal64(2),
delayedPriceTime DateTime64(3),
extendedChange Decimal64(2),
extendedChangePercent Decimal64(2),
extendedPrice Decimal64(2),
extendedPriceTime DateTime64(3),
high Decimal64(2),
highSource String,
highTime DateTime64(3),
iexAskPrice Decimal64(2),
iexAskSize UInt64,
iexBidPrice Decimal64(2),
iexBidSize UInt64,
iexClose Decimal64(2),
iexCloseTime DateTime64(3),
iexLastUpdated DateTime64(3),
iexMarketPercent Float64,
iexOpen Decimal64(2),
iexOpenTime DateTime64(3),
iexRealtimePrice Decimal64(2),
iexRealtimeSize UInt64,
iexVolume UInt64,
lastTradeTime DateTime64(3),
latestPrice Decimal64(2),
latestSource String,
latestTime String,
latestUpdate DateTime64(3),
latestVolume UInt64,
low Decimal64(2),
lowSource String,
lowTime DateTime64(3),
marketCap UInt64,
oddLotDelayedPrice Decimal64(2),
oddLotDelayedPriceTime DateTime64(3),
open Decimal64(2),
openTime DateTime64(3),
  openSource String,
  peRatio Decimal64(2),
  previousClose Decimal64(2),
  previousVolume UInt64,
  primaryExchange String,
  symbol String,
  volume UInt64,
  week52High Decimal64(2),
  week52Low Decimal64(2),
  ytdChange Float64,
  isUSMarketOpen Boolean
) Engine=MergeTree
PARTITION BY toYYYYMM(lastTradeTime) 
ORDER BY (symbol, lastTradeTime)
;
DROP TABLE IF EXISTS iex.stock_quote
;
CREATE TABLE iex.stock_quote (
  symbol String default JSONExtractString(json, 'symbol'),
  latestTime DateTime default toDateTime(JSONExtractUInt(json, 'lastTradeTime')),
  json String,
  upload_date Datetime DEFAULT now()
) Engine=MergeTree
PARTITION BY toYYYYMM(latestTime) 
ORDER BY (symbol, latestTime)
;
DROP TABLE IF EXISTS iex.stock_quote_json
;
SET allow_experimental_object_type = 1
;
CREATE TABLE iex.stock_quote_json (
  json JSON,
  upload_date Datetime DEFAULT now()
) Engine=MergeTree
PARTITION BY tuple()
ORDER BY tuple()
;
SHOW TABLES FROM iex
;
SQL
