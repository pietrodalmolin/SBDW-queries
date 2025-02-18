SELECT 
CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 
CONCAT(
IsMobileBet, '|', 
IsLiveBet, '|',
NumberOfSelections, '|',
CouponTypeKey, '|',
SettledStatusKey, '|',
BetSelectionTypeKey, '|',
BonusTypeKey, '|',
CashoutParticipationKey
)
), 2) AS key_betdetails,
IsMobileBet,
IsLiveBet,
NumberOfSelections,
CouponTypeKey,
SettledStatusKey,
BetSelectionTypeKey,
BonusTypeKey,
CashoutParticipationKey
FROM 
(SELECT 0 AS IsMobileBet UNION ALL SELECT 1) AS IsMobileBet
CROSS JOIN 
(SELECT 0 AS IsLiveBet UNION ALL SELECT 1) AS IsLiveBet
CROSS JOIN 
(SELECT 1 AS NumberOfSelections UNION ALL SELECT 2) AS NumberOfSelections
CROSS JOIN 
(SELECT DISTINCT CouponTypeKey FROM DW.CouponType) AS CouponTypeKey
CROSS JOIN 
(SELECT DISTINCT SettledStatusKey FROM DW.SettledStatus WHERE SettledStatusKey IN (3, 4, 5, 6, 7)) AS SettledStatusKey
CROSS JOIN 
(SELECT DISTINCT BetSelectionTypeKey FROM DW.BetSelectionType) AS BetSelectionTypeKey
CROSS JOIN 
(SELECT DISTINCT BonusTypeKey FROM DW.BonusType) AS BonusTypeKey
CROSS JOIN 
(SELECT DISTINCT CashoutParticipationKey FROM DW.VW_CashoutParticipation) AS CashoutParticipationKey
