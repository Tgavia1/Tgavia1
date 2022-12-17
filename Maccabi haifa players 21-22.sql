  CREATE DATABASE MHFC
  GO
  
  USE MHFC;
  GO

  CREATE TABLE  MACCABI_HAIFA_PLAYERS_2021
	(
	[Player Number] TINYINT PRIMARY KEY,
	[First name] NVARCHAR(20),
	[Last name] NVARCHAR(20),
	[National] NVARCHAR(20),
	[Market Value] MONEY,
	Age	TINYINT,
	Position NVARCHAR(20),
	[Strong foot] NVARCHAR(20),
	[Match played] SMALLINT,
	[Minutes Played] INT,
	Goals TINYINT,
	Asists TINYINT,
	[Yellow cards] TINYINT,
	[Red cards] TINYINT
	);

  INSERT INTO MACCABI_HAIFA_PLAYERS_2021

  VALUES
    (44, 'Josh',  'Cohen',     'USA' ,    660000,  29, 'GK','Right',   33,  3259,  0,0,1,0),
	(2,  'Ryan',  'Strain',  'Australia', 330000,  24, 'RB', 'Right',  9,   451,   0, 0, 1,0),
	(3,  'Sean',  'Goldberg', 'Israel' ,  440000,  26, 'CB' ,'Left',   30,  2436,  0,1,6,0),
	(4,  'Ali',   'Mohamed',  'Nigeria',  1540000, 25, 'CDM','Right',  35,  2519,  0,3,7,0),
	(5,  'Bogdan', 'Planic',  'Serbia',   770000,  30, 'CB', 'Right',  32,  3019,  0,1,6,0),
	(6,  'Neta',  'Lavi',     'Israel',   1540000,  25, 'CDM','Right', 19,  913,   0,1,2,0),
	(7,  'Omer',  'Atzili',   'Israel',   1650000, 28, 'RF', 'Left',   33,  2867,  20,10,3,1),
	(8,  'Dolev', 'Haziza',   'Israel',   1320000, 26 ,'LF', 'Right',  30,  2606,  9,6,12,0),
	(9,  'Ben',   'Sahar',     'Israel',   275000, 31, 'CF', 'Right',  20,  408,   1, 1,0,0),
	(10, 'Charon','Cherry', 'Netherlands', 440000, 33, 'CAM','Left',   33,  2754,  9,7,3,0),
	(11, 'Godsway','Donyoh',   'Ghana',    440000,  27, 'CF', 'Left',  26,  1131,  5,4,2,0),
	(12, 'Sun',    'Menahem',  'Israel',   440000,  27, 'LB', 'Left',  30,  1994,  2,1,5,0),
	(13, 'Mavis',  'Tchibota', 'Congo',   1100000,  26, 'LF', 'Right' ,13,  552,   2,0,0,0),
	(14, 'Jose',  'Rodriguez', 'Spain',   1100000,  27, 'CM', 'Right', 27,  2012,  0,3,3,0),
	(15, 'Ofri',   'Arad',     'Israel',  660000,   23, 'CB', 'Right', 21,  1063,  1,0,2,1),
	(16, 'Mohammed','Abu Fani','Israel',  1100000 , 24, 'CM', 'Right', 26,  1939,  3,4,7,2),
	(17, 'Taleb',   'Tawatha', 'Israel',   275000 , 30, 'LB', 'Left',  3,   95,0,  0,0,0),
	(21, 'Dean',    'David',   'Israel',  1210000 , 26, 'CF', 'Right', 34,  2494,  15,5,4,0), 
	(23, 'Mickael', 'Alphonse','France',  330000  , 32, 'RB', 'Right', 15,  1226,  0,0,3,0),
	(24, 'Ori',     'Dahan',   'Israel',  550000  , 22, 'CB', 'Right', 3,   137,   0,0,0,0),
	(25, 'Raz',     'Meir',    'Israel',  440000  , 25, 'CB', 'Right', 19,  1512,  0,2,4,1), 
	(26, 'Mahmoud', 'Jaber',   'Israel',  330000  , 22, 'CM', 'Right', 22,  959,   3,6,1,0),
	(33, 'Maor',   'Levi',     'Israel',  165000  , 22, 'CAM','Left',  14,  380,   3,0,0,0),
	(52, 'Itamar', 'Israeli',  'Israel',  165000  , 30, 'GK', 'Right', 0,   0,     0,0,0,0),
	(55, 'Rami',   'Gershon',  'Israel',  165000  , 33, 'CB', 'Left',  11,  258,   0,0,3,0),
	(77, 'Roee',   'Fucs',     'Israel',   55000  , 23, 'GK', 'Right', 1,   39,    0,0,0,0),
	(90, 'Roi',    'Mishpati', 'Israel',  220000  , 29, 'GK', 'Right', 2,   153,   0,0,1,0);

   ----MACCABI HAIFA PLAYERS statistics from season 2021-2022 
   
   ----(on field) POSITION Column explain -
   ----(R= Right, L = Left, C = Center B = Back, GK = Goalkeaper, A = Attacking,
   ----D = Defending, M = Midfielder, F = Forword) 


	----All details players names, national, market values, age, position, strong foot, match played,
	----minutes played, goals, asists, Yellow cards, red cards. order by TOP goals scorer.
	
		SELECT * 
		FROM 
			MACCABI_HAIFA_PLAYERS_2021
		order by
			Goals desc;
	
	---- Count players by position
	
		SELECT Position, count (*) as Players 
		FROM 
			MACCABI_HAIFA_PLAYERS_2021
		GROUP BY
			Position
		
	
	----players names that played 1 game at least, national,  match played, average minute per game this season.
	----players at the top are usefull in the team.
	
		SELECT 
			[First name], [Last name],[Position], [National], [Match played],
			[Minutes Played]/[Match played] AS [avg time per match]
		FROM
			MACCABI_HAIFA_PLAYERS_2021
		WHERE
			[Match played] > 0 and [Minutes Played] > 0
		ORDER BY
			[avg time per match] desc;
		
	
	---- players names, position, age, market value + '$' , Match played, Minutes Played,
	---- Goals Creation is the Offensive effect include goals and asist together.
	---- order by average minutes per goal (min 1 goal or 1 asist). 
		 
		SELECT
			[First name], [Last name], Position,age,
			CONCAT('$',(FORMAT([Market Value], '#,###,###'))) AS Market_value,
			[Match played],
			[Minutes Played],
			Goals + Asists AS 'Goals Creation',
			[Minutes Played]/ (Goals + Asists) AS 'Minute_Per_Goal_creation'
		FROM 
			MACCABI_HAIFA_PLAYERS_2021
		WHERE
			(Goals + Asists) > 0
		order by 
			Minute_Per_Goal_creation;
	
	
	--- same, but oposite order and without CENTER BACK Player - (first players are not efective enough)
		SELECT 
			[First name], [Last name], Position, age,
			CONCAT('$',(FORMAT([Market Value], '#,###,###'))) AS
			Market_value, [Minutes Played], Goals + Asists AS 'Goals Creation',
			[Minutes Played]/ (Goals + Asists) AS 'Minute_Per_Goal'
		FROM
			MACCABI_HAIFA_PLAYERS_2021
		WHERE
			(Goals + Asists) > 0 and position not like 'cb' 
		ORDER BY
			Minute_Per_Goal desc;
	
	----Total cards (reds and yellows) and avg minute per card. low avg minute ---> less good
	
		SELECT 
			[First name], [Last name], Position,
			[Minutes Played],([Red cards] + [Yellow cards]) as 'Total cards',
			[Minutes Played]/ ([Red cards] + [Yellow cards]) AS 'Minute_Per_card'
		FROM
			MACCABI_HAIFA_PLAYERS_2021
		WHERE
			[Red cards] + [Yellow cards] > 0
		ORDER BY
			Minute_Per_card;
	
	----players by current market value ordering.
	
		SELECT [First name], [Last name], Position, age,
			CONCAT('$',(FORMAT([Market Value], '#,###,###'))) AS [Market_value] 
		FROM
			MACCABI_HAIFA_PLAYERS_2021
		ORDER BY 
			[Market Value] desc;
	
	
	---- player goal creation Performence and market value big then $1,000,000
	
			SELECT
			[First name], [Last name], Position,age,
			CONCAT('$',(FORMAT([Market Value], '#,###,###'))) AS Market_value,
			[Minutes Played], Goals + Asists AS 'Goals Creation',
			[Minutes Played]/ (Goals + Asists) AS 'Minute_Per_Goal'
		FROM 
			MACCABI_HAIFA_PLAYERS_2021
		WHERE
			(Goals + Asists) > 0 and [Market Value] > 1000000
		order by 
			Minute_Per_Goal;
	
	
	---- all players, minutes played- youngest first
	
		SELECT 
			[First name], Position,
			CONCAT('$',(FORMAT([Market Value], '#,###,###'))) AS
			[Market value], age, [Minutes Played]
		FROM
			MACCABI_HAIFA_PLAYERS_2021
		ORDER BY
			Age;
	
	---- young players under age 25 and less then $600,000, market value, order by minutes played
	
		SELECT 
			[First name],[Last name] Position,
			CONCAT('$',(FORMAT([Market Value], '#,###,###'))) AS
			Market_value, age, [Minutes Played]
		FROM
			MACCABI_HAIFA_PLAYERS_2021
		WHERE
			age <25 and [Market Value] < 600000
		ORDER BY 
			[Minutes Played] DESC;
	
	---- all players that are not from israel, order by Market Value. 
	
		SELECT 
			[First name],[Last name], [National], Position,
			CONCAT('$',(FORMAT([Market Value], '#,###,###'))) AS
			Market_value, age, [Minutes Played], Goals,Asists
		FROM
			MACCABI_HAIFA_PLAYERS_2021
		WHERE
			[National] not in ('israel')
		order by
			[Market Value] desc;
	
	---- strong foot preformence by Midfielder 
	
		SELECT
			[Strong foot],
			sum([Minutes Played]) as 'Minutes', 
			count([strong foot]) as 'Number of players',
			sum(Goals + Asists) as 'Total goal creation'
		FROM 
			MACCABI_HAIFA_PLAYERS_2021
			where Position like '%m%'
		group by
			[Strong foot];
	
	---- forwords preformence by strong foot 
	
		SELECT
			[Strong foot],
			sum([Minutes Played]) as 'Minutes',
			count([strong foot]) as 'Number of player',
			sum(Goals + Asists) as 'Total goal creation'
		FROM 
			MACCABI_HAIFA_PLAYERS_2021
			where Position like '%f%'
		group by
			[Strong foot];
	