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
//= require jquery
//= require popper
//= require bootstrap-sprockets
//= require_tree .

$(document).on('turbolinks:load', function() {
    // scroll
    window.onscroll = function() {
        // back to top
        var scrollLimit = 600;
        if (window.scrollY >= scrollLimit) {
            $('#back-to-top').removeClass('d-none');
            $('#scroll-percent-wrapper').removeClass('d-none');
        } else {
            if (!$('#back-to-top').hasClass('d-none')) {
                $('#back-to-top').addClass('d-none');
            }
            if (!$('#scroll-percent-wrapper').hasClass('d-none')) {
                $('#scroll-percent-wrapper').addClass('d-none');
            }
        }
        // percent
        var height = document.documentElement, 
            body = document.body,
            st = 'scrollTop',
            sh = 'scrollHeight';

        var percent = (height[st]||body[st]) / ((height[sh] - 100||body[sh]) - height.clientHeight) * 100;
    
        document.getElementById('scroll-percent').textContent = Math.round(percent);
    };
    $('#back-to-top').on('click', function(e) {
        // safari
        document.body.scrollTop = 0;
        // chrome
        document.documentElement.scrollTop = 0;
    })

    // dark mode
    var dark = localStorage.getItem('dark');
    if (dark === 'true') {
        $('html').addClass('dark');
        // icon
        // $('#toggle-dark-mode i').removeClass('fa-moon').addClass('fa-sun');
    }

    // highlight.js
    $('pre').each(function() {
        hljs.highlightBlock(this);
    });

    // initialize search
    $('#search').hideseek({
        // attribute: 'text',
        // ignore: '.search-ignore',
        // highlight: true
        headers: '.list_header'
    });

    $('a[data-toggle="popover"]').on('click', function(e) {
        e.preventDefault();
    })

    $('a[data-toggle="popover"]').popover({
        trigger: 'focus'
    });

    $('#mobile-navigation').on('show.bs.modal', function () {
        $('button#modal-mobile-navigation i').removeClass('fa-bars').addClass('fa-times');
    });
    $('#mobile-navigation').on('hidden.bs.modal', function () {
        $('button#modal-mobile-navigation i').removeClass('fa-times').addClass('fa-bars');
    });

    $('#toggle-dark-mode').on('click', function () {
        if ($('html').hasClass('dark')) {
            $('html').removeClass('dark');
            // localStorage
            localStorage.setItem('dark', false);
            // icon
            // $('#toggle-dark-mode i').removeClass('fa-sun').addClass('fa-moon');
        } else {
            $('html').addClass('dark');
            localStorage.setItem('dark', true);
            // icon
            // $('#toggle-dark-mode i').removeClass('fa-moon').addClass('fa-sun');
        }
    });
});
