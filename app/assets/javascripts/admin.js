$(document).ready(function() {

  $('#check_box_is_hit').change(function(e){
    e.preventDefault();
    var form = $('#is_hit_form');
    var form_data = form.serialize();
    var form_url = form.attr('action')

    if ($(this).is(":checked")) {
      form_data = form_data+"&is_hit=true" 
    } else {
      form_data = form_data+"&is_hit=false" 
    }

  $.ajax({
    type:"PUT",
    url: form_url,
    data: form_data,
  })
  .done(function(data) {
    console.log(data);
  })
  .fail(function(jqXHR, textStatus) {
    console.log(textStatus);
  });
  });

});
