Spree.ready ($) ->
  $('#custom-plan-set').on 'change', '.day-plan-select', (event) ->
    $(this).closest('td').addClass('present')

  $('#custom-plan-set .day-plan-select').each (index, element) ->
    if $(element).val()
      $(this).closest('td').addClass('present')