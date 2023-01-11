//= require arctic_admin/base
//= require chartkick
//= require Chart.bundle
//= require Sortable.min.js

$(document).ready(function () {
  $('.ad-option-types-sortable-list').each(function () {
    Sortable.create(this, {animation: 150, onSort: reorderAOT})
  });

  $('.filterable-values-groups-sortable-list').each(function () {
    Sortable.create(this, {animation: 150, onSort: reorderFVG})
  });

  $('.filterable-values-list').each(function () {
    Sortable.create(this, {
      group: $(this).data('group-name'),
      sort: false,
      animation: 150,
      onRemove: updateFVGroup,
    })
  });

  $('.option-values-list-invisible').each(function () {
    Sortable.create(this, {
      group: { name: $(this).data('group-name'), put: false },
      sort: false,
      animation: 150,
      onRemove: createFVFromInvisible,
    });
  });

  $(document).on('dblclick', '.raw_value', deleteFV);
});


function reorderFVG(e) {
  const getName = function() { return $(this).text() }
  const names = $(e.item).parent().find('.filterable-node').map(getName).get();
  
  $.ajax({
    url: '/admin/filterable_values_groups/reorder.json',
    method: 'POST',
    data: JSON.stringify({ names }),
    contentType: 'application/json',
  });
}

function reorderAOT(e) {
  const getName = function() { return $(this).text() }
  const names = $(e.item).parent().find('.filterable-node').map(getName).get();
  
  $.ajax({
    url: '/admin/ad_option_types/reorder.json',
    method: 'POST',
    data: JSON.stringify({ names }),
    contentType: 'application/json',
  });
}

const deleteFV = (e) => {
  const fvId = $(e.target).data('fv-id');

  $.ajax({
    url: `/admin/filterable_values/${fvId}.json`,
    method: 'DELETE',
    contentType: 'application/json',
    success: function () {
      $(e.target).remove();
    }
  })
}

const createFVFromInvisible = (e) => {
  const groupName = $(e.to).data('name');
  const optId = $(e.to).data('opt-id');
  const raw_value = $(e.item).text();
  const data = JSON.stringify({ filterable_value: { name: groupName, ad_option_type_id: optId, raw_value: raw_value} });

  $.ajax({
    url: '/admin/filterable_values.json',
    method: 'POST',
    data: data,
    contentType: 'application/json',
    success: (data) => {
      $(e.item).data('fv-id', data.id);
      $(e.item).removeClass('invisible');
    }
  });
}

const updateFVGroup = (e) => {
  const groupName = $(e.to).data('name');
  const fvId = $(e.item).data('fv-id');
  const data = JSON.stringify({ filterable_value: { name: groupName } });

  $.ajax({
    url: `/admin/filterable_values/${fvId}.json`,
    method: 'PUT',
    data: data,
    contentType: 'application/json',
  });

}