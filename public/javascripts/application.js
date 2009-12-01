// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

  function trigger_publish(content){
    var attachment = {
      'media':[{'type':'image',
        'src':'http://s3.iconfinder.net//data/icons/twitterbirds/spritz_128.png',
        'href':'http://apps.facebook.com/iwakela'}],
      'description' : 'Come to Iwakela to wake up together',
      'caption' : 'My Diary'
    };
    var actionLinks = [{ "text": "Wake up Early", "href": "http://apps.facebook.com/iwakela"}];
    FB.Connect.streamPublish(content, attachment, actionLinks, null, 'Share your diary');
  }
