USE zojak;

DELIMITER $$

DROP PROCEDURE IF EXISTS `GetLatestRatings`$$
CREATE PROCEDURE GetLatestRatings (arg_server_name VARCHAR(255))
BEGIN	
	-- get unique kill list
    INSERT IGNORE INTO unique_kill (killer_id, victim_id,  timestamp, server_name)
	SELECT     	killer_id, victim_id, MIN(timestamp), server_name
	FROM       	kill_log
	WHERE		server_name = arg_server_name
    GROUP BY	UNIX_TIMESTAMP(timestamp) DIV 5, server_name
	ORDER BY 	timestamp;

	-- insert killers
    INSERT IGNORE INTO ratings (id, server_name, season, rating)
    SELECT 		DISTINCT killer_id, server_name, YEAR(k.timestamp)*12 + MONTH(k.timestamp), 1400
    FROM		unique_kill k;
	
    -- insert victims
    INSERT IGNORE INTO ratings (id, server_name, season, rating)
    SELECT 		DISTINCT victim_id, server_name, YEAR(k.timestamp)*12 + MONTH(k.timestamp), 1400
    FROM		unique_kill k;
  
    CALL UpdatePlayerRatings(arg_server_name);
		
	#UPDATE W/L
	UPDATE ratings SET wins = (	SELECT 	COUNT(*) 
								FROM 	unique_kill k 
                                WHERE 	killer_id = ratings.id 
									AND k.server_name = arg_server_name 
                                    AND season = YEAR(k.timestamp)*12 + MONTH(k.timestamp)
								);
	UPDATE ratings SET losses = (	SELECT 	COUNT(*) 
									FROM 	unique_kill k 
									WHERE 	victim_id = ratings.id 
										AND k.server_name = arg_server_name 
										AND season = YEAR(k.timestamp)*12 + MONTH(k.timestamp)
									);
                                    
	SELECT		id, IFNULL(name,'(UNKNOWN)') name, rating, RANK() OVER (ORDER BY rating DESC) 'rank', wins, losses
    FROM		ratings r
    LEFT JOIN	player p
		ON r.id = p.object_id
    WHERE		r.server_name = arg_server_name
		AND	season = YEAR(NOW())*12 + MONTH(NOW());
END$$
DELIMITER ;

#CALL UpdatePlayerRatings('GamesDeadArena');
#CALL GetLatestRatings('GamesDeadArena');

/*
INSERT INTO kill_log (killer_id, victim_id, timestamp, server_name, season, submitter_id) VALUES (2, 1, now(), 'GamesDeadArena', 1, 3);
INSERT INTO kill_log (killer_id, victim_id, timestamp, server_name, season, submitter_id) VALUES (2, 1, now(), 'GamesDeadArena', 1, 4);
INSERT INTO kill_log (killer_id, victim_id, timestamp, server_name, season, submitter_id) VALUES (2, 1, now(), 'GamesDeadArena', 1, 1);

INSERT INTO kill_log (killer_id, victim_id, timestamp, server_name, season, submitter_id) VALUES (2, 1, now(), 'GamesDeadArena', 1, 3);
INSERT INTO player (object_id, name, server_name) VALUES (1, 'Eve', 'GamesDeadArena');
INSERT INTO player (object_id, name, server_name) VALUES (2, 'Adam', 'GamesDeadArena');
INSERT INTO player (object_id, name, server_name) VALUES (3, 'John', 'GamesDeadArena');
INSERT INTO player (object_id, name, server_name) VALUES (4, 'Ramsey', 'GamesDeadArena');

// ---- UPDATE STATS ----                    
                    string[] blacklist = { "Hallas", "Damage Receiving Bot", "Black Lives Matter", "Relitor", "Target", "The Real Shenti"
                                            ,"You blast", "Redyadead", "Lacocks", "Almighty pk", "The legend", "This guy", "Best pk og mage", "True mage life"
                                            ,"Teets", "Sad man mike", "Gank me please", "I Might Be Bad", "Wewt", "Puire" };
                    if (killer != "" && victim != "" && !blacklist.Contains(killer) && !blacklist.Contains(victim))
                    {
                        // get players' profiles
                        if (!playerStats.Exists(p => p.Name == killer))
                        {                            
                            Player player = new Player(killer);
                            playerStats.Add(player);
                        }                        
                        if (!playerStats.Exists(p => p.Name == victim))
                        {
                            Player player = new Player(victim);
                            playerStats.Add(player);
                        }
                        Player killerProfile = playerStats.Find(p => p.Name == killer);
                        Player victimProfile = playerStats.Find(p => p.Name == victim);

                        KillEvent theKill = new KillEvent(s, killer, victim, timestamp);

                        // calculate ELO
                        int killerElo = killerProfile.Elo;
                        int victimElo = victimProfile.Elo;

                        double tKillerRating = Math.Pow(10, (killerElo / 400.0));
                        double tVictimRating = Math.Pow(10, (victimElo / 400.0));

                        double killerWinChance = Convert.ToDouble(tKillerRating) / (tKillerRating + tVictimRating);
                        double victimWinChance = Convert.ToDouble(tVictimRating) / (tKillerRating + tVictimRating);

                        double killerWinChance2 = 1.0 / (1 + Math.Pow(10, ((victimElo - killerElo) / 400.0)));
                        double victimWinChance2 = 1.0 / (1 + Math.Pow(10, ((killerElo - victimElo) / 400.0)));

                        // set new ELO
                        const double K = 32;
                        int killerEloChange = Convert.ToInt32(Math.Round(K * (1 - killerWinChance), 0));
                        int victimEloChange = Convert.ToInt32(Math.Round(K * (0 - victimWinChance), 0));
                        int newKillerElo = killerElo + killerEloChange;
                        int newVictimElo = victimElo + victimEloChange;

                        playerStats.Find(p => p.Name == killer).Elo = newKillerElo;
                        playerStats.Find(p => p.Name == victim).Elo = newVictimElo;

                        theKill.KillerEloChange = killerEloChange;
                        theKill.VictimEloChange = victimEloChange;

                        // update win/loss stats
                        killerProfile.WinCount++;
                        killerProfile.VictimList.Add(theKill);

                        victimProfile.LossCount++;
                        victimProfile.KillerList.Add(theKill);
                    }
                    else
                    {
                        if (!blacklist.Contains(killer) && !blacklist.Contains(victim))
                            unparsedKills.Add(s);
                    }
*/