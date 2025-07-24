SELECT
reportingdate
,CustomerKey
,SegmentKey
,CountryKey
,IsMobileBet
,IsLiveBet
,NumberOfSelections
,CouponTypeKey
,BetSettledStatus
,BetSelectionTypeKey
,BonusTypeKey
,CashoutParticipation
,BetStakeEURBucketKey
,SelectionsBucket
,BetGroupKey
,CustomerClassificationAtBetPlacement
,Odds
,COUNT(DISTINCT CouponID) as Coupons
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
,MAX(CAST(IsMobileBet AS INT)) AS IsMobileBet
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
,CustomerClassificationAtBetPlacement
-- KEY to DW.CustomerAccountClassification
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

FROM MARTCUBE.BetSelectionFlat b
INNER JOIN dw.Customer c ON b.customerkey = c.customerkey  

WHERE 
betsettledstatus IN (3, 4, 5, 6, 7)
AND b.AccountTypeKey = 1
AND CouponTypeKey=1

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
CustomerClassificationAtBetPlacement,
CASE WHEN numberofselections = 1 AND CouponTypeKey = 1 THEN BetGroupKey ELSE 0 END
) standardcoupons

GROUP BY
reportingdate
,CustomerKey
,SegmentKey
,CountryKey
,IsMobileBet
,IsLiveBet
,NumberOfSelections
,CouponTypeKey
,BetSettledStatus
,BetSelectionTypeKey
,BonusTypeKey
,CashoutParticipation
,BetStakeEURBucketKey
,SelectionsBucket
,BetGroupKey
,CustomerClassificationAtBetPlacement
,Odds

UNION ALL

SELECT
reportingdate
,CustomerKey
,SegmentKey
,CountryKey
,IsMobileBet
,IsLiveBet
,NumberOfSelections
,CouponTypeKey
,BetSettledStatus
,BetSelectionTypeKey
,BonusTypeKey
,CashoutParticipation
,BetStakeEURBucketKey
,SelectionsBucket
,BetGroupKey
,CustomerClassificationAtBetPlacement
,Odds
,COUNT(DISTINCT CouponID) as Coupons
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
,MAX(CAST(IsMobileBet AS INT)) AS IsMobileBet
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
,CustomerClassificationAtBetPlacement
-- KEY to DW.CustomerAccountClassification
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

FROM MARTCUBE.BetSelectionFlat b
INNER JOIN dw.Customer c ON b.customerkey = c.customerkey  

WHERE 
betsettledstatus IN (3, 4, 5, 6, 7)
AND b.AccountTypeKey = 1
AND CouponTypeKey<>1

GROUP BY
reportingdate,
CountryKey,
b.CustomerKey,
b.SegmentKey,
b.CouponID,
IsMobileBet,
CustomerClassificationAtBetPlacement
) systemcoupons

GROUP BY
reportingdate
,CustomerKey
,SegmentKey
,CountryKey
,IsMobileBet
,IsLiveBet
,NumberOfSelections
,CouponTypeKey
,BetSettledStatus
,BetSelectionTypeKey
,BonusTypeKey
,CashoutParticipation
,BetStakeEURBucketKey
,SelectionsBucket
,BetGroupKey
,CustomerClassificationAtBetPlacement
,Odds
