function initPaginationLinks() {
  // if index page
  if ($('#index_footer').length) {
    $('.paginated_collection_contents').before(
      // create index_header element and clone index_footer elements into it
      $('<div/>', { id: 'index_header' }).append(
        $('#index_footer .pagination_per_page').clone()
      ).append(
        $('#index_footer .pagination').clone()
      ).append(
        $('#index_footer .pagination_information').clone()
      )
    );

    // trigger footer per_page on changing cloned header per_page
    $('#index_header .pagination_per_page select').on('change', function () {
      $('#index_footer .pagination_per_page select').val($(this).val()).change();
    });
  }
}

function moveBatchActionsIndexHeader() {
  if ($('.batch_actions_selector').length) {
    if ($('#index_header').length) {
      $('#index_header').append($('.batch_actions_selector'));
    }
  }
}
