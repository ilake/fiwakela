    jQuery(document).ready(function($) {
      $jq('.record-cell').hover(
        function(){
          $jq(this).find('.record-info').show();
          $jq(this).addClass('even');
        },
        function(){
          $jq(this).find('.record-info').hide();
          $jq(this).removeClass('even');
        }
        );

      $jq('.friend-cell').hover(
        function(){
          $jq(this).addClass('even');
        },
        function(){
          $jq(this).removeClass('even');
        }
      );
    })
