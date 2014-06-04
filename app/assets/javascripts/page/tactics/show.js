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
        
        if (pos === -1) {
            ret.innerHTML = "";
        } else {
            console.log("val = " + $(o.element).val());
            var player = null;
            try {
                var player = this.positions[pos].player;
            } catch (ex) {}

            ret.innerHTML = pos + (player ? (" - " + player.p_name) : "");
        }
        
        return ret;
    },
    
    parseHiddenData: function() {
        var dataPlayers = $("#hidden-data-players").html();
        var dataPositions = $("#hidden-data-positions").html();
        
        dataPlayers = dataPlayers.replace(/$[ \n]+/g, "").replace(/[ \n]+;[ \n]+/g, ";").split(";");
        for (var a=0; a<dataPlayers.length; a++) {
            var tmp = dataPlayers[a].split(",");
            if (tmp.length === 2) {
                var p = new Player(parseInt(tmp[0], 10), tmp[1]);
                this.players[this.players.length] = p;
                console.log(p);
            }
        }
        
        dataPositions = dataPositions.replace(/$[ \n]+/g, "").replace(/[ \n]+;[ \n]+/g, ";").split(";");
        for (var a=0; a<dataPositions.length; a++) {
            var tmp = dataPositions[a].split(",");
            switch (tmp.length) {
                case 2:
                    var p = new Position(parseInt(tmp[0], 10), parseInt(tmp[1], 10), this.players[0]);
                    this.positions[this.positions.length] = p;
                    console.log(p);
                    break;
                case 3:
                    var p = new Position(parseInt(tmp[0], 10), parseInt(tmp[1], 10), this.players[0]/*this.getPlayerById(parseInt(tmp[2], 10))*/);
                    this.positions[this.positions.length] = p;
                    console.log(p);
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
    
    getPositionNumberByPlayer: function(playerId) {
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
        var pos = this.positions[selectElement.value];
        var player = this.getPlayerById(playerId);        
        
        pos.player = player;
    },
    
    sort: function() {
        var table = document.getElementById("players").getElementsByTagName("tbody")[0];
        var rows = [];
        while (table.childNodes.length > 0) {
            rows[rows.length] = {
                val: $(table.lastChild.getElementsByTagName("select")[0]).val(),
                item: table.lastChild
            };
            
            for (var a=rows.length-1; a>0; a--){
                if (rows[a].val < rows[a-1].val) {
                    var tmp = rows[a];
                    rows[a] = rows[a-1];
                    rows[a-1] = tmp;
                }
            }
            
            table.removeChild(table.lastChild);
        }
        
        for (var a=0; a<rows.length; a++) {
            table.appendChild(rows[a]);
        }
//        
//        var rows = [];
//        $("#players tbody tr").each(function(elem){
//            rows[rows.length] = elem;
//            table.removeChild
//        });
//        
//        $("#players").each(function() {
//            var _this = $(this);
//            var newrows = [];
//            _this.find("tbody tr").each(function(){
//                var i = 0;
//                $(this).find("td").each(function(){
//                    i++;
//                    if(newrows[i] === undefined) { newrows[i] = $("<tr></tr>"); }
//                    newrows[i].append($(this));
//                });
//            });
//            $this.find("tr").remove();
//            $.each(newrows, function(){
//                $this.append(this);
//            });
//        });
        
//        $("#players tbody").each(function(elem, index) {
//            var arr = $.makeArray($("tr", elem).detach());
//            arr.reverse();
//            $(elem).append(arr);
//        });
//        var rows = document.getElementById("players").rows;
//        var newRows = [];
//        
//        newRows[0] = rows[0]
//        for (var a=1; a<rows.length; a++) {
//            newRows[rows.length-a] = rows[a];
//        }
//        
//        document.getElementById("players").rows = newRows;
        
//        var rows = tbody.rows,
//            rlen = rows.length,
//            arr = new Array(),
//            i, j, cells, clen;
//        // fill the array with values from the table
//        for (i = 0; i < rlen; i++) {
//            cells = rows[i].cells;
//            clen = cells.length;
//            arr[i] = new Array();
//            for (j = 0; j < clen; j++) {
//                arr[i][j] = cells[j].innerHTML;
//            }
//        }
//        // sort the array by the specified column number (col) and order (asc)
//        arr.sort(function (a, b) {
//            return (a[col] == b[col]) ? 0 : ((a[col] > b[col]) ? asc : -1 * asc);
//        });
//        // replace existing rows with new rows created from the sorted array
//        for (i = 0; i < rlen; i++) {
//            rows[i].innerHTML = "<td>" + arr[i].join("</td><td>") + "</td>";
//        }
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