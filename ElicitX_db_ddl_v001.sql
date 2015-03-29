USE [ElicitX]
GO

IF OBJECT_ID(N'LeadListPhone') IS NOT NULL
	DROP TABLE LeadListPhone;
GO
IF OBJECT_ID(N'Lead') IS NOT NULL
	DROP TABLE Lead;
GO
IF OBJECT_ID(N'State') IS NOT NULL
	DROP TABLE State;
GO
IF OBJECT_ID(N'PhoneCall') IS NOT NULL
	DROP TABLE PhoneCall;
GO
IF OBJECT_ID(N'Disposition') IS NOT NULL
	DROP TABLE Disposition;
GO
IF OBJECT_ID(N'LeadList') IS NOT NULL
	DROP TABLE LeadList;
GO
IF OBJECT_ID(N'LeadAux') IS NOT NULL
	DROP TABLE LeadAux;
GO
IF OBJECT_ID(N'LeadSrc') IS NOT NULL
	DROP TABLE LeadSrc;
GO
IF OBJECT_ID(N'LeadSrcType') IS NOT NULL
	DROP TABLE LeadSrcType;
GO
IF OBJECT_ID(N'Usr') IS NOT NULL
	DROP TABLE Usr;
GO
IF OBJECT_ID(N'UsrType') IS NOT NULL
	DROP TABLE UsrType;
GO
IF OBJECT_ID(N'Usr') IS NOT NULL
	DROP TABLE Usr;
GO
IF OBJECT_ID(N'Disposition') IS NOT NULL
	DROP TABLE Disposition;
GO
IF OBJECT_ID(N'PhoneCall') IS NOT NULL
	DROP TABLE PhoneCall;
GO
IF TYPE_ID(N'Phone') IS NOT NULL
	DROP TYPE Phone;
GO
IF OBJECT_ID(N'CampaignAudio') IS NOT NULL
	DROP TABLE CampaignAudio;
GO
IF OBJECT_ID(N'Audio') IS NOT NULL
	DROP TABLE Audio;
GO
IF OBJECT_ID(N'Campaign') IS NOT NULL
	DROP TABLE Campaign;
GO
IF OBJECT_ID(N'DialRate') IS NOT NULL
	DROP TABLE DialRate;
GO

IF EXISTS (SELECT * FROM sysobjects where name = 'Phone' and type = 'R')
	DROP RULE Phone;
GO

CREATE RULE Phone AS @Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]';
GO

IF TYPE_ID(N'Phone') IS NULL
	CREATE TYPE Phone FROM char(10) NOT NULL;
GO

sp_bindrule 'Phone', 'Phone';

IF TYPE_ID(N'ListStatus') IS NOT NULL
	DROP TYPE ListStatus;

IF TYPE_ID(N'YesNo') IS NOT NULL
	DROP TYPE YesNo;


IF EXISTS (SELECT * FROM sysobjects where name = 'YesNoDefault' and type = 'D')
	DROP DEFAULT YesNoDefault;
GO
CREATE DEFAULT YesNoDefault AS 'N';
GO

IF EXISTS (SELECT * FROM sysobjects where name = 'YesNoDomain' and type = 'R')
	DROP RULE YesNoDomain;
GO

CREATE RULE YesNoDomain AS @Val in ('N', 'Y');
GO


IF TYPE_ID(N'YesNo') IS NULL
	CREATE TYPE YesNo FROM char(1) NOT NULL;
GO

sp_bindrule 'YesNoDomain', 'YesNo';
GO

sp_bindefault 'YesNoDefault', 'YesNo';
GO

IF EXISTS (SELECT * FROM sysobjects where name = 'ListStatusDomain' and type = 'R')
	DROP RULE ListStatusDomain;
GO

CREATE RULE ListStatusDomain AS @Status in ('Loaded', 'Active', 'Inactive', 'Deleted');
GO

IF TYPE_ID(N'ListStatus') IS NULL
	CREATE TYPE ListStatus FROM varchar(10) NOT NULL;
GO

sp_bindrule 'ListStatusDomain', 'ListStatus';

