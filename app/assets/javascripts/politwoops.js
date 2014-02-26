(function($){
    $(function(){
        $('img.politician-avatar').error(function(e){
            e.preventDefault();
            $(this).attr('src', '/assets/avatar_missing_male.png');
        });
    });
})(jQuery);

