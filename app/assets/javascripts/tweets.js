var paginated = true;
var pagination = true;

var clear_form = function() {
  $('textarea#tweet_content').val("");
  $('.characters').text("140");
  return true;
}

var show_stream_button = function(number) {
    $('.stream').slideDown("Slow");
    $('.stream p').text(number + ' new tweets');
}

var hide_stream_button = function() {
  if ($('.stream').css('display') != 'none') {
    $('.stream').css('display', 'none');
    $('.stream p').text('0 new tweets');
  }
 }

var check_tweets_in_feed = function() {
  $('#tweets').ready(function() {
    if ($('.tweet').length <= 10) {
      get_next_tweets_by_id($('.tweet:last').attr('data-tweet-id'), 1);
    }
  });
};


var scrollMethod = function(div, length, method) {
  $(document).ready(function() {
    if ($(div).length >= length) {
      $(window).scroll(function() {
        var offset = ($(document).height() - $(window).height()) - (($(document).height() - $(window).height()) / 8)
        if ($(this).scrollTop() >= offset) {
          if (paginated == true && pagination == true) {
            paginated = false;
            method();
          };
        }
      });
    }
  });
}

var borderColor = function() {
  var mouseoverSelection = function(div) {
    $(div).live('mouseover', function() {
      $(this).css("border-bottom", "1px solid rgba(204, 51, 102, 0.30)");
      $(this).find('.timestamp, .row a').css('color', '#C36');
      $(this).prev().css("border-bottom", "1px solid rgba(204, 51, 102, 0.30)");
    });
  };
  var mouseoutSelection = function(div) {
    $(div).live('mouseout', function() {
      $(this).find('.row a').css('color', "#333");
      $(this).find('.timestamp').css('color', "grey")
      $(this).css("border-bottom", "1px solid #E6E6E6");
      $(this).prev().css("border-bottom", "1px solid #E6E6E6");
    });
  };
  var hoverEffect = function(div) {
    mouseoverSelection(div);
    mouseoutSelection(div);
  };
  hoverEffect('#feed .tweet');
  hoverEffect('#feed .user');
};

var friendshipButton = function() {
  $('.btn-unfollow').live('mouseover', function(){
    $(this).text("Unfollow");
  });
  $('.btn-unfollow').live('mouseout', function(){
    $(this).text("Following");
  });
};

$(document).ready(function(){
  friendshipButton();
})

$("#tweets, #users").ready(function() {
  borderColor();
});
