USE [QSM];
GO

-- create schema [SIP];

/*
create table [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0]
(
	AreaCdPrefix	varchar(10)		NOT NULL,
	interstateRate	money			NOT NULL,
	intrastateRate	money			NOT NULL
);


create table [SIP].[Rates_Compare_2015_04_Apr_01]
(
	AreaCdPrefix					varchar(10)		NOT NULL UNIQUE CLUSTERED,
	interstateRate_Alcazarnet		money			NULL,
	intrastateRate_Alcazarnet		money			NULL,
	interstateRate_Advance			money			NULL,
	intrastateRate_Advance			money			NULL,
	interstateRate_Diff				money			NULL,
	intrastateRate_Diff				money			NULL
);

INSERT [SIP].[Rates_Compare_2015_04_Apr_01] (AreaCdPrefix, interstateRate_Alcazarnet, intrastateRate_Alcazarnet)
SELECT AreaCdPrefix, interstateRate, intrastateRate
FROM [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0]

INSERT [SIP].[Rates_Compare_2015_04_Apr_01] (AreaCdPrefix)
SELECT AreaCdPrefix
FROM [SIP].[Rates_Advance_2015_03_Mar_26_Step0]
WHERE AreaCdPrefix NOT IN (SELECT AreaCdPrefix FROM [SIP].[Rates_Compare_2015_04_Apr_01]);

UPDATE [SIP].[Rates_Compare_2015_04_Apr_01]
	SET interstateRate_Advance = x.interstateRate,
		intrastateRate_Advance = x.intrastateRate
FROM [SIP].[Rates_Compare_2015_04_Apr_01] t, [SIP].[Rates_Advance_2015_03_Mar_26_Step0] x
WHERE t.AreaCdPrefix = x.AreaCdPrefix;

UPDATE [SIP].[Rates_Compare_2015_04_Apr_01]
	SET interstateRate_Diff = interstateRate_Alcazarnet - interstateRate_Advance,
		intrastateRate_Diff = intrastateRate_Alcazarnet - intrastateRate_Advance

alter TABLE [SIP].[Rates_Compare_2015_04_Apr_01]
	Add Alcazarnet_interstateRate_Diff_Ratio	float NULL,
		Alcazarnet_intrastateRate_Diff_Ratio	float NULL,
		Advance_interstateRate_Diff_Ratio		float NULL,
		Advance_intrastateRate_Diff_Ratio		float NULL


select top 100 * from [SIP].[Rates_Compare_2015_04_Apr_01]


select Alcazarnet_interstateRate_Diff_Ratio, count(*) Cnt
FROM [SIP].[Rates_Compare_2015_04_Apr_01]
WHERE Alcazarnet_interstateRate_Diff_Ratio IS NOT NULL
GROUP BY Alcazarnet_interstateRate_Diff_Ratio
ORDER BY count(*) desc


select count(*) from [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0]

select count(*) from [SIP].[Rates_Advance_2015_03_Mar_26_Step0]
where AreaCdPrefix NOT in (select AreaCdPrefix FROM [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0])

select count(*) from [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0]
where AreaCdPrefix NOT in (select AreaCdPrefix FROM [SIP].[Rates_Advance_2015_03_Mar_26_Step0])

select Alcazarnet_intrastateRate_Diff_Ratio, count(*) Cnt
FROM [SIP].[Rates_Compare_2015_04_Apr_01]
WHERE Alcazarnet_intrastateRate_Diff_Ratio IS NOT NULL
GROUP BY Alcazarnet_intrastateRate_Diff_Ratio
ORDER BY count(*) desc


select Avg(Alcazarnet_intrastateRate_Diff_Ratio) -- , count(*) Cnt
FROM [SIP].[Rates_Compare_2015_04_Apr_01]
WHERE Alcazarnet_intrastateRate_Diff_Ratio IS NOT NULL
  and Alcazarnet_intrastateRate_Diff_Ratio < 0


select Alcazarnet_intrastateRate_Diff_Ratio, count(*) Cnt
FROM [SIP].[Rates_Compare_2015_04_Apr_01]
WHERE Alcazarnet_intrastateRate_Diff_Ratio IS NOT NULL
--   and Alcazarnet_intrastateRate_Diff_Ratio > 0
GROUP BY Alcazarnet_intrastateRate_Diff_Ratio
ORDER BY count(*) desc


-- create Schema [BizLoan]

drop table [BizLoan].[Y!_Scrape_2015_04_Apr_02]

create table [BizLoan].[Y!_Scrape_2015_04_Apr_02]
(
	BizName			nvarchar(500)		NULL,
	Phone			nvarchar(500)			NULL
)

select len(Phone), count(*)
from [BizLoan].[Y!_Scrape_2015_04_Apr_02]
group by len(Phone)
order by count(*) desc

select top 100 * from [BizLoan].[Y!_Scrape_2015_04_Apr_02]
where len(Phone) <> 14 and Len(Phone) <> 0

delete [BizLoan].[Y!_Scrape_2015_04_Apr_02]
where len(Phone) <> 14


select top 100 Phone, substring(Phone,2,3) + substring(Phone,7,3) + substring(Phone,11,4)
from [BizLoan].[Y!_Scrape_2015_04_Apr_02]
where Phone like '([0-9][0-9][0-9]) [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'

update [BizLoan].[Y!_Scrape_2015_04_Apr_02]
	set Phone = substring(Phone,2,3) + substring(Phone,7,3) + substring(Phone,11,4)

-- alter table [BizLoan].[Y!_Scrape_2015_04_Apr_02] add IsWireless char(1) NULL
update [BizLoan].[Y!_Scrape_2015_04_Apr_02] set IsWireless = 'N'


update [BizLoan].[Y!_Scrape_2015_04_Apr_02] set IsWireless = 'Y'
where substring(Phone,1,7) in (select PhoneBegin from [PrivateReserve].[DNC].[WirelessBlocks])

update [BizLoan].[Y!_Scrape_2015_04_Apr_02] set IsWireless = 'N'
where IsWireless = 'Y'
  and Phone in (select Phone from [PrivateReserve].[DNC].[WirelessToLandline])

select count(*) from [PrivateReserve].[DNC].[WirelessToLandline]

drop table [BizLoan].[Y!_Scrape_2015_04_Apr_02_Wireless]

select * into [BizLoan].[Y!_Scrape_2015_04_Apr_02_Wireless]
from [BizLoan].[Y!_Scrape_2015_04_Apr_02] where IsWireless = 'Y'


select IsWireless, count(*)
from [BizLoan].[Y!_Scrape_2015_04_Apr_02]
group by IsWireless

select count(*) from [BizLoan].[Y!_Scrape_2015_04_Apr_02] where BizName like '%,%'




select BizName, count(*)
from [BizLoan].[Y!_Scrape_2015_04_Apr_02]
group by BizName
having count(*) > 1
order by count(*) desc



select top 100 PhoneBegin from [PrivateReserve].[DNC].[WirelessBlocks]

select top 100 substring(Phone,1,7) from [BizLoan].[Y!_Scrape_2015_04_Apr_02] 
select top 100 substring(Phone,1,7) from [BizLoan].[Y!_Scrape_2015_04_Apr_02] 


s





select count(*) from [BizLoan].[Y!_Scrape_2015_04_Apr_02]




select 




ORDER BY Alcazarnet_interstateRate_Diff_Ratio DESC

UPDATE [SIP].[Rates_Compare_2015_04_Apr_01]
	SET Alcazarnet_interstateRate_Diff_Ratio = ( interstateRate_Diff / interstateRate_Alcazarnet ),
		Alcazarnet_intrastateRate_Diff_Ratio = ( intrastateRate_Diff / intrastateRate_Alcazarnet ),
		Advance_interstateRate_Diff_Ratio = ( interstateRate_Diff / interstateRate_Advance ),
		Advance_intrastateRate_Diff_Ratio = ( intrastateRate_Diff / interstateRate_Advance )



select top 1000 * from [SIP].[Rates_Compare_2015_04_Apr_01]

select interstateRate_Diff, count(*) Cnt
FROM [SIP].[Rates_Compare_2015_04_Apr_01]
where interstateRate_Diff IS NOT NULL
GROUP BY interstateRate_Diff
order by count(*) desc



CREATE UNIQUE CLUSTERED INDEX PK_Alcazarnet_2015_02_Feb_25 ON [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0] (AreaCdPrefix);

alter table [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0] add interstateRateDiff_Advance money NULL, intrastateRateDiff_Advance money;

update [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0]
	set interstateRateDiff_Advance = (z.interstateRate - a.interstateRate),
		intrastateRateDiff_Advance = (z.intrastateRate - a.intrastateRate)
FROM [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0] z, [SIP].[Rates_Advance_2015_03_Mar_26_Step0] a
where z.AreaCdPrefix = a.AreaCdPrefix

select top 1000 * from [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0]

alter table [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0] add interstateRateDiff_Advance money NULL, intrastateRateDiff_Advance money;



create table [SIP].[Rates_Advance_Interstate_2015_03_Mar_26_Step0]
(
	AreaCdPrefix	varchar(10)		NOT NULL,
	interstateRate	money			NOT NULL
);

CREATE UNIQUE CLUSTERED INDEX PK_Adv_Inter1 ON [SIP].[Rates_Advance_Interstate_2015_03_Mar_26_Step0] (AreaCdPrefix);

select top 100 * from [SIP].[Rates_Advance_Intrastate_2015_03_Mar_26_Step0]

create table [SIP].[Rates_Advance_Intrastate_2015_03_Mar_26_Step0]
(
	AreaCdPrefix	varchar(10)		NOT NULL,
	intrastateRate	money			NOT NULL
);

CREATE UNIQUE CLUSTERED INDEX PK_Adv_Intra1 ON [SIP].[Rates_Advance_Intrastate_2015_03_Mar_26_Step0] (AreaCdPrefix);

create table [SIP].[Rates_Advance_2015_03_Mar_26_Step0]
(
	AreaCdPrefix	varchar(10)		NOT NULL,
	interstateRate	money			NOT NULL,
	intrastateRate	money			NOT NULL
);

INSERT [SIP].[Rates_Advance_2015_03_Mar_26_Step0] ( AreaCdPrefix, interstateRate, intrastateRate )
SELECT a.AreaCdPrefix, a.interstateRate, b.intrastateRate
FROM [SIP].[Rates_Advance_Interstate_2015_03_Mar_26_Step0] a, [SIP].[Rates_Advance_Intrastate_2015_03_Mar_26_Step0] b
WHERE a.AreaCdPrefix = b.AreaCdPrefix
;

CREATE UNIQUE CLUSTERED INDEX PK_Advance_2015_03_Mar_26 ON [SIP].[Rates_Advance_2015_03_Mar_26_Step0] (AreaCdPrefix);


select top 100 * from [SIP].[Rates_Advance_2015_03_Mar_26_Step0]




*/




select top 1000 * from [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0]

select len(AreaCdPrefix), count(*)
from [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0]
group by len(AreaCdPrefix)

update [SIP].[Rates_Alcazarnet_2015_02_Feb_25_Step0]
	set AreaCdPrefix = substring(AreaCdPrefix,2,6)
