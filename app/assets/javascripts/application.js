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
    // mathjax init
    MathJax = {
        tex: {
            inlineMath: [['$', '$']],
            packages: ['base', 'amsmath']
        }
    };
    // sleep 2 seconds
    setTimeout(function() {
        if ($(window).width() > 992) {
            // add expand button in top right corner of pre
            $("pre").prepend(
                "<button class='btn btn-primary border-solid--grey expand-button' \
                style='position:absolute;right:2rem;'>\
                <i class='fas fa-expand'></i></button>");
            // toggle expand on pre on click
            $("pre button.expand-button").on("click", function(e) {
                if ($(this).parent().hasClass("expanded")) {
                    $(this).parent().removeClass("expanded");
                    // reset style
                    $(this).parent().css("margin-left", "0%");
                    $(this).parent().css("min-width", "100%");
                    $(this).children().toggleClass("fa-expand fa-compress");
                    $(this).css("right", "2rem");
                } else {
                    $(this).parent().addClass("expanded");
                    $(this).parent().css("margin-left", "-40%");
                    $(this).parent().css("min-width", "180%");
                    $(this).children().toggleClass("fa-expand fa-compress");
                    $(this).css("right", "-16.250rem");
                }
            });
        }
    }, 1000);
    // scroll
    window.onscroll = function() {
        try {
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

            var percent = (height[st]||body[st]) / ((height[sh]||body[sh]) - height.clientHeight) * 100;
        
            document.getElementById('scroll-percent').textContent = Math.round(percent);
        } catch {
            // pass
        }
    };
    $('#back-to-top').on('click', function(e) {
        // safari
        document.body.scrollTop = 0;
        // chrome
        document.documentElement.scrollTop = 0;
    })

    // dark mode
    // var dark = sessionStorage.getItem('dark');
    // // no local
    // if (!dark) {
    //     // match system
    //     if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    //         $('html').addClass('dark');
    //     } else {
    //         $('html').removeClass('dark');
    //     }
    // // local
    // } else {
    //     if (dark === 'true') {
    //         $('html').addClass('dark');
    //     } else {
    //         $('html').removeClass('dark');
    //     }
    // }


    // if not already defined in local storage
    var dark_local = sessionStorage.getItem('dark');
    if (dark_local === 'true' && !$('html').hasClass('dark')) {
        $('html').addClass('dark');
    } else if (dark_local === 'false') {
        $('html').removeClass('dark');
    } else {
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            $('html').addClass('dark');
        } else {
            $('html').removeClass('dark');
        }
    }
    // watch for changes
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', event => {
        const newColorScheme = event.matches ? "dark" : "light";
        if (newColorScheme === 'dark') {
            $('html').addClass('dark');
        } else {
            $('html').removeClass('dark');
        }
    });
    // dark mode : toggle
    $('#toggle-dark-mode').on('click', function () {
        if ($('html').hasClass('dark')) {
            $('html').removeClass('dark');
            sessionStorage.setItem('dark', false);
        } else {
            $('html').addClass('dark');
            sessionStorage.setItem('dark', true);
        }
    });
    // highlight.js
    $('pre').each(function() {
        this.className = "hljs language-" + this.lang;
        hljs.configure({languages: [this.lang]});
        // hljs.highlightBlock(this);
        hljs.highlightElement(this);
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
});
