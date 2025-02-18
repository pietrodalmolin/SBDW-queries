SELECT 
CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 
CONCAT(
BetStakeEURBucketKey, '|', 
SelectionsBucket)), 2) 
AS key_betbucket,
BetStakeEURBucketKey,
SelectionsBucket
FROM 
(SELECT DISTINCT BucketKey AS BetStakeEURBucketKey FROM DW.BucketBetStake) AS BetStakeEURBucketKey
CROSS JOIN 
(SELECT DISTINCT BucketKey AS SelectionsBucket FROM DW.BucketSelections) AS SelectionsBucket
