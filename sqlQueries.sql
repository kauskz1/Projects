--TABLES
DROP TABLE if exists Teams;
DROP TABLE if exists Players;
DROP TABLE if exists Goals;
DROP TABLE if exists Matches;
DROP TABLE if exists Standings;

CREATE TABLE Teams(
    TID numeric(2) PRIMARY KEY,
    Team_Name varchar(30) UNIQUE,
    Captain_Name varchar(30) NOT NULL,
    Standing numeric(2) UNIQUE,
    check(Standing>0)
);

CREATE TABLE Players(
    PID numeric(3) PRIMARY KEY,
    `Name` varchar(30),
    Team_Name varchar(30) references Teams(Team_Name),
    Position varchar(10),
    Goals numeric(4),
    Age numeric(3),
    check(Age>0 && Age<120),
    check(position in ('GK','Defender','Midfielder','Striker'))
);

CREATE TABLE Goals(
    Match_ID numeric(3) references Matches(Match_ID),
    PID numeric(3) references Players(PID),
    Player_Name varchar(30) references Players(`Name`),
    `For` varchar(30) references Teams(Team_Name),
    Against varchar(30) references Teams(Team_Name),
    Assisted varchar(30) references Players(Player_Name),
    IsPenalty boolean DEFAULT 0,
    IsFreeKick boolean DEFAULT 0
);

CREATE TABLE Matches(
    Match_ID numeric(3) PRIMARY KEY,
    Team1 varchar(30) references Teams(Team_Name),
    Team2 varchar(30) references Teams(Team_Name),
    Goals1 numeric(2),
    Goals2 numeric(2),
    Venue varchar(30),
    `Time` varchar(10),
    check(`Time` in ('Morning','Afternoon','Night'))
);

CREATE TABLE Standings(
    Standing numeric(2),
    Team_Name varchar(30) references Teams(Team_Name),
    Matches_Played numeric(2),
    W numeric(2),
    L numeric(2),
    D numeric(2),
    Points numeric(3),
    GF numeric(4),
    GA numeric(4),
    GD numeric (4)
);

--TRIGGERS
{
delimiter //
DROP TRIGGER IF EXISTS MatchFinished;
DROP TRIGGER IF EXISTS update_goals;
CREATE TRIGGER MatchFinished
BEFORE INSERT ON Matches
FOR EACH ROW
BEGIN
    DECLARE i numeric(2);
    DECLARE n varchar(30);
    DECLARE C1 CURSOR FOR SELECT Team_Name FROM Standings ORDER BY Points DESC;

    UPDATE Standings SET Matches_Played = Matches_Played + 1 WHERE Team_Name = NEW.Team1;
    UPDATE Standings SET Matches_Played = Matches_Played + 1 WHERE Team_Name = NEW.Team2;

    UPDATE Standings SET GF = GF + NEW.Goals1 WHERE Team_Name = NEW.Team1;
    UPDATE Standings SET GF = GF + NEW.Goals2 WHERE Team_Name = NEW.Team2;

    UPDATE Standings SET GA = GA + NEW.Goals2 WHERE Team_Name = NEW.Team1;
    UPDATE Standings SET GA = GA + NEW.Goals1 WHERE Team_Name = NEW.Team2;

    UPDATE Standings SET GD = GF - GA WHERE Team_Name = NEW.Team1;
    UPDATE Standings SET GD = GF - GA WHERE Team_Name = NEW.Team2;

    IF NEW.Goals1> NEW.Goals2 THEN
        UPDATE Standings SET W = W+1 WHERE Team_Name = NEW.Team1;
        UPDATE Standings SET L = L+1 WHERE Team_Name = NEW.Team2;
        UPDATE Standings SET Points = Points+3 WHERE Team_Name = NEW.Team1;
    ELSEIF NEW.Goals2 > NEW.Goals1 THEN 
        UPDATE Standings SET W = W+1 WHERE Team_Name = NEW.Team2;
        UPDATE Standings SET L = L+1 WHERE Team_Name = NEW.Team1;
        UPDATE Standings SET Points = Points+3 WHERE Team_Name = NEW.Team2;
    ELSE
        UPDATE Standings SET D = D+1 WHERE Team_Name = NEW.Team1;
        UPDATE Standings SET D = D+1 WHERE Team_Name = NEW.Team2;
        UPDATE Standings SET Points = Points+1 WHERE Team_Name = NEW.Team1;
        UPDATE Standings SET Points = Points+1 WHERE Team_Name = NEW.Team2;
    END IF;

    OPEN C1;
    SET i = 1;
    changeStanding: LOOP
        FETCH C1 INTO n;
        UPDATE Standings SET Standing = i WHERE Team_Name = n;
        SET i = i+1;
        IF i<6 THEN
            ITERATE changeStanding;
        END IF;
        LEAVE changeStanding;
    END LOOP changeStanding;
END;//

CREATE TRIGGER update_goals
BEFORE INSERT ON Goals
FOR EACH ROW
BEGIN
    UPDATE Players
    SET Goals = Goals + 1
    WHERE Players.PID = NEW.PID;
END;//
delimiter ;
}

