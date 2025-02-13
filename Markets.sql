SELECT

--DIMENSIONS
reportingdate														-- Date
,s.SegmentKey														-- KEY to DW.Segment
,c.CountryKey														-- Country
,IsMobileBet														-- Device
,IsLiveBet															-- MarketType
,NumberOfSelections													-- BetType, 1=single 2=combi
,s.BetSelectionOdds													-- Odds
,s.BSSettledStatus													-- KEY to DW.SettledStatus
,s.BetSelectionOddsBucketKey										-- KEY to DW.BucketBetSelectionOdds
,CouponTypeKey														-- KEY to DW.CouponType
,s.EventKey															-- KEY to DW.Event
,BetSelectionTypeKey												-- KEY to DW.BetSelectionType
,BonusTypeKey														-- KEY to DW.BonusType
,BetGroupKey														-- KEY to DW.BetGroup
,s.CustomerClassificationAtBetPlacement								-- KEY to DW.CustomerAccountClassification

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

WHERE 
betsettledstatus IN (3, 4, 5, 6, 7)
AND s.AccountTypeKey = 1
AND ReportingDate='2025-01-01'

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
,s.EventKey															-- KEY to DW.Event
,s.CustomerClassificationAtBetPlacement								-- KEY to DW.CustomerAccountClassification
,BetSelectionTypeKey												-- KEY to DW.BetSelectionType
,BonusTypeKey														-- KEY to DW.BonusType
