SELECT
-- DIMENSIONS
reportingdate			
,s.SegmentKey			
,CountryKey
,(CAST(IsMobileBet AS INT)) AS IsMobileBet
,(CAST(IsLiveBet AS INT)) AS IsLiveBet
,NumberOfSelections
,CouponTypeKey
,BSSettledStatus
,BetSelectionTypeKey
,BonusTypeKey
,CashoutParticipation
,s.BetSelectionOdds
,BetSelectionOddsBucketKey
,e.EventName											
,e.EventDeadline
,e.SubCategoryKey
,BetGroupKey
,CustomerClassificationAtBetPlacement

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
INNER JOIN dw.Customer c ON s.customerkey = c.customerkey 
INNER JOIN dw.Event e ON s.eventkey = e.eventkey

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
,CustomerClassificationAtBetPlacement
