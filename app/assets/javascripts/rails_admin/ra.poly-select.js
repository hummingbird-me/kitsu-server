(function($) {
  $.widget("ra.polySelect", {
    options: {
      createQuery: function(query) {
        return { query: query };
      },
      minLength: 0,
      searchDelay: 200,
      remote_source: null,
      source: null,
      float_left: true,
      xhr: true
    },

    _create: function() {
      var self = this,
        select = this.element.hide(),
        selected = select.children(":selected"),
        value = selected.val() ? selected.text() : "";

      if (this.options.xhr) {
        this.options.source = this.options.remote_source;
      } else {
        this.options.source = select.children("option").map(function() {
          return { label: $(this).text(), value: this.value };
        }).toArray();
      }

      var float_style;
      if (this.options.float_left) {
        float_style = "left";
      } else {
        float_style = "none";
      }
      var poly_select = $('<div class="input-group filtering-select col-sm-2" style="float: ' + float_style + ' "></div>');

      var input = this.input = $('<input type="text">')
        .val(value)
        .addClass("form-control ra-filtering-select-input")
        .attr('style', select.attr('style'))
        .show()
        .autocomplete({
          delay: this.options.searchDelay,
          minLength: this.options.minLength,
          source: this._getSourceFunction(this.options.source),
          select: function(event, ui) {
            var option = $('<option></option>').attr('value', ui.item.id).attr('selected', 'selected').text(ui.item.value);
            select.html(option);
            select.trigger("change", ui.item.id);
            self._trigger("selected", event, {
              item: option
            });
            $(self.element.parents('.controls')[0]).find('.update').removeClass('disabled');
          },
          change: function(event, ui) {
            if (!ui.item) {
              var matcher = new RegExp("^" + $.ui.autocomplete.escapeRegex($(this).val()) + "$", "i"),
                  valid = false;
              select.children("option").each(function() {
                if ($(this).text().match(matcher)) {
                  this.selected = valid = true;
                  return false;
                }
              });
              if (!valid || $(this).val() === '') {
                $(this).val(null);
                select.html($('<option value="" selected="selected"></option>'));
                input.data("ui-autocomplete").term = "";
                $(self.element.parents('.controls')[0]).find('.update').addClass('disabled');
                return false;
              }
            }
          }
        })
        .keyup(function() {
          if ($(this).val().length === 0) {
            select.html($('<option value="" selected="selected"></option>'));
            select.trigger("change");
          }
        });

      if(select.attr('placeholder'))
        input.attr('placeholder', select.attr('placeholder'));

      input.data("ui-autocomplete")._renderItem = function(ul, item) {
        return $("<li></li>")
          .data("ui-autocomplete-item", item)
          .append( $( "<a></a>" ).html( item.html || item.id ) )
          .appendTo(ul);
      };

      var button = this.button = $('<span class="input-group-btn"><label class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-expanded="false" title="Show All Items" role="button"><span class="caret"></span><span class="ui-button-text">&nbsp;</span></label></span>')
        .click(function() {
          if (input.autocomplete("widget").is(":visible")) {
            input.autocomplete("close");
            return;
          }
          input.autocomplete("search", "");
          input.focus();
        });

      poly_select.append(input).append(button).insertAfter(select);
    },

    _getResultSet: function(request, data, xhr) {
      var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
      var highlighter = function(label, word){
        if(word.length > 0){
          return $.map(label.split(word), function(el, i){
            return $('<span></span>').text(el).html();
          }).join($('<strong></strong>').text(word)[0].outerHTML);
        }else{
          return $('<span></span>').text(label).html();
        }
      };

      return $.map(data, function(el, i) {
        if ((el.id || el.value) && (xhr || matcher.test(el.label))) {
          return {
            html: highlighter(el.label || el.id, request.term),
            value: el.label || el.id,
            id: el.id || el.value
          };
        }
      });
    },

    _getSourceFunction: function(source) {
      var self = this,
          requestIndex = 0;
      if ($.isArray(source)) {
        return function(request, response) {
          response(self._getResultSet(request, source, false));
        };
      } else if (typeof source === "string") {
        return function(request, response) {
          if (this.xhr) {
            this.xhr.abort();
          }

          this.xhr = $.ajax({
            url: source,
            data: self.options.createQuery(request.term),
            dataType: "json",
            autocompleteRequest: ++requestIndex,
            success: function(data, status) {
              if (this.autocompleteRequest === requestIndex) {
                response(self._getResultSet(request, data, true));
              }
            },
            error: function() {
              if (this.autocompleteRequest === requestIndex) {
                response([]);
              }
            }
          });
        };
      } else {
        return source;
      }
    },

    destroy: function() {
      this.input.remove();
      this.button.remove();
      this.element.show();
      $.Widget.prototype.destroy.call(this);
    }
  });
})(jQuery);
