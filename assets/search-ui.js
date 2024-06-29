// Methods and jQuery UI for Wax search box
function excerptedString(str) {
  str = str || ''; // handle null > string
  if (str.length < 40) {
    return str;
  }
  else {
    return `${str.substring(0, 40)} ...`;
  }
}

function getThumbnail(item, url) {
  if ('thumbnail' in item) {
    return `<img class='sq-thumb-sm' src='${url}${item.thumbnail}'/>&nbsp;&nbsp;&nbsp;`
  }
  else {
    return '';
  }
}

function displayResult(item, fields, url) {
  var pid   = item.pid;
  var label = item.label || 'Untitled';
  var link  = item.permalink;
  var thumb = getThumbnail(item, url);
  var meta  = []

  for (i in fields) {
    fieldLabel = fields[i];
    if (fieldLabel in item ) {
      meta.push(`<b>${fieldLabel}:</b> ${excerptedString(item[fieldLabel])}`);
    }
  }
  return `<div class="result"><a href="${url}${link}">${thumb}<p><span class="title">${item.label}</span><br><span class="meta">${meta.join(' | ')}</span></p></a></div>`;
}

function startSearchUI(fields, indexFile, url) {
  $.getJSON(indexFile, function(store) {
    document.querySelector("#loader-wrapper").style.display= "none";

    var index  = new elasticlunr.Index;

    index.saveDocument(false);
    index.setRef('lunr_id');

    for (i in fields) { index.addField(fields[i]); }
    for (i in store)  { index.addDoc(store[i]); }

    const search_button = document.getElementById("search-button");
    search_button.addEventListener('click', do_search);

    const search_field = document.getElementById("search");
    search_field.addEventListener('keydown', function(event) {
      if (event.key === 'Enter') {
        do_search(event);
      }
    });

    function do_search(event) {
      var results_div = $('#results');
      var query       = document.getElementById("search").value;
      var results     = index.search(query, { bool: 'AND', expand: true });

      results_div.empty();
      results_div.append(`<p class="results-info">Displaying ${results.length} results</p>`);

      var items = [];
      for (var r in results) {
        var ref    = results[r].ref;
        var item   = store[ref];
        items.push(item);
      }

      // Sort by PID, ignoring ranking score
      items.sort((a, b) => a.pid.localeCompare(b.pid));
      for (var i in items) {
        var result = displayResult(items[i], fields, url);

        results_div.append(result);
      }
    }
  });
}
