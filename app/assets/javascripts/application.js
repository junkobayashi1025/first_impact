// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery/dist/jquery.js
//= require bootstrap/dist/js/bootstrap.min
//= require_tree .

$(function(){
  //オーバーレイとコンテンツの表示
  $(".modal-open").click(function(){
    $(this).blur() ; //ボタンからフォーカスを外す
    if($( ".modal-overlay")[0]) return false; //新たにオーバーレイが追加されるのを防ぐ
    $("body").append('<div class="modal-overlay"></div>'); //オーバーレイ用のHTMLをbody内に追加
    $(".modal-overlay").fadeIn("slow"); //オーバーレイの表示
    $(".modal").fadeIn("slow"); //モーダルウインドウの表示

    //モーダルウインドウの終了
    $(".modal-overlay,.modal-close").unbind().click(function(){
      $( ".modal,.modal-overlay" ).fadeOut( "slow" , function(){ //閉じるボタンかオーバーレイ部分クリックでフェードアウト
        $('.modal-overlay').remove(); //フェードアウト後、オーバーレイをHTMLから削除
      });
    });
  });
});
