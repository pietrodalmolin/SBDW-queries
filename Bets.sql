SELECT
--DIMENSIONS
reportingdate														-- Date
,BetKey																-- ID for bets
,CouponID															-- ID for coupons
,b.CustomerKey														-- ID for customers -- KEY to DW.Customer
,CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 
CONCAT(
b.SegmentKey, '|', 
c.CountryKey)), 2) 
AS key_geo
,CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 
CONCAT(
IsMobileBet, '|', 
IsLiveBet, '|',
NumberOfSelections, '|',
CouponTypeKey, '|',
BetSettledStatus, '|',
CASE WHEN MAX(BetSelectionTypeKey) > 1 THEN 2 ELSE 1 END, '|',
BonusTypeKey, '|',
CashoutParticipation)), 2) 
AS key_betdetails
,CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 
CONCAT(
BetStakeEURBucketKey, '|', 
SelectionsBucket)), 2) 
AS key_betbucket
,CASE WHEN numberofselections=1 AND CouponTypeKey=1 THEN BetGroupKey ELSE 0 END AS BetGroupKey						-- KEY to DW.BetGroup

--MEASURES
,EXP(SUM(LOG(NULLIF(BetSelectionOdds, 0)))) AS Odds				
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
INNER JOIN dw.Customer c WITH(NOLOCK) ON b.customerkey = c.customerkey --WITH(NOLOCK)
WHERE 
betsettledstatus IN (3, 4, 5, 6, 7)
AND b.AccountTypeKey = 1
AND ReportingDate='2024-11-01'

GROUP BY
reportingdate														-- Date
,BetKey																-- ID for bets
,CouponID															-- ID for coupons
,CountryKey															-- KEY to DW.Country
,b.CustomerKey														-- ID for customers -- KEY to DW.Customer
,b.SegmentKey															-- KEY to DW.Segment
,BetSettledStatus													-- KEY to DW.SettledStatus
,BetStakeEURBucketKey												-- KEY to DW.BucketBetStake
,NumberOfSelections													-- BetType, 1=single 2=combi
,CouponTypeKey														-- KEY to DW.CouponType
,IsMobileBet														-- Device
,IsLiveBet															-- MarketType
,SelectionsBucket													-- KEY to DW.BucketSelections
,CashoutParticipation												-- KEY to DW.VW_CashoutParticipation
,BonusTypeKey														-- KEY to DW.BonusType
,CASE WHEN numberofselections=1 AND CouponTypeKey=1 THEN BetGroupKey ELSE 0 END
