Counter = {
    NEXT_CLICK_TIMEOUT: 1,
    
    counting: false,
    
    getAllActions: function() {
        return $(".btn.action");
    },
    
    getNextAction: function(cuttentActionButton) {
        var actions = Counter.getAllActions();
        var id = null;
        actions.each(function(index, elem) {
            if (elem === cuttentActionButton) {
                if (index < actions.length-1) {
                    id = actions[index+1];
                }
            };
        });
        return id;
    },
    
    findNextAndClick: function(cuttentActionButton) {
        var next = this.getNextAction(cuttentActionButton);
        if (next !== null) {
            setTimeout(function() {
                Counter.counting = false; // anonymous function, cant use this pointer
                $(next).click();
            }, this.NEXT_CLICK_TIMEOUT);
        } else {
            this.counting = false;
        }
    }
};