---------------------------------------------------------------------------
-- Create the tables
---------------------------------------------------------------------------
CREATE TABLE [State]
(
	State			char(2)		NOT NULL UNIQUE,
	StateName		varchar(30)	NOT NULL
);

INSERT [State] (State, StateName)
SELECT 'AL','Alabama' UNION
SELECT 'AK','Alaska' UNION
SELECT 'AZ','Arizona' UNION
SELECT 'AR','Arkansas' UNION
SELECT 'CA','California' UNION
SELECT 'CO','Colorado' UNION
SELECT 'CT','Connecticut' UNION
SELECT 'DE','Delaware' UNION
SELECT 'FL','Florida' UNION
SELECT 'GA','Georgia' UNION
SELECT 'HI','Hawaii' UNION
SELECT 'ID','Idaho' UNION
SELECT 'IL','Illinois' UNION
SELECT 'IN','Indiana' UNION
SELECT 'IA','Iowa' UNION
SELECT 'KS','Kansas' UNION
SELECT 'KY','Kentucky' UNION
SELECT 'LA','Louisiana' UNION
SELECT 'ME','Maine' UNION
SELECT 'MD','Maryland' UNION
SELECT 'MA','Massachusetts' UNION
SELECT 'MI','Michigan' UNION
SELECT 'MN','Minnesota' UNION
SELECT 'MS','Mississippi' UNION
SELECT 'MO','Missouri' UNION
SELECT 'MT','Montana' UNION
SELECT 'NE','Nebraska' UNION
SELECT 'NV','Nevada' UNION
SELECT 'NH','New Hampshire' UNION
SELECT 'NJ','New Jersey' UNION
SELECT 'NM','New Mexico' UNION
SELECT 'NY','New York' UNION
SELECT 'NC','North Carolina' UNION
SELECT 'ND','North Dakota' UNION
SELECT 'OH','Ohio' UNION
SELECT 'OK','Oklahoma' UNION
SELECT 'OR','Oregon' UNION
SELECT 'PA','Pennsylvania' UNION
SELECT 'RI','Rhode Island' UNION
SELECT 'SC','South Carolina' UNION
SELECT 'SD','South Dakota' UNION
SELECT 'TN','Tennessee' UNION
SELECT 'TX','Texas' UNION
SELECT 'UT','Utah' UNION
SELECT 'VT','Vermont' UNION
SELECT 'VA','Virginia' UNION
SELECT 'WA','Washington' UNION
SELECT 'WV','West Virginia' UNION
SELECT 'WI','Wisconsin' UNION
SELECT 'WY','Wyoming' UNION
SELECT 'DC','Washington DC' UNION
SELECT 'PR','Puerto Rico' UNION
SELECT 'VI','U.S. Virgin Islands' UNION
SELECT 'AS','American Samoa' UNION
SELECT 'GU','Guam' UNION
SELECT 'MP','Northern Mariana Islands'
;

CREATE TABLE [UsrType]
(
	UsrType			varchar(10)		NOT NULL
PRIMARY KEY (UsrType),
);

INSERT [UsrType] (UsrType)
SELECT 'Admin' UNION
SELECT 'Agent' UNION
SELECT 'Affiliate';

CREATE TABLE [Usr]
(
	UsrId			int				NOT NULL IDENTITY (1,1),
	UsrType			varchar(10)		NOT NULL,
	UsrLogin		varchar(10)		NOT NULL UNIQUE,
	UsrPasswd		varchar(10)		NOT NULL,
PRIMARY KEY (UsrId),
FOREIGN KEY (UsrType) REFERENCES [UsrType](UsrType)
);

INSERT [Usr] (UsrType, UsrLogin, UsrPasswd)
SELECT 'Admin', 'PJ', '444' UNION
SELECT 'Agent', 'Chainz', '555' UNION
SELECT 'Agent', 'Wayne', 'Bruce' UNION
SELECT 'Agent', 'Burke', 'DG' UNION
SELECT 'Affiliate', 'M3rk', '333';

