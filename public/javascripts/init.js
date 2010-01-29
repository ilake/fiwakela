var $jq = jQuery.noConflict();  
function binding_facebox(r_id){
  $jq('#'+ r_id + ' a[rel*=facebox]').facebox();
}

function binding_hover(r_id){
  $jq('#'+ r_id).hover(
      function(){
      $jq(this).find('.record-info').show();
      $jq(this).addClass('even');
      },
      function(){
      $jq(this).find('.record-info').hide();
      $jq(this).removeClass('even');
      }
      );
}

jQuery(document).ready(function($) {
    $jq('a[rel*=facebox]').facebox();
    });

function close_facebox(){
  jQuery(document).trigger('close.facebox');
}
