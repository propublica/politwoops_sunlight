(function($){
    $(function(){
        $('img.politician-avatar').error(function(e){
            e.preventDefault();
            $(this).attr('src', '/images/avatar_missing_male.png');
        });
    });
})(jQuery);