--FUNCTIONS
{
    delimiter //
    CREATE FUNCTION Insert_Goal(playerId numeric(3),forTeam varchar(30),againstTeam varchar(30))
    RETURNS varchar(30)
    DETERMINISTIC
    BEGIN
        DECLARE i numeric(2);
        DECLARE pname varchar(30);
        SELECT max(Match_ID) FROM Matches INTO i;
        SET i = i+1;
        SELECT Player_Name FROM Players WHERE PID = playerId INTO pname;
        INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(i, playerId, pname, forTeam, againstTeam);
        RETURN pname;
    END
    //
    delimiter ;

    CREATE PROCEDURE InsertGoal(playerId numeric(3), forTeam varchar(30), againstTeam varchar(30))
    BEGIN  
        CALL Insert_Goal(playerId, forTeam, againstTeam);
    END//
    DELIMITER ;

    BEGIN
        Insert_Goal()
    END;
}

--INSERTION
{
    INSERT INTO TEAMS VALUES(1,'MIT-A','Tejas Kittur',1);
    INSERT INTO TEAMS VALUES(2,'MIT-B','Kaustubh Singh',2);
    INSERT INTO TEAMS VALUES(3,'MIT-C','Anruag Majumdar',3);
    INSERT INTO TEAMS VALUES(4,'MIT-D','Arnav Gupta',4);
    INSERT INTO TEAMS VALUES(5,'MIT-E','Christiano Ronaldo',5);

    INSERT INTO Players VALUES(1, 'Tejas Kittur', 'MIT-A', 'Striker', 0, 20);
    INSERT INTO Players VALUES(2, 'Aarav', 'MIT-A', 'Striker', 0, 19);
    INSERT INTO Players VALUES(3, 'Rohit', 'MIT-A', 'Midfielder', 0, 21);
    INSERT INTO Players VALUES(4, 'Abhinav', 'MIT-A', 'Defender', 0, 18);
    INSERT INTO Players VALUES(5, 'Aditya', 'MIT-A', 'GK', 0, 20);
    INSERT INTO Players VALUES(6, 'Kaustubh Singh', 'MIT-B', 'Striker', 0, 22);
    INSERT INTO Players VALUES(7, 'Akash', 'MIT-B', 'Striker', 0, 21);
    INSERT INTO Players VALUES(8, 'Arjun', 'MIT-B', 'Midfielder', 0, 19);
    INSERT INTO Players VALUES(9, 'Dhruv', 'MIT-B', 'Defender', 0, 19);
    INSERT INTO Players VALUES(10, 'Gaurav', 'MIT-B', 'GK', 0, 18);
    INSERT INTO Players VALUES(11, 'Anurag Majumdar', 'MIT-C', 'Striker', 0, 18);
    INSERT INTO Players VALUES(12, 'Hritik', 'MIT-C', 'Striker', 0, 21);
    INSERT INTO Players VALUES(13, 'Ishan', 'MIT-C', 'Midfielder', 0, 20);
    INSERT INTO Players VALUES(14, 'Jayant', 'MIT-C', 'Defender', 0, 22);
    INSERT INTO Players VALUES(15, 'Kunal', 'MIT-C', 'GK', 0, 19);
    INSERT INTO Players VALUES(16, 'Arnav Gupta', 'MIT-D', 'Striker', 0, 18);
    INSERT INTO Players VALUES(17, 'Manish', 'MIT-D', 'Striker', 0, 24);
    INSERT INTO Players VALUES(18, 'Naveen', 'MIT-D', 'Midfielder', 0, 23);
    INSERT INTO Players VALUES(19, 'Pranav', 'MIT-D', 'Defender', 0, 21);
    INSERT INTO Players VALUES(20, 'Rajat', 'MIT-D', 'GK', 0, 20);
    INSERT INTO Players VALUES(21, 'Christiano Ronaldo', 'MIT-E', 'Striker', 0, 19);
    INSERT INTO Players VALUES(22, 'Sameer', 'MIT-E', 'Striker', 0, 19);
    INSERT INTO Players VALUES(23, 'Sanjay', 'MIT-E', 'Midfielder', 0, 20);
    INSERT INTO Players VALUES(24, 'Tarun', 'MIT-E', 'Defender', 0, 21);
    INSERT INTO Players VALUES(25, 'Uday', 'MIT-E', 'GK', 0, 20);

    INSERT INTO Standings VALUES(1, 'MIT-A', 0, 0, 0, 0, 0, 0, 0, 0);
    INSERT INTO Standings VALUES(2, 'MIT-B', 0, 0, 0, 0, 0, 0, 0, 0);
    INSERT INTO Standings VALUES(3, 'MIT-C', 0, 0, 0, 0, 0, 0, 0, 0);
    INSERT INTO Standings VALUES(4, 'MIT-D', 0, 0, 0, 0, 0, 0, 0, 0);
    INSERT INTO Standings VALUES(5, 'MIT-E', 0, 0, 0, 0, 0, 0, 0, 0);


    INSERT INTO Matches VALUES(1,'MIT-A','MIT-B',2,1,'Manipal','Night');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(1, 1,'Tejas Kittur', 'MIT-A', 'MIT-B');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(1, 2, 'Rohit', 'MIT-A', 'MIT-B');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(1, 6,'Kaustubh Singh', 'MIT-B', 'MIT-A');

    INSERT INTO Matches VALUES(2,'MIT-C','MIT-D',1,3,'Manipal','Morning');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(2, 11,'Anurag Majumdar', 'MIT-C', 'MIT-D');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(2, 16,'Arnav Gupta', 'MIT-D', 'MIT-C');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(2, 17,'Manish', 'MIT-D', 'MIT-C');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(2, 18,'Naveen', 'MIT-D', 'MIT-C');

    INSERT INTO Matches VALUES(3,'MIT-E','MIT-A',2,4,'Bangalore','Afternoon');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(3, 21,'Christiano Ronaldo', 'MIT-E', 'MIT-A');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(3, 21,'Christiano Ronaldo', 'MIT-E', 'MIT-A');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(3, 1,'Tejas Kittur', 'MIT-A', 'MIT-E');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(3, 1,'Tejas Kittur', 'MIT-A', 'MIT-E');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(3, 2,'Aarav', 'MIT-A', 'MIT-E');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(3, 3,'Rohit', 'MIT-A', 'MIT-E');

    INSERT INTO Matches VALUES(4,'MIT-B','MIT-C',3,2,'Manipal','Morning');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(4, 6,'Kaustubh Singh', 'MIT-B', 'MIT-C');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(4, 7,'Akash', 'MIT-B', 'MIT-C');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(4, 6,'Kaustubh Singh', 'MIT-B', 'MIT-C');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(4, 11,'Anurag Majumdar', 'MIT-C', 'MIT-B');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(4, 12,'Hritik', 'MIT-C', 'MIT-B');

    INSERT INTO Matches VALUES(5,'MIT-D','MIT-E',2,2,'Manipal','Night');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(5, 16,'Arnav Gupta', 'MIT-D', 'MIT-E');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(5, 17,'Manish', 'MIT-D', 'MIT-E');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(5, 21,'Christiano Ronaldo', 'MIT-E', 'MIT-D');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(5, 22,'Sameer', 'MIT-E', 'MIT-D');

    INSERT INTO Matches VALUES(6,'MIT-A','MIT-D',5,1,'Mangalore','Night');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(6, 1,'Tejas Kittur', 'MIT-A', 'MIT-D');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(6, 1,'Tejas Kittur', 'MIT-A', 'MIT-D');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(6, 2,'Aarav', 'MIT-A', 'MIT-D');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(6, 3,'Rohit', 'MIT-A', 'MIT-D');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(6, 2,'Aarav', 'MIT-A', 'MIT-D');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(6, 18,'Naveen', 'MIT-D', 'MIT-A');

    INSERT INTO Matches VALUES(7,'MIT-C','MIT-E',1,3,'Manipal','Morning');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(7, 11,'Anurag Majumdar', 'MIT-C', 'MIT-E');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(7, 21,'Christiano Ronaldo', 'MIT-E', 'MIT-C');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(7, 22,'Sameer', 'MIT-E', 'MIT-C');
    INSERT INTO Goals(Match_ID,PID,Player_Name,`For`,Against) VALUES(7, 23,'Sanjay', 'MIT-E', 'MIT-C');

}

