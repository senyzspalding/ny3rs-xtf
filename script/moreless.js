$(document).ready(function () {
    $('span.more').hide();
    $('.btn.less').hide();
    
    $('.btn.more').click(function () {
        $(this).parent().children('span.more').show();
        $(this).parent().children('.btn.less').show();
        $(this).hide();
    });
    $('.btn.less').click(function () {
        $(this).parent().children('span.more').hide();
        $(this).parent().children('.btn.more').show();
        $(this).hide();
    });
});