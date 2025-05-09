SELECT
-- DIMENSIONS
reportingdate			
-- Date 
,b.CustomerKey			
-- KEY to DW.Customer
,b.SegmentKey			
-- KEY to DW.Segment
,b.CouponID	
-- Coupon ID
,CountryKey
-- KEY to DW.Country
,IsMobileBet
-- device
,MAX(CAST(IsLiveBet AS INT)) AS IsLiveBet
-- market type
,MAX(NumberOfSelections) AS NumberOfSelections
-- BetType, 1=single 2=combi
,MAX(CouponTypeKey) AS CouponTypeKey
-- KEY to DW.CouponType 
,MAX(BetSettledStatus) AS BetSettledStatus
-- KEY to DW.SettledStatus
,CASE WHEN MAX(BetSelectionTypeKey) > 1 THEN 2 ELSE 1 END AS BetSelectionTypeKey
-- KEY to DW.BetSelectionType
,MAX(BonusTypeKey) AS BonusTypeKey
-- KEY to DW.BonusType
,MAX(CashoutParticipation) AS CashoutParticipation
-- KEY to DW.VW_CashoutParticipation
,MAX(BetStakeEURBucketKey) AS BetStakeEURBucketKey
-- KEY to DW.BucketBetStake
,CASE WHEN MAX(SelectionsBucket) = 999 THEN MIN(SelectionsBucket) ELSE MAX(SelectionsBucket) END AS SelectionsBucket
-- KEY to DW.BucketSelections
,0 AS BetGroupKey
-- KEY to DW.BetGroup
,NULL AS Odds

-- MEASURES
,SUM(BSStandardSettledStake) AS StandardSettledStake
,SUM(BSRewardSettledStake) AS RewardSettledStake
,SUM(BSStandardVoidedStake) AS StandardVoidedStake
,SUM(BSRewardVoidedStake) AS RewardVoidedStake
,SUM(CashoutStakeValue) AS CashoutStakeValue
,SUM(BSStandardPayout) AS StandardPayout
,SUM(BSRewardPayout) AS RewardPayout
,SUM(BSCashout) AS CashoutPayout
,SUM(BSProfit) AS Profit
,SUM(BSRevenue) AS Revenue  

FROM MARTCUBE.BetSelectionFlat b WITH(NOLOCK) 
INNER JOIN dw.Customer c WITH(NOLOCK) ON b.customerkey = c.customerkey  

WHERE 
betsettledstatus IN (3, 4, 5, 6, 7)
AND b.AccountTypeKey = 1
AND CouponTypeKey<>1
AND ReportingDate='2025-05-01'

GROUP BY
reportingdate,
CountryKey,
b.CustomerKey,
b.SegmentKey,
b.CouponID,
IsMobileBet