select * from teams; --Display all teams
select * from players; --Display all players
select * from matches; --Display all matches
select * from goals; --Display all goals
select * from standings order by points desc, GD desc; --Display Leaderboards

select * from players where Team_Name = 'MIT-A'; --Display all players in team MIT-A
select * from players where goals>2; --Display players who have scored more than 2 goals
select * from players where position = 'GK'; --Display all players of position GK
select * from players where age = 19; --Display all players of age 19

select Captain_Name,Team_Name from Teams; --Display all captains
select Captain_Name from teams where team_name = 'MIT-E'; --Display team MIT-E captain's name

select * from matches where `time` = 'Night'; --Display all matches that took place during night time
select * from matches where venue = 'Manipal'; --Display all matches that took place in Manipal

select Name,goals from players where position = 'Striker' and goals <= all(select goals from players where position = 'Striker'); --Display striker with least goals among other strikers

select Name,goals from players where goals > 0 and pid in (select pid from players where team_name = 'MIT-C');


select name,Team_Name from players where team_name in(
select Team1 from Matches where match_id in (select pen from (
    select match_id, count(ispenalty) as pen from goals where ispenalty = true group by match_id) as subquery where pen = 2))
UNION(
    select name,Team_Name from players where team_name in(
    select Team2 from Matches where match_id in (select pen from (
    select match_id, count(ispenalty) as pen from goals where ispenalty = true group by match_id) as subquery where pen = 2))
);


BEGIN
    DECLARE maxGoalsTeam varchar(30);
    DECLARE g1 numeric(2);
    DECLARE g2 numeric(2);
    DECLARE g3 numeric(2);
    DECLARE g4 numeric(2);
    DECLARE pname varchar(30);

    SELECT Goals1 FROM Matches where match_id=6 INTO g1;
    SELECT Goals2 FROM Matches where match_id=6 INTO g2;
    SELECT Goals1 FROM Matches where match_id=7 INTO g3;
    SELECT Goals2 FROM Matches where match_id=7 INTO g4;

    IF g1>g2


END;