----------------------------------------------------------------
--
----------------------------------------------------------------
CREATE TABLE [LeadSrcType]
(
	LeadSrcType		varchar(10)		NOT NULL UNIQUE
);

INSERT [LeadSrcType] (LeadSrcType)
SELECT 'Agent' UNION				-- auto generated/addd lists created by each user
SELECT 'List' UNION
SELECT 'Affiliate';

----------------------------------------------------------------
--
----------------------------------------------------------------
CREATE TABLE [LeadSrc]
(
	LeadSrcSNum		int				NOT NULL IDENTITY (1,1),
	LeadSrcType		varchar(10)		NOT NULL,
	LeadSrc			varchar(30)		NOT NULL UNIQUE,
	UsrId_Load		int				NOT NULL,
	UsrId_Affiliate	int				NULL
PRIMARY KEY (LeadSrcSNum),
FOREIGN KEY (LeadSrcType) REFERENCES [LeadSrcType](LeadSrcType),
FOREIGN KEY (UsrId_Load) REFERENCES [Usr](UsrId),
FOREIGN KEY (UsrId_Affiliate) REFERENCES [Usr](UsrId)
);

DECLARE @AdminUsrId int = (SELECT UsrId FROM [Usr] WHERE UsrLogin = 'PJ');
DECLARE @AffiliateUsrId int = (SELECT UsrId FROM [Usr] WHERE UsrLogin = 'M3rk');

INSERT [LeadSrc] (LeadSrcType, LeadSrc, UsrId_Load, UsrId_Affiliate)
SELECT 'List', 'Axiom', @AdminUsrId, NULL UNION
SELECT 'List', 'DataVault USA', @AdminUsrId, NULL UNION
SELECT 'Affiliate', 'M3rk', @AdminUsrId, @AffiliateUsrId


-- select * from [LeadSrc]

--------------------------------------------------------------------
--
--------------------------------------------------------------------
CREATE TABLE [Audio]
(
	AudioId			int						NOT NULL IDENTITY (1,1),
	Audio			[varbinary](MAX)		NOT NULL,
PRIMARY KEY (AudioId)
)


--------------------------------------------------------------------
--
--------------------------------------------------------------------
CREATE TABLE [DialRate]
(
	DialRateSNum	tinyint			NOT NULL,
	DialRate		varchar(20)		NOT NULL
PRIMARY KEY (DialRateSNum)
);
CREATE UNIQUE INDEX FK_DialRate ON [DialRate](DialRate);

INSERT [DialRate] (DialRateSNum, DialRate)
SELECT 0, 'Broadcast' UNION
SELECT 1, 'Dynamic Scheduled' UNION
SELECT 2, 'Dynamic Agent';

--------------------------------------------------------------------
--
--------------------------------------------------------------------
CREATE TABLE [Campaign]
(
	CampaignId		int				NOT NULL	IDENTITY (1,1),
	CampaignName	varchar(50)		NOT NULL	UNIQUE,
	DialRateSNum	tinyint			NOT NULL,
	AudioId			int				NULL
-- 	List
PRIMARY KEY (CampaignId)
FOREIGN KEY (DialRateSNum) REFERENCES [DialRate](DialRateSNum),
FOREIGN KEY (AudioId) REFERENCES [Audio](AudioId)
);
CREATE UNIQUE INDEX UK_CampaignName ON [Campaign] (CampaignName);

INSERT [Campaign] (CampaignName, DialRateSNum)
SELECT 'Broadcast Loan 1 - Chinese Restaurants', 0 UNION
SELECT 'Broadcast Loan 2 - Chinese Restaurants', 0
;

--------------------------------------------------------------------
--  An audio file can be assigned/applied to more than one campaign
--------------------------------------------------------------------
CREATE TABLE [CampaignAudio]
(
	CampaignId		int				NOT NULL,
	AudioId			int				NOT NULL
FOREIGN KEY (CampaignId) REFERENCES [Campaign](CampaignId),
FOREIGN KEY (AudioId) REFERENCES [Audio](AudioId)
);
CREATE UNIQUE INDEX PK_CampaignAudio ON [CampaignAudio](CampaignId, AudioId);


