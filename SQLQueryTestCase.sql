USE [FreshGrill]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('dbo.TestCase', 'U') IS NOT NULL 
  DROP TABLE [dbo].[TestCase];
GO

CREATE TABLE [dbo].[TestCase](
	[finished_no] [int] NULL,
	[finished_name] [nchar](100) NULL,
	[ingred_no] [int] NULL,
	[ingred_name] [nchar](100) NULL,
	[quantity_per] [float] NULL,
	[unit] [nchar](10) NULL,
	[scrap_loss] [float] NULL,
	[ending_date] [datetime] NULL
) ON [PRIMARY]
GO

INSERT INTO [FreshGrill].[dbo].[TestCase] (finished_no,         finished_name, ingred_no,          ingred_name, quantity_per,  unit, scrap_loss)
                                   VALUES (          5, 'Tuna salad sandwich',     10001,              'bread',            2,    '',          0),
                                          (          5, 'Tuna salad sandwich',     10002,     'tuna salad mix',            2,  'oz',          5),
                                          (      10001,               'bread',         0,              'bread',            1,    '',          0),
                                          (      10002,      'tuna salad mix',     20001,    'yellow fin tuna',            1,  'oz',          5),
                                          (      10002,      'tuna salad mix',     20002,      'albacore tuna',          0.5,  'oz',          5),
                                          (      10002,      'tuna salad mix',     20003,               'mayo',          0.5,  'oz',          5),
                                          (      20001,     'yellow fin tuna',         0,    'yellow fin tuna',            1,  'oz',          0),
                                          (      20002,       'albacore tuna',         0,      'albacore tuna',            1,  'oz',          0),
                                          (      20003,                'mayo',         0,               'mayo',            1,  'oz',          0);
GO

SELECT * FROM [FreshGrill].[dbo].[TestCase] line
INNER JOIN [FreshGrill].[dbo].[TestCase] ingred
ON ingred.finished_no = line.ingred_no
WHERE line.finished_no=5;
GO

SELECT CASE WHEN ingred.ingred_no=0 THEN line.finished_no ELSE line.ingred_no END AS recipe,
       ingred.ingred_name AS ingred_name,
       line.quantity_per * ingred.quantity_per AS quantity,
       line.unit AS unit,
       (1-(1-ingred.scrap_loss/100)*(1-line.scrap_loss/100))*100 AS scrap_loss,
       (line.quantity_per * ingred.quantity_per) * (1-ingred.scrap_loss/100)*(1-line.scrap_loss/100) AS yield_qty
FROM [FreshGrill].[dbo].[TestCase] line
INNER JOIN [FreshGrill].[dbo].[TestCase] ingred
ON ingred.finished_no = line.ingred_no
WHERE line.finished_no=5;
GO
