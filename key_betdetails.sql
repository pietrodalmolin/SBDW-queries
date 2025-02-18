SELECT DISTINCT
    -- Unique Key
    CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 
        CONCAT(
            COALESCE(IsMobileBet, ''), '|', 
            COALESCE(IsLiveBet, ''), '|',
            COALESCE(NumberOfSelections, ''), '|',
            COALESCE(CouponTypeKey, ''), '|',
            COALESCE(BetSettledStatus, ''), '|',
            COALESCE(BetSelectionTypeKey, ''), '|',
            COALESCE(BonusTypeKey, ''), '|',
            COALESCE(CustomerClassificationAtBetPlacement, ''), '|',
            COALESCE(BetStakeEURBucketKey, ''), '|',
            COALESCE(SelectionsBucket, ''), '|',
            COALESCE(CashoutParticipation, ''), '|',
            COALESCE(NumberofPartialCashout, '')
        )), 2) AS key_betdetails,

    -- Dimensions for Power BI
    IsMobileBet,
    IsLiveBet,
    NumberOfSelections,
    CouponTypeKey,
    BetSettledStatus,
    BetSelectionTypeKey,
    BonusTypeKey,
    CustomerClassificationAtBetPlacement,
    BetStakeEURBucketKey,
    SelectionsBucket,
    CashoutParticipation,
    NumberofPartialCashout

FROM MARTCUBE.BetSelectionFlat b WITH (NOLOCK) 

WHERE 
    BetSettledStatus IN (3, 4, 5, 6, 7)
    AND b.AccountTypeKey = 1
    AND reportingdate='2025-01-01'
