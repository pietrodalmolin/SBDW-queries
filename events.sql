SELECT 
m.eventkey
,e.eventdeadline
,e.eventname
,e.SubCategoryKey
,MAX(m.DWCreatedDate) as lastmodified
,m.betgroupkey
,m.MarketTypeKey


FROM SBDW.DW.Market m
LEFT JOIN dw.event e on m.eventkey=e.EventKey
where m.DWCreatedDate>='2025-03-09'

GROUP BY 
m.eventkey
,m.betgroupkey
,m.MarketTypeKey
,e.eventname
,e.SubCategoryKey
,e.eventdeadline
