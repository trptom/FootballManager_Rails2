var formatFunc = function(o, cacheType) {
    var flag = $(o.element).data('flag');
    var val = $(o.element).val();
    console.log(val);
    if (!listCache[cacheType][val]) {
        var img = document.createElement("img");
        var title = document.createElement("span");
        jQuery(img).attr("src", flag);
        jQuery(img).attr("class", "flag");
        jQuery(title).html(o.text);

        listCache[cacheType][val] = document.createElement("div");
        listCache[cacheType][val].className = "select2option leagues index countries";
        listCache[cacheType][val].appendChild(img);
        listCache[cacheType][val].appendChild(title);
    }

    return listCache[cacheType][val];
};

var Tactics = {};
Tactics.Show = {
    formatPosFunc: function(o, cacheType) {
        var ret = document.createElement("div");
        ret.img = document.createElement("img");
        ret.tit = document.createElement("span");
        
        ret.tit.innerHTML = o.text;
        
        ret.appendChild(ret.img);
        ret.appendChild(ret.tit);
        
        return ret;
    },
    
    formatPlayerFunc: function(o, cacheType) {
        var ret = document.createElement("div");
        $(ret).addClass("player-detail");
        
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
        
        return ret;
    }
}

$(document).ready(function() {
    $(".position-select").select2({
        minimumResultsForSearch: -1,
        formatResult: function(o) { return Tactics.Show.formatPosFunc(o, "result"); },
        formatSelection: function(o) { return Tactics.Show.formatPosFunc(o, "selection"); },
        escapeMarkup: function(m) { return m; }
    });
    $(".player-select").select2({
        minimumResultsForSearch: -1,
        formatResult: function(o) { return Tactics.Show.formatPlayerFunc(o, "result"); },
        formatSelection: function(o) { return Tactics.Show.formatPlayerFunc(o, "selection"); },
        escapeMarkup: function(m) { return m; }
    });
});