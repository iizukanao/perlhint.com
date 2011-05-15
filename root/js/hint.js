$(function(){
    $('div.code .syn').each(function(){
        if (!/syn_(\S+)/.test(this.className)) {
            return;
        }
        var name = RegExp.$1;
        $(this).tooltip({
            effect: 'fade',
            position: 'center right',
            fadeInSpeed: 80,
            fadeOutSpeed: 120,
            opacity: 0.75,
            tip: '#tip_' + name
        });
    });
});
