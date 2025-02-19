SELECT
reportingdate
,SegmentKey
,CustomerKey
,BetKey
,CouponID
,IsMobileBet
,IsLiveBet
,NumberOfSelections
,BetStakeEURBucketKey
,CouponType=CASE WHEN ((CAST(SUM(BetSelectionTypeKey) AS float)/MAX(SelectionsBucket))/MAX(NumberOfSelections))<1 THEN 3 ELSE (CAST(SUM(BetSelectionTypeKey) AS float)/MAX(SelectionsBucket))/MAX(NumberOfSelections) END
,SUM(BSStandardSettledStake) AS StandardSettledStake
,SUM(BSProfit) AS GameWin
,SUM(BSRewardPayout) AS RewardPayout

FROM MARTCUBE.BetSelectionFlat

WHERE 
betsettledstatus in (3,4,6,7)
AND AccountTypeKey=1
AND NOT SelectionsBucket=0

GROUP BY
reportingdate
,SegmentKey
,CustomerKey
,CouponID
,BetKey
,IsMobileBet
,IsLiveBet
,NumberOfSelections
,BetStakeEURBucketKey

HAVING MAX(BetSelectionTypeKey)>1
