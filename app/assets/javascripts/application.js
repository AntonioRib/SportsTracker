// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs

//= require turbolinks
//= require_tree .


$(document).ready(function(){
    var $toggleSidebar = $('.toggleSidebar'),
        $sidebar = $('.sidebar'),
        sidebarToggled = false;

    $toggleSidebar.click(function(){
        if(!sidebarToggled){
            $sidebar.addClass('animated bounceOutLeft');
            setTimeout(function(){
                $sidebar.css('width', '0px');
                $('.screenestate').css('width', '100%');
                sidebarToggled = true;
            }, 500);
        }else{
            $sidebar.css('width', '20%');
            $('.screenestate').css('width', '80%');
            sidebarToggled = false;
            $sidebar.removeClass('animated bounceOutLeft');
            $sidebar.addClass('animated bounceInleft');
        }

    });
});

$(document).ready(function() {
    var $btnSets = $('#responsive'),
        $btnLinks = $btnSets.find('a');

    $btnLinks.click(function(e) {
        e.preventDefault();
        $(this).siblings('a.active').removeClass("active");
        $(this).addClass("active");
        var index = $(this).index();
        $("div.user-menu>div.user-menu-content").removeClass("active");
        $("div.user-menu>div.user-menu-content").eq(index).addClass("active");
    });
});

$( document ).ready(function() {
    $("[rel='tooltip']").tooltip();

    $('.view').hover(
        function(){
            $(this).find('.caption').slideDown(250); //.fadeIn(250)
        },
        function(){
            $(this).find('.caption').slideUp(250); //.fadeOut(205)
        }
    );
});



