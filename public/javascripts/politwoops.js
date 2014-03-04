(function($){

    var swap_attributes = function (elem, attr_a, attr_b) {
        var $e = $(elem);
        var value_a = $e.attr(attr_a);
        var value_b = $e.attr(attr_b);
        if ((value_a != null) && (value_b != null)) {
            $e.attr(attr_a, value_b);
            $e.attr(attr_b, value_a);
        }
    };

    $(function(){
        $('img.politician-avatar').error(function(e){
            e.preventDefault();
            swap_attributes(this, 'src', 'data-lateimg-src');
        });
    });

    $(document).ready(function(){
        $('img.politician-avatar').each(function(ix, img){
            if ($(img).attr('src') !== '') {
                swap_attributes(img, 'src', 'data-lateimg-src');
            }
        });
    });

})(jQuery);

