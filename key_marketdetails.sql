SELECT DISTINCT
    --DIMENSIONS
    b.IsMobileBet,                                               -- Device
    b.IsLiveBet,                                                 -- MarketType
    b.NumberOfSelections,                                        -- BetType, 1=single 2=combi
    b.CouponTypeKey,                                             -- KEY to DW.CouponType
    b.BSSettledStatus,                                           -- KEY to DW.SettledStatus
    b.BetSelectionTypeKey,                                       -- KEY to DW.BetSelectionType
    b.BonusTypeKey,                                              -- KEY to DW.BonusType
    b.CustomerClassificationAtBetPlacement,                      -- KEY to DW.CustomerAccountClassification
    b.BetSelectionOddsBucketKey,                                 -- KEY to DW.BucketBetSelectionOdds

    -- Unique Key (Hash of all above dimensions)
    CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 
        CONCAT(
            b.IsMobileBet, '|', 
            b.IsLiveBet, '|',
            b.NumberOfSelections, '|',
            b.CouponTypeKey, '|',
            b.BSSettledStatus, '|',
            b.BetSelectionTypeKey, '|',
            b.BonusTypeKey, '|',
            b.CustomerClassificationAtBetPlacement, '|',
            b.BetSelectionOddsBucketKey, ''
        )), 2) AS key_marketdetails

FROM MARTCUBE.BetSelectionFlat b WITH (NOLOCK)

WHERE 
    b.betsettledstatus IN (3, 4, 5, 6, 7)
    AND b.AccountTypeKey = 1
    AND b.ReportingDate >= '2025-01-01'
	AND b.ReportingDate < '2025-02-01'
