var OpenCivicDataApi = (function($){
    function OpenCivicDataApi (api_key) {
        if (this === undefined ) { return new OpenCivicDataApi(api_key); }

        this.api_key = api_key;
        this.url_stub = 'https://api.opencivicdata.org';
    };

    OpenCivicDataApi.prototype.people = function (criteria) {
        var $def = new $.Deferred();
        var qparams = $.extend(true, {}, criteria);
        qparams['apikey'] = this.api_key;
        $.ajax(this.url_stub + '/people/', {
            'dataType': 'jsonp',
            'data': qparams
        }).done(function(response){
            if ((response.meta == null) || (response.meta.count == null) || (response.meta.count === 0)) {
                $def.rejectWith(this, [response]);
            } else {
                $def.resolveWith(this, [response]);
            }
        }).fail(function(response){
            $def.rejectWith(this, [response]);
        });
        return $def;
    };

    return OpenCivicDataApi;
})(jQuery);



