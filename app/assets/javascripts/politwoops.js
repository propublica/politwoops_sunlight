(function($){
    var congress_api = new CongressApi(Politwoops.sunlight_api_key);
    var ocd_api = new OpenCivicDataApi(Politwoops.sunlight_api_key);

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



    (function($form){
        function extract_name_from_form () {
            var last_name = $form.find("input#ln_input").val() || $form.find("input#last_name_input").val();
            var first_name = $form.find("input#fn_input").val() || $form.find("input#first_name_input").val();

            if ((last_name == null) || (last_name === '')) {
                last_name = $form.find("span#last_name").text();
            }
            if ((first_name == null) || (first_name === '')) {
                first_name = $form.find("span#first_name").text();
            }
            return {'first_name': first_name, 'last_name': last_name};
        };

        function copy_bioguide_identifier_to_form (click) {
            var bioguide_id = $(this).text();
            $form.find("input.bioguide_id").val(bioguide_id);
        };

        function copy_ocd_identifier_to_form (click) {
            var ocd_id = $(this).text();
            $form.find("input.opencivicdata_id").val(ocd_id);
        };

        var down_arrow = "&#x25bc;";
        var up_arrow = "&#x25b2;";

        $form.find("li.bioguide_id button.expander").toggle(
            function showBioguideSuggestions (click) {
                var name = extract_name_from_form();
                var $expanded_area = $form.find("li.bioguide_id div.expandable");
                var $leglist = $expanded_area.find("ul.suggestions");
                $leglist.hide().empty();
                $expanded_area.show();
                var name = extract_name_from_form();
                if ((name.last_name == null) || (name.last_name === '')) {
                    return;
                }
                congress_api.legislators(name).done(function(response){
                    var legislators = response.results;
                    $("script#bioguide-id-suggestion").tmpl(legislators).appendTo($leglist);
                    $leglist.find("a.identifier").click(copy_bioguide_identifier_to_form);
                    $leglist.fadeIn(400);
                    $form.find("li.bioguide_id button.expander").html(up_arrow);
                });
            },

            function hideBioguideSuggestions () {
                $form.find("li.bioguide_id div.expandable").fadeOut(150);
                $form.find("li.bioguide_id button.expander").html(down_arrow);
            }
        );

        $form.find("li.opencivicdata_id button.expander").toggle(
            function showOpenCivicDataSuggestions () {
                var $expanded_area = $form.find("li.opencivicdata_id div.expandable");
                var $sugglist = $expanded_area.find("ul.suggestions");
                $sugglist.hide().empty();
                $expanded_area.show();
                var name = extract_name_from_form();
                if ((name.last_name == null) || (name.last_name === '')) {
                    return;
                }
                ocd_api.people({'name': name.last_name}).done(function(response){
                    var ppl = response.results;
                    var ppl1 = response.results.filter(function(p){
                        return p.name.startsWith(name.first_name);
                    });
                    if (ppl1.length > 0) {
                        ppl = ppl1;
                    }
                    $("script#ocd-id-suggestion").tmpl(ppl).appendTo($sugglist);
                    $sugglist.find("a.identifier").click(copy_ocd_identifier_to_form);
                    $sugglist.fadeIn(400);
                    $form.find("li.opencivicdata_id button.expander").html(up_arrow);
                });
            },
            function hideOpenCividDataSuggestions () {
                $form.find("li.opencivicdata_id div.expandable").fadeOut(150);
                $form.find("li.opencivicdata_id button.expander").html(down_arrow);
                $form.find("li.opencivicdata_id ul.suggestions").empty();
            }
        );

        $form.find("input.bioguide_id").change(function(){
            var ocd_id = $form.find(".opencivicdata_id").val();
            if ((ocd_id != null) && (ocd_id !== '')) {
                console.log("Going to find OCD id for", $(this).val());
            }
        });
    })($("form#admin-politician"));


})(jQuery);

