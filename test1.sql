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
,IsLiveBet
-- market type
,NumberOfSelections
-- BetType, 1=single 2=combi
,CouponTypeKey
-- KEY to DW.CouponType 
,BetSettledStatus
-- KEY to DW.SettledStatus
,CASE WHEN MAX(BetSelectionTypeKey) > 1 THEN 2 ELSE 1 END AS BetSelectionTypeKey
-- KEY to DW.BetSelectionType
,BonusTypeKey
-- KEY to DW.BonusType
,CashoutParticipation
-- KEY to DW.VW_CashoutParticipation
,BetStakeEURBucketKey
-- KEY to DW.BucketBetStake
,CASE WHEN MAX(SelectionsBucket) = 999 THEN MIN(SelectionsBucket) ELSE MAX(SelectionsBucket) END AS SelectionsBucket
-- KEY to DW.BucketSelections
,CASE WHEN numberofselections = 1 AND CouponTypeKey = 1 THEN BetGroupKey ELSE 0 END AS BetGroupKey
-- KEY to DW.BetGroup
,EXP(SUM(LOG(NULLIF(BetSelectionOdds, 0)))) AS Odds

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
AND CouponTypeKey=1
AND ReportingDate='2025-05-01'

GROUP BY
reportingdate,
CountryKey,
b.CustomerKey,
b.SegmentKey,  
b.CouponID,
BetSettledStatus,
BetStakeEURBucketKey,
NumberOfSelections,
CouponTypeKey,
IsMobileBet,
IsLiveBet,
CashoutParticipation,
BonusTypeKey,
CASE WHEN numberofselections = 1 AND CouponTypeKey = 1 THEN BetGroupKey ELSE 0 END
