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
    
    formatPlayerFunc: function(o) {
        var ret = document.createElement("div");
        $(ret).addClass("player-detail");
        
        if ($(o.element).val() > 0) {
            ret.info = document.createElement("div");
            ret.atts = document.createElement("div");

            ret.name = document.createElement("span");
            ret.nation = document.createElement("img");
            ret.age = document.createElement("span");
            ret.gk = document.createElement("span");
            ret.def = document.createElement("span");
            ret.mid = document.createElement("span");
            ret.att = document.createElement("span");

            ret.name.innerHTML = $(o.element).data('name');
            ret.nation.src = $(o.element).data('flag');
            ret.age.innerHTML = "(" + $(o.element).data('age') + ")";

            ret.gk.innerHTML = $(o.element).data('gk');
            ret.def.innerHTML = $(o.element).data('def');
            ret.mid.innerHTML = $(o.element).data('mid');
            ret.att.innerHTML = $(o.element).data('att');

            ret.appendChild(ret.info);
            ret.appendChild(ret.atts);

            ret.info.appendChild(ret.nation);
            ret.info.appendChild(ret.name);
            ret.info.appendChild(ret.age);
            ret.atts.appendChild(ret.gk);
            ret.atts.appendChild(ret.def);
            ret.atts.appendChild(ret.mid);
            ret.atts.appendChild(ret.att);
        } else {
            ret.info = document.createElement("div");
            ret.name = document.createElement("span");
            ret.name.innerHTML = $(o.element).data('name');
            ret.appendChild(ret.info);
            ret.info.appendChild(ret.name);
        }
        
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
                    this.positions[a].player.id === playerId) {
                return a;
            }
        }
        return null;
    },
    
    playerChanged: function(posId, playerSelect) {
        var pos = this.getPositionById(posId);
        var player = this.getPlayerById(playerSelect.value);
        
        pos.player = player;
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
    $(".player-select").select2({
        minimumResultsForSearch: -1,
        formatResult: function(o) { return Tactics.Show.formatPlayerFunc(o); },
        formatSelection: function(o) { return Tactics.Show.formatPlayerFunc(o); },
        escapeMarkup: function(m) { return m; }
    });
    $(".player-position-select").select2({
        minimumResultsForSearch: -1,
        formatResult: function(o) { return Tactics.Show.formatPlayerPositionFunc(o); },
        formatSelection: function(o) { return Tactics.Show.formatPlayerPositionFunc(o); },
        escapeMarkup: function(m) { return m; }
    });
});