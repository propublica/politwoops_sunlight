var CongressApi = (function($){
    function CongressApi (api_key) {
        if (this === undefined ) { return new CongressApi(api_key); }

        this.api_key = api_key;
        this.url_stub = 'https://congress.api.sunlightfoundation.com';
    };

    CongressApi.prototype.legislators = function (criteria) {
        var $def = new $.Deferred();
        var qparams = $.extend(true, {}, criteria);
        qparams['apikey'] = this.api_key;
        var leg_request = $.ajax(this.url_stub + '/legislators', {
            'data': qparams
        }).done(function(response){
            if ((response.count == null) || (response.count === 0)) {
                $def.rejectWith(this, [response]);
            } else {
                $def.resolveWith(this, [response]);
            }
        }).fail(function(){
            $def.rejectWith(this, [response]);
        });
        return $def;
    };

    return CongressApi;
})(jQuery);


