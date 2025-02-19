SELECT
reportingdate
,CustomerKey
,SegmentKey
,CountryKey
,key_betdetails
,key_betbucket
,BetGroupKey
,Odds
,COUNT(DISTINCT BetKey) AS Bets
,SUM(StandardSettledStake) AS StandardSettledStake
,SUM(RewardSettledStake) AS RewardSettledStake
,SUM(StandardVoidedStake) AS StandardVoidedStake
,SUM(RewardVoidedStake) AS RewardVoidedStake
,SUM(CashoutStakeValue) AS CashoutStakeValue
,SUM(StandardPayout) AS StandardPayout
,SUM(RewardPayout) AS RewardPayout
,SUM(CashoutPayout) AS CashoutPayout
,SUM(Profit) AS Profit
,SUM(Revenue) AS Revenue

FROM

(SELECT
-- DIMENSIONS
reportingdate,  -- Date 
b.CustomerKey,  -- ID for customers -- KEY to DW.Customer
b.SegmentKey,
b.BetKey,
CountryKey,
CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 
CONCAT(
IsMobileBet, '|', 
IsLiveBet, '|',
NumberOfSelections, '|',
CouponTypeKey, '|',
BetSettledStatus, '|',
CASE WHEN MAX(BetSelectionTypeKey) > 1 THEN 2 ELSE 1 END, '|',
BonusTypeKey, '|',
CashoutParticipation)), 2) AS key_betdetails,
CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 
CONCAT(
BetStakeEURBucketKey, '|', 
CASE WHEN MAX(SelectionsBucket) = 999 THEN MIN(SelectionsBucket) ELSE MAX(SelectionsBucket) END)), 2) 
AS key_betbucket,
CASE WHEN numberofselections = 1 AND CouponTypeKey = 1 THEN BetGroupKey ELSE 0 END AS BetGroupKey,  -- KEY to DW.BetGroup
EXP(SUM(LOG(NULLIF(BetSelectionOdds, 0)))) AS Odds,
-- MEASURES
--COUNT(DISTINCT BetKey) AS Bets,
SUM(BSStandardSettledStake) AS StandardSettledStake,
SUM(BSRewardSettledStake) AS RewardSettledStake,
SUM(BSStandardVoidedStake) AS StandardVoidedStake,
SUM(BSRewardVoidedStake) AS RewardVoidedStake,
SUM(CashoutStakeValue) AS CashoutStakeValue,
SUM(BSStandardPayout) AS StandardPayout,
SUM(BSRewardPayout) AS RewardPayout,
SUM(BSCashout) AS CashoutPayout,
SUM(BSProfit) AS Profit,
SUM(BSRevenue) AS Revenue  

FROM MARTCUBE.BetSelectionFlat b WITH(NOLOCK) 
INNER JOIN dw.Customer c WITH(NOLOCK) ON b.customerkey = c.customerkey  

WHERE 
betsettledstatus IN (3, 4, 5, 6, 7)
AND b.AccountTypeKey = 1
AND ReportingDate = '2025-01-01'

GROUP BY
reportingdate,  -- Date
CountryKey,  -- KEY to DW.Country
b.CustomerKey,  -- ID for customers -- KEY to DW.Customer
b.SegmentKey,  -- KEY to DW.Segment
b.BetKey,
BetSettledStatus,  -- KEY to DW.SettledStatus
BetStakeEURBucketKey,  -- KEY to DW.BucketBetStake
NumberOfSelections,  -- BetType, 1=single 2=combi
CouponTypeKey,  -- KEY to DW.CouponType
IsMobileBet,  -- Device
IsLiveBet,  -- MarketType
CashoutParticipation,  -- KEY to DW.VW_CashoutParticipation
BonusTypeKey,  -- KEY to DW.BonusType
CASE WHEN numberofselections = 1 AND CouponTypeKey = 1 THEN BetGroupKey ELSE 0 END
) main

GROUP BY
reportingdate
,CustomerKey
,SegmentKey
,CountryKey
,key_betdetails
,key_betbucket
,BetGroupKey
,Odds
