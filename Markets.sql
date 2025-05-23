SELECT
--DIMENSIONS
reportingdate														-- Date
,s.SegmentKey
,CountryKey
,CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 
CONCAT(
IsMobileBet, '|', 
IsLiveBet, '|',
NumberOfSelections, '|',
CouponTypeKey, '|',
BSSettledStatus, '|',
BetSelectionTypeKey, '|',
BonusTypeKey, '|',
CashoutParticipation)), 2) 
AS key_betdetails
,s.BetSelectionOdds													-- Odds
,BetSelectionOddsBucketKey
,e.EventName														
,e.EventDeadline
,e.SubCategoryKey
,BetGroupKey														-- KEY to DW.BetGroup

--MEASURES		
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

FROM MARTCUBE.BetSelectionFlat s
INNER JOIN dw.Customer c WITH(NOLOCK) ON s.customerkey = c.customerkey --WITH(NOLOCK)
INNER JOIN dw.Event e WITH(NOLOCK) ON s.eventkey = e.eventkey --WITH(NOLOCK)

WHERE 
betsettledstatus IN (3, 4, 5, 6, 7)
AND s.AccountTypeKey = 1

GROUP BY
reportingdate														-- Date
,s.SegmentKey														-- KEY to DW.Segment
,c.CountryKey														-- Country
,IsMobileBet														-- Device
,IsLiveBet															-- MarketType
,s.BetSelectionOdds													-- Odds
,s.BSSettledStatus													-- KEY to DW.SettledStatus
,s.BetSelectionOddsBucketKey										-- KEY to DW.BucketBetSelectionOdds
,NumberOfSelections													-- BetType, 1=single 2=combi
,CouponTypeKey														-- KEY to DW.CouponType
,BetGroupKey														-- KEY to DW.BetGroup
,BetSelectionTypeKey												-- KEY to DW.BetSelectionType
,BonusTypeKey														-- KEY to DW.BonusType
,CashoutParticipation
,e.EventName														
,e.EventDeadline
,e.SubCategoryKey
