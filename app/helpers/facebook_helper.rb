module FacebookHelper
  def init_facebook_js_sdk_async
    %|
    <div id="fb-root"></div>
    <script>
      window.fbAsyncInit = function() {
        FB.init({appId: '#{Facebook::APP_ID}',
                 status: true,
                 cookie: true,
                 xfbml: true
        });

        FB.Canvas.setSize({ width: 758, height: 1000 });

        FB.getLoginStatus(function(response) {
          if (response.session) {
            facebook_login_callback(response.session);
          } else {
            facebook_didnt_login_callback(response.session);
          }
        });
      };

      (function() {
        var e = document.createElement('script');
        e.type = 'text/javascript';
        e.src = document.location.protocol +
        '//connect.facebook.net/en_US/all.js';
        e.async = true;
        document.getElementById('fb-root').appendChild(e);
      }());
    </script>
    |
  end
end
