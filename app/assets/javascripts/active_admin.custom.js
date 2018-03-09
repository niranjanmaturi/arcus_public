(function () {
  $(document).on("click", ".results_url", function() {
    this.select();
    try {
      document.execCommand('copy');
    } catch(err) {
    }
  });

  // accordions

  var accordionOptions = {
    collapsible: true,
    header: '> ol > .accordion-toggle',
    heightStyle: 'content',
    activate: function(event, ui) {
      if (ui.newHeader.length === 0) {
        $(this).addClass('ui-accordion-collapsed');
      }
    },
    beforeActivate: function(event, ui) {
      if (ui.newHeader.length > 0) {
        $(this).removeClass('ui-accordion-collapsed');
      }
    },
    create: function(event, ui) {
      if (ui.header.length === 0) {
        $(this).addClass('ui-accordion-collapsed');
      }
    }
  };

  $(document).on('has_many_add:after', '.has_many_container', function(e, elem, container) {
    $(elem).filter('.ui-accordion').accordion(accordionOptions);
  });

  $(document).on('ready', function() {
    $('.ui-accordion').each(function(_, elem) {
      var $elem = $(elem);
      var hasError = $elem.find('.error').length > 0;
      var startupOptions = $.extend({ active: hasError ? 0 : false }, accordionOptions);
      $elem.accordion(startupOptions);
    });
  });


  // tooltips

  var setupTooltip = function(elem) {
    var $elem = $(elem);

    if ($elem.hasClass('tooltip-registered')) {
      return;
    }
    var text = $elem.attr('arcus_tooltip');
    var tooltip = $('<div class="arcus_tooltip_trigger">i</div>').attr('tooltip_text', text);
    $elem.closest('.input').prepend(tooltip);
    $elem.addClass('tooltip-registered');
  };

  $(document).on('has_many_add:after', '.has_many_container', function(e, elem, container) {
    $(elem).find('[arcus_tooltip]').each(function(idx, elem) {
      setupTooltip(elem);
    });
  })

  $(document).on('ready', function() {
    $('[arcus_tooltip]').each(function(idx, elem) {
      setupTooltip(elem);
    });
    $(document).tooltip({
      items: '.arcus_tooltip_trigger',
      content: function() {
        return $(this).attr('tooltip_text');
      },
      position: {
        my: 'left center',
        at: 'right+10 center'
      }
    });
  });

  // databinding


  function databindContainer(container) {
    var $container = $(container);

    var belongsToThisContainer = function(_, element) {
      return $(element).closest('.has_many_fields')[0] === $container[0];
    }

    $container.find('[data-source]').filter(belongsToThisContainer).each(function(_, element) {
      var $element = $(element);
      var sourceName = $element.attr('data-source');
      var sourceElement = $container.find('[name$="[' + sourceName + ']"]').filter(belongsToThisContainer).first();
      sourceElement.on('change', function() {
        $element.text(sourceElement.val());
      });
      $element.text(sourceElement.val());
    });
  }

  $(document).on('ready', function() {
    $('.has_many_fields').each(function(_, container) {
      databindContainer(container);
    });
  });

  $(document).on('has_many_add:after', '.has_many_container', function(e, elem) {
    databindContainer(elem);
  });
})();
