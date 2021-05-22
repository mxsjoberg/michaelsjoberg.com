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

    // highlight
    // document.addEventListener('DOMContentLoaded', (event) => {
    //   document.querySelectorAll('pre').forEach((block) => {
    //     hljs.highlightBlock(block);
    //   });
    // });
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

    // $('a[data-toggle="popover"]').popover();

    $('a[data-toggle="popover"]').popover({
        trigger: 'focus'
    });

    // reload twitter button
    //twttr.widgets.load();

    // toggle icons
    // $('#navbar-navigation').on('hidden.bs.collapse', function () {
    //     $('button[data-target="#navbar-navigation"] i').removeClass('fa-caret-down').addClass('fa-caret-right');
    // });
    // $('#navbar-navigation').on('show.bs.collapse', function () {
    //     $('button[data-target="#navbar-navigation"] i').removeClass('fa-caret-right').addClass('fa-caret-down');
    // });
    // $('#navbar-footer').on('hidden.bs.collapse', function () {
    //     $('button[data-target="#navbar-footer"] i').removeClass('fa-caret-down').addClass('fa-caret-right');
    // });
    // $('#navbar-footer').on('show.bs.collapse', function () {
    //     $('button[data-target="#navbar-footer"] i').removeClass('fa-caret-right').addClass('fa-caret-down');
    // });
    $('#mobile-navigation').on('show.bs.modal', function () {
        $('button#modal-mobile-navigation i').removeClass('fa-bars').addClass('fa-times');
    });
    $('#mobile-navigation').on('hidden.bs.modal', function () {
        $('button#modal-mobile-navigation i').removeClass('fa-times').addClass('fa-bars');
    });
});
