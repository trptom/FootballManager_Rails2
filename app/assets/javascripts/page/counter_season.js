CounterSeason = {
    updateLeagueTeams: function(leagueId, senderBut) {
        if (!Counter.counting) {
            Counter.counting = true;
            
            $(senderBut).addClass("disabled");
            $.ajax({
                url: "/counter/season_update_league_teams.json",
                type: "POST",
                dataType: "json",
                async: true,
                data: {
                    id: leagueId
                },
                success: function(data) {
                    if (data.result === true) {
                        $(senderBut).css({
                            display: "none"
                        });

                        Counter.findNextAndClick(senderBut);
                    } else {
                        alert("error during updating league teams (" + leagueId + ")!");
                        Counter.counting = false;
                    }
                },
                error: function() {
                    alert("error during calling of season_update_league_teams controller (" + leagueId + ")!");
                    Counter.counting = false;
                }
            });
        }
    },
    
    drawLeague: function(leagueId, senderBut) {
        if (!Counter.counting) {
            Counter.counting = true;
            
            $(senderBut).addClass("disabled");
            $.ajax({
                url: "/counter/season_draw_league.json",
                type: "POST",
                dataType: "json",
                async: true,
                data: {
                    id: leagueId
                },
                success: function(data) {
                    if (data.result === true) {
                        $(senderBut).css({
                            display: "none"
                        });

                        Counter.findNextAndClick(senderBut);
                    } else {
                        alert("error during drawing league " + leagueId + "!");
                        Counter.counting = false;
                    }
                },
                error: function() {
                    alert("error during calling of draw league controller (" + leagueId + ")!");
                    Counter.counting = false;
                }
            });
        }
    }
};