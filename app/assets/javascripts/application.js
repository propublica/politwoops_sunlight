$(document).ready(function() {
  $("a.screenshot").each(function(idx, a){
    $(a).colorbox({
      rel: 'screenshot' + idx,
    opacity: 0.7,
    maxWidth: '90%',
    close: 'Close'
    });
  });

  $(document).bind('cbox_complete', function(event){
    $("img.cboxPhoto").click(function(event){
      window.open($(this).attr('src'));
    });
  });

  $('form > .filter .dropdown ul li a').on('click', function() {
    valueSelected = $(this).text().trim();
    inputToUse = $(this).parent('li').parent('ul').attr('aria-labelledby')
    $('input[name=' + inputToUse + ']').attr('value', valueSelected)
    form = $(this).parentsUntil('form').parent();
    form.submit();
  })
});
