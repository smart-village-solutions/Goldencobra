//Notifications
function notify(title,body,token) {
    // check for notification compatibility
    if(!window.Notification) {
        // if browser version is unsupported, be silent
        return;
    }
    // log current permission level
    console.log(Notification.permissionLevel());
    // if the user has not been asked to grant or deny notifications from this domain
    if(Notification.permissionLevel() === 'default') {
        Notification.requestPermission(function() {
            // callback this function once a permission level has been set
            notify();
        });
    }
    // if the user has granted permission for this domain to send notifications
    else if(Notification.permissionLevel() === 'granted') {
        var n = new Notification(
                    title,
                    { 'body': body,
                      // prevent duplicate notifications
                      'tag' : token,
                      'onclick': function(){
                        console.log("notification clicked");
                      },
                      // callback function when the notification is closed
                      'onclose': function() {
                           console.log('notification closed');
                       }
                    }
                );
    }
    // if the user does not want notifications to come from this domain
    else if(Notification.permissionLevel() === 'denied') {
      // be silent
      return;
    }
}