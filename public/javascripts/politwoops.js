(function($){
    $(function(){
        $('img.politician-avatar').error(function(e){
            e.preventDefault();
            $(this).attr('src', '/images/avatar_missing_male.png');
        });
    });

    $(document).ready(function(){
        $('img.politician-avatar').each(function(ix, img){
            var realsrc = $(img).attr('data-lateimg-src');
            if ((realsrc != null) && (realsrc !== '')) {
                $(img).attr('src', realsrc);
            }
        });
    });

})(jQuery);

