$(document).on('rails_admin.dom_ready', function(){
  var $table = $('#bulk_form').find('table');
  var table = $table[0];

  if (!table || $table.hasClass('js-horiz-scroll')) { return; }

  $table.addClass('js-horiz-scroll table-hover');

  var tableWrapper = document.createElement('DIV');
  tableWrapper.style.overflowX = 'auto';
  tableWrapper.style.marginBottom = table.style.marginBottom;
  table.style.marginBottom = '0';
  table.parentElement.insertBefore(tableWrapper, table);
  tableWrapper.appendChild(table);
  $table.find('th.last,td.last').each(function(index, td){
    var tr = td.parentElement;
    tr.insertBefore(td, tr.children[1]);
  });

  var $trs = $table.find('tr');
  var $headerTr = $trs.first();
  var $headerTds = $headerTr.children('th,td');
  var i, $td, pos;
  var offsets = [];
  var widths = [];
  for (i = 0; i < 3; i++) {
    $td = $($headerTds[i]);
    pos = $td.position();
    offsets.push(pos.left);
    widths.push($td.outerWidth());
  }
  $trs.each(function(index, tr){
    for (i = 0; i < 3; i++) {
      tr.children[i].style.position = 'absolute';
      tr.children[i].style.left = offsets[i]+'px';
      tr.children[i].style.width = widths[i]+'px';
    }
  });
  $td = $($headerTds[2]);
  var margin = $td.position().left + $td.outerWidth() - $(tableWrapper).position().left;
  tableWrapper.style.marginLeft = margin+'px';
  tableWrapper.style.borderLeft = '1px solid black';

  var trHeight = $headerTr.height();
  for (i = 0; i < 3; i++) {
    $td = $($headerTr[0].children[i]);
    $td.css('padding-top', (trHeight - $td.height() - 4)+'px');
  }

  $('body').css('overflow-x', 'hidden');
});
