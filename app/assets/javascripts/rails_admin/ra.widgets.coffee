$(document).on 'rails_admin.dom_ready', (e, content) ->

  content = if content then content else $('form')

  if content.length

    # datetime picker

    $.fn.datetimepicker.defaults.icons =
      time:     'fa fa-clock-o'
      date:     'fa fa-calendar'
      up:       'fa fa-chevron-up'
      down:     'fa fa-chevron-down'
      previous: 'fa fa-angle-double-left'
      next:     'fa fa-angle-double-right'
      today:    'fa fa-dot-circle-o'
      clear:    'fa fa-trash'
      close:    'fa fa-times'

    content.find('[data-datetimepicker]').each ->
      options = $(this).data('options')
      $.extend(options, {locale: RailsAdmin.I18n.locale})
      $(this).datetimepicker options

    # enumeration

    content.find('[data-enumeration]').each ->
      if $(this).is('[multiple]')
        $(this).filteringMultiselect $(this).data('options')
      else
        $(this).filteringSelect $(this).data('options')

    # fileupload

    content.find('[data-fileupload]').each ->
      input = this
      $(this).on 'click', ".delete input[type='checkbox']", ->
        $(input).children('.toggle').toggle('slow')

    # fileupload-preview

    content.find('[data-fileupload]').change ->
      input = this
      image_container = $("#" + input.id).parent().children(".preview")
      unless image_container.length
        image_container = $("#" + input.id).parent().prepend($('<img />')
          .addClass('preview').addClass('img-thumbnail')).find('img.preview')
        image_container.parent().find('img:not(.preview)').hide()
      ext = $("#" + input.id).val().split('.').pop().toLowerCase()
      if input.files and input.files[0] and
          $.inArray(ext, ['gif','png','jpg','jpeg','bmp']) != -1
        reader = new FileReader()
        reader.onload = (e) ->
          image_container.attr "src", e.target.result
        reader.readAsDataURL input.files[0]
        image_container.show()
      else
        image_container.hide()

    # filtering-multiselect

    content.find('[data-filteringmultiselect]').each ->
      $(this).filteringMultiselect $(this).data('options')
      if $(this).parents("#modal").length
        $(this).siblings('.btn').remove()
      else
        $(this).parents('.control-group').first().remoteForm()

    # filtering-select

    content.find('[data-filteringselect]').each ->
      $(this).filteringSelect $(this).data('options')
      if $(this).parents("#modal").length
        $(this).siblings('.btn').remove()
      else
        $(this).parents('.control-group').first().remoteForm()

    # poly-select

    content.find('[data-polyselect]').each ->
      $(this).polySelect $(this).data('options')
      $(this).parents('.control-group').first().remoteForm()

    # nested-many

    content.find('[data-nestedmany]').each ->
      field = $(this).parents('.control-group').first()
      nav = field.find('> .controls > .nav')
      tab_content = field.find('> .tab-content')
      toggler = field.find('> .controls > .btn-group > .toggler')
      tab_content.children('.fields:not(.tab-pane)')
          .addClass('tab-pane').each ->
        $(this).attr('id', 'unique-id-' + (new Date().getTime()) +
          Math.floor(Math.random()*100000))
        nav.append('<li><a data-toggle="tab" href="#' + this.id + '">' +
          $(this).children('.object-infos').data('object-label') + '</a></li>')
      if nav.find("> li.active").length == 0
        nav.find("> li > a[data-toggle='tab']:first").tab('show')
      if nav.children().length == 0
        nav.hide()
        tab_content.hide()
        toggler.addClass('disabled').removeClass('active')
          .children('i').addClass('icon-chevron-right')
      else
        if toggler.hasClass('active')
          nav.show()
          tab_content.show()
          toggler.children('i').addClass('icon-chevron-down')
        else
          nav.hide()
          tab_content.hide()
          toggler.children('i').addClass('icon-chevron-right')

    # nested-one

    content.find('[data-nestedone]').each ->
      field = $(this).parents('.control-group').first()
      nav = field.find("> .controls > .nav")
      tab_content = field.find("> .tab-content")
      toggler = field.find('> .controls > .btn-group > .toggler')
      tab_content.children(".fields:not(.tab-pane)")
          .addClass('tab-pane active').each ->
        field.find('> .controls .add_nested_fields')
          .removeClass('add_nested_fields')
          .html( $(this).children('.object-infos').data('object-label') )
        nav.append('<li><a data-toggle="tab" href="#' + this.id + '">' +
          $(this).children('.object-infos').data('object-label') + '</a></li>')
      first_tab = nav.find("> li > a[data-toggle='tab']:first")
      first_tab.tab('show')
      field.find("> .controls > [data-target]:first")
        .html('<i class="icon-white"></i> ' + first_tab.html())
      nav.hide()
      if nav.children().length == 0
        nav.hide()
        tab_content.hide()
        toggler.addClass('disabled').removeClass('active').children('i')
          .addClass('icon-chevron-right')
      else
        if toggler.hasClass('active')
          toggler.children('i').addClass('icon-chevron-down')
          tab_content.show()
        else
          toggler.children('i').addClass('icon-chevron-right')
          tab_content.hide()

    # polymorphic-association

    content.find('[data-polymorphic]').each ->
      type_select = $(this)
      field = type_select.parents('.control-group').first()
      object_select = field.find('select').last()
      urls = type_select.data('urls')

      type_select.on 'change', (e) ->
        object_select.data('options',
          $("##{type_select.val().toLowerCase()}-js-options").data('options'))
        object_select.polySelect("destroy")
        object_select.polySelect object_select.data('options')

        if $(this).val() is ''
          object_select.html('<option value=""></option>')
        else
          $.ajax
            url: urls[type_select.val()]
            data:
              compact: true
            beforeSend: (xhr) ->
              xhr.setRequestHeader("Accept", "application/json")
            success: (data, status, xhr) ->
              html = $('<option></option>')
              $(data).each (i, el) ->
                option = $('<option></option>')
                option.attr('value', el.id)
                option.text(el.label)
                html = html.add(option)
              object_select.html(html)
