// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
  function trigger_publish(caption, content, status_view, action){
    var attachment = {
      'media':[{'type':'image',
        'src':'http://www.badongo.com/t/a/8139580.jpg',
        'href':'http://apps.facebook.com/iwakela'}],
      'description' : status_view,
      'caption' : caption
    };
    var actionLinks = [{ "text": action, "href": "http://apps.facebook.com/iwakela"}];
    FB.Connect.streamPublish(content, attachment, actionLinks, null, 'Share your diary');
  }
