var Tactics = {};

/*******************************************************************************
 * Class of player.
 * @param {type} id
 * @param {type} name
 * @returns {Player}
 */
function Player(id, name) {
    this.id = id;
    this.p_name = name;
}

Player.prototype.toString = function() {
    return "#" + this.id + " " + this.p_name;
};

/*******************************************************************************
 * Class of position.
 * @param {type} id
 * @param {type} position
 * @param {type} player
 * @returns {Position}
 */
function Position(id, position, player) {
    this.id = id;
    this.position = position;
    this.player = player;
}

/*******************************************************************************
 * 
 * @type type
 */
Tactics.Show = {
    PLAYER_POSITION: {
        POS: {
            1: 10, // GK
            2: 25, // D
            3: 40, // DM
            4: 55, // M
            5: 70, // AM
            6: 85 // S
        },
        SIDE: {
            0: 20, // L
            1: 40, // LC
            2: 50, // C
            3: 60, // RC
            4: 80 // R
        }
    },
    
    players: [],
    positions: [],
    positionStrings: [],
    
    formatPosFunc: function(o) {
        var ret = document.createElement("div");
        ret.img = document.createElement("img");
        ret.tit = document.createElement("span");
        
        ret.tit.innerHTML = o.text;
        
        ret.appendChild(ret.img);
        ret.appendChild(ret.tit);
        
        return ret;
    },
    
    formatPlayerPositionFunc: function(o) {
        var pos = parseInt($(o.element).val());
        var ret = document.createElement("div");
        $(ret).addClass("player-position");
        
        console.log(pos);
        
        ret.innerHTML = pos >= 0 ? this.positionStrings[this.positions[pos].position] : "";
        
        if (pos >= 0 && this.positions[pos].player !== null) {
            $(ret).addClass("disabled");
            ret.title = this.positions[pos].player;
        }
        
        return ret;
    },
    
    parseHiddenData: function() {
        var dataPlayers = $("#hidden-data-players").html();
        var dataPositions = $("#hidden-data-positions").html();
        var dataPositionStrings = $("#hidden-data-position-strings").html();
        
        dataPlayers = dataPlayers.replace(/$[ \n]+/g, "").replace(/[ \n]+;[ \n]+/g, ";").split(";");
        for (var a=0; a<dataPlayers.length; a++) {
            var tmp = dataPlayers[a].split(",");
            if (tmp.length === 2) {
                var p = new Player(parseInt(tmp[0], 10), tmp[1]);
                this.players[this.players.length] = p;
            }
        }
        
        dataPositionStrings = dataPositionStrings.replace(/$[ \n]+/g, "").replace(/[ \n]+;[ \n]+/g, ";").split(";");
        this.positionStrings[-1] = "";
        for (var a=0; a<dataPositionStrings.length; a++) {
            var tmp = dataPositionStrings[a].split(",");
            if (tmp.length === 2) {
                this.positionStrings[parseInt(tmp[0], 10)] = tmp[1];
            }
        }
        
        dataPositions = dataPositions.replace(/$[ \n]+/g, "").replace(/[ \n]+;[ \n]+/g, ";").split(";");
        for (var a=0; a<dataPositions.length; a++) {
            var tmp = dataPositions[a].split(",");
            switch (tmp.length) {
                case 2:
                    var p = new Position(parseInt(tmp[0], 10), parseInt(tmp[1], 10), this.players[0]);
                    this.positions[this.positions.length] = p;
                    break;
                case 3:
                    var p = new Position(parseInt(tmp[0], 10), parseInt(tmp[1], 10), this.getPlayerById(parseInt(tmp[2], 10)));
                    this.positions[this.positions.length] = p;
                    break;
                default:
                    break;
            }
        }
    },
    
    getPlayerById: function(id) {
        for (var a=0; a<this.players.length; a++) {
            if (this.players[a].id === id) {
                return this.players[a];
            }
        }
        return null;
    },
    
    getPositionById: function(id) {
        for (var a=0; a<this.positions.length; a++) {
            if (this.positions[a].id === id) {
                return this.positions[a];
            }
        }
        return null;
    },
    
    getPositionByPlayer: function(playerId) {
        for (var a=0; a<this.positions.length; a++) {
            if (this.positions[a].player !== null &&
                    this.positions[a].player.id === playerId) {
                return this.positions[a];
            }
        }
        return null;
    },
    
    getPositionByNumber: function(number) {
        for (var a=0; a<this.positions.length; a++) {
            if (this.positions[a].player !== null &&
                    this.positions[a].player.id === number) {
                return a;
            }
        }
        return null;
    },
    
    playerPositionChanged: function(playerId, selectElement) {
        var pos1 = this.getPositionByPlayer(playerId);
        if (pos1 !== null) {
            pos1.player = null;
        }
        
        if (selectElement.value >= 0) {
            var pos2 = this.positions[selectElement.value];
            var player = this.getPlayerById(playerId);        
            
            pos2.player = player;
        }
        
        this.sort();
        this.updatePitchPlayers();
    },
    
    sort: function() {
        var table = document.getElementById("players").getElementsByTagName("tbody")[0];
        var rows = [];
        console.log("cnl=" + table.childNodes.length);
        while (table.childNodes.length > 0) {
            console.log("tn=" + table.firstChild.tagName);
            if (table.firstChild.tagName &&
                    table.firstChild.tagName.toUpperCase() === "TR") {
                rows[rows.length] = {
                    val: parseInt($(table.firstChild.getElementsByTagName("select")[0]).val(), 10),
                    item: table.firstChild
                };
                
                console.log("val = " + rows[rows.length-1].val);

                for (var a=rows.length-1; a>0; a--){
                    if ((rows[a].val >= 0 && rows[a-1].val < 0) || (rows[a].val >= 0 && rows[a].val < rows[a-1].val)) {
                        var tmp = rows[a];
                        rows[a] = rows[a-1];
                        rows[a-1] = tmp;
                    } else{
                        break;
                    }
                }
            }
            
            table.removeChild(table.firstChild);
        }
        
        for (var a=0; a<rows.length; a++) {
            table.appendChild(rows[a].item);
        }
    },
    
    changeLineup: function() {
        var lineupVal = $("#predefined-lineups").val();
        
        if (lineupVal) {
            var lineup = lineupVal.split(",");
            for (var a=0; a<lineup.length; a++) {
                console.log("lineup[a] = " + parseInt(lineup[a], 10));
                this.positions[a].position = parseInt(lineup[a], 10);
            }
        }
        
        this.updatePitchPlayers();
    },
    
    updatePitchPlayers: function() {
        var pitch = $("#pitch");
        var w = pitch.outerWidth();
        var h = pitch.outerHeight();
        
        for (var a=0; a<11; a++) {
            var elem = $("#pitch-player-"+a);
            
            elem.html( this.positionStrings[this.positions[a].position]
                    + (this.positions[a].player ? " - " + this.positions[a].player.p_name : ""));
            
            var y;
            var x;
            
            if (this.positions[a].position === 1) { // special for goalkeeper
                y = this.PLAYER_POSITION.POS[1];
                x = this.PLAYER_POSITION.SIDE[2];
            } else {
                y = this.PLAYER_POSITION.POS[Math.floor(this.positions[a].position / 10)];
                x = this.PLAYER_POSITION.SIDE[Math.floor(this.positions[a].position % 10)];
            }
            
            var left = Math.round(w * x / 100) - (elem.outerWidth() / 2);
            var top = Math.round(h * (100 - y) / 100) - (elem.outerHeight() / 2);
            
            console.log("left=" + left + "; top=" + top + "; player=" + this.positions[a].player);
            
            elem.css({
                left: left,
                top: top
            });
        }
    }
};

$(document).ready(function() {
    Tactics.Show.parseHiddenData();
    
    $(".position-select").select2({
        minimumResultsForSearch: -1,
        formatResult: function(o) { return Tactics.Show.formatPosFunc(o); },
        formatSelection: function(o) { return Tactics.Show.formatPosFunc(o); },
        escapeMarkup: function(m) { return m; }
    });
    $(".player-position-select").select2({
        minimumResultsForSearch: -1,
        formatResult: function(o) { return Tactics.Show.formatPlayerPositionFunc(o); },
        formatSelection: function(o) { return Tactics.Show.formatPlayerPositionFunc(o); },
        escapeMarkup: function(m) { return m; }
    });
    $("#predefined-lineups").select2({
        minimumResultsForSearch: -1
    });
    
    Tactics.Show.updatePitchPlayers();
});