-----------------------------------------------------------------------
-- Status: Loaded, Active, Inactive, Deleted
-----------------------------------------------------------------------
CREATE TABLE [LeadList]
(
	LeadListSNum	int				NOT NULL IDENTITY (1,1),
	LeadListName	varchar(50)		NOT NULL,
	LeadSrcSNum		int				NOT NULL,
	SrcLeadListSNum	int				NULL,					-- where the list came from if recycled or cloned
	ListType		varchar(20)		NULL,					-- recycled, cloned, 
	ListCreateDt	smalldatetime	NOT NULL,
	Status			ListStatus		NOT NULL,
	CampaignId		int				NULL
PRIMARY KEY (LeadListSNum),
FOREIGN KEY (LeadSrcSNum) REFERENCES [LeadSrc](LeadSrcSNum),
FOREIGN KEY (SrcLeadListSNum) REFERENCES [LeadList](LeadListSNum),
FOREIGN KEY (CampaignId) REFERENCES [Campaign](CampaignId)
);
CREATE UNIQUE INDEX UK_LeadList ON [LeadList] (LeadListName);

DECLARE @AxiomLeadSrcSNum int = (SELECT LeadSrcSNum FROM [LeadSrc] WHERE LeadSrcType = 'List' AND LeadSrc = 'Axiom');

INSERT [LeadList] (LeadListName, LeadSrcSNum, SrcLeadListSNum, ListType, ListCreateDt, Status)
SELECT 'Chinese Restaurants', @AxiomLeadSrcSNum, NULL, 'New', getdate(), 'Loaded'


----------------------------------------------------------------
--
----------------------------------------------------------------
CREATE TABLE [Lead]
(
	Phone			Phone			NOT NULL,
	FirmName		varchar(30)		NULL,
	FName			varchar(20)		NULL,
	LName			varchar(30)		NULL,
	Address			varchar(50)		NULL,
	Address2		varchar(50)		NULL,
	City			varchar(30)		NULL,
	State			char(2)			NULL,
	Zip				varchar(10)		NULL,
	DNC				YesNo			NOT NULL
PRIMARY KEY (Phone),
FOREIGN KEY (State) REFERENCES [State](State),
);

-- insert 

/*
CREATE TABLE [LeadAux]
(
	Phone			Phone			NOT NULL,
	FieldName		varchar(20)		NON
);
*/

CREATE TABLE [Disposition]
(
	DispId			tinyint			NOT NULL IDENTITY(1,1),
	Disposition		varchar(30)		NOT NULL
PRIMARY KEY (DispId)
);
CREATE UNIQUE INDEX UK_Disposition ON [Disposition] (Disposition);

INSERT [Disposition] (Disposition)
SELECT 'Do Not Call' UNION
SELECT 'Spanish Only' UNION
SELECT 'Wrong Number'

----------------------------------------------------------------
--  These are the lists of phone numbers tied to each list
----------------------------------------------------------------
CREATE TABLE [LeadListPhone]
(
	LeadListSNum	int				NOT NULL,
	Phone			Phone			NOT NULL,
FOREIGN KEY (LeadListSNum) REFERENCES [LeadList](LeadListSNum),
FOREIGN KEY (Phone) REFERENCES [Lead](Phone),

);
CREATE UNIQUE INDEX PK_LeadListPhone ON [LeadListPhone] (LeadListSNum, Phone);


--------------------------------------------------------------------
--
--------------------------------------------------------------------
CREATE TABLE [PhoneCall]
(
	Phone			Phone			NOT NULL,
	UsrId			int				NOT NULL,
	CallDt			datetime		NULL,
	EndDt			datetime		NULL,
	DispId			tinyint			NULL,
FOREIGN KEY (Phone) REFERENCES [Lead](Phone),
FOREIGN KEY (UsrId) REFERENCES [Usr](UsrId),
FOREIGN KEY (DispId) REFERENCES [Disposition](DispId)
)
CREATE UNIQUE INDEX PK_PhoneCall ON [PhoneCall] (Phone, CallDt);

