
var Countries = {};
Countries.show = {
    timer: null,
    
    autoRefreshChanged: function() {
        var ar = $("#autorefresh");
        
        if (ar !== null && ar.prop("checked")) {
            if (this.timer === null) {
                this.timer = setTimeout(function() {
                    location.reload(true);
                }, 60000);
            }
        } else {
            if (this.timer !== null) {
                clearTimeout(this.timer);
            }
        }
    }
};

$(document).ready(function() {
    // auto refresh page
    Countries.show.autoRefreshChanged();
});