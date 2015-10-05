/**
 * Creates and loads an image element by url.
 * @param  {String} url
 * @return {Promise} promise that resolves to an image element or
 *                   fails to an Error.
 */
var request_image = function(url) {
    return new Promise(function(resolve, reject) {
        var img = new Image();
        img.onload  = function() { resolve(img); };
        img.onerror = function() { reject(url); };
        img.src = url + "?pingcachebreaker="+new Date().getTime();
    });
};



/**
 * Pings a url.
 * @param  {String} url
 * @param  {Number} multiplier - optional, factor to adjust the ping by.  0.3 works well for HTTP servers.
 * @return {Promise} promise that resolves to a ping (ms, float).
 */
var ping = function(url, multiplier) {
    return new Promise(function(resolve, reject) {
        var start = (new Date()).getTime();
        var response = function() { 
            var retval=[];
            retval[0]= ((new Date()).getTime() - start);
            retval[0] *= (multiplier || 1);
            retval[1]=url;
            resolve(retval); 
        };
        var badResponse = function() { 
            var retval=[];
            retval[0]= 9999999;
            retval[0] *= (multiplier || 1);
            retval[1]=url;
            resolve(retval); 
        };        
        request_image(url).then(response).catch(badResponse);
        
        // Set a timeout for max-pings, 5s.
        setTimeout(function() { reject(Error('Timeout')); }, 5000);
    });
};


/**
 * Tests connection speed to a server with a "/images/1mb.jpg"
 * @param  {String} url
 * @param  {Int} size - size of the image in KB 
 * @return {Promise} promise that resolves to an array of img, dlSpeed (seconds, float) and loadTime.
 */
var getTpt = function(url, size) {
    return new Promise(function(resolve, reject) {
        var start = (new Date()).getTime();
        var response = function(img) { 
            var ret=[];
            var speed=0;
            var loadTime=((new Date()).getTime() - start);
            speed = size/loadTime; // speed= KB/ms
            speed *= 1000 //speed= KB/s

            ret[0]=img;
            ret[1]=speed;
            ret[2]=loadTime;

            resolve(ret); 
        };
        request_image(url).then(response).catch(function(){resolve(-1);});
        
        // Set a timeout for max-pings, 10min.
        setTimeout(function() { reject(Error('Timeout')); }, 600000);
    });
};



function getAllLatencies(ret, count) {
  console.log("Server: "+ret[1]+", latency: "+ret[0]); 
  if(count >= 0){
    var tmplatency=ret[0];
    var tmpUrl=ret[1];
    $latencyArray[count]=tmplatency;
    console.log("Server: "+tmpUrl.replace("images/small.bmp", "")+", latency: "+tmplatency); 
  }      
  count++;
  if(count < $servers.length){
    ping("http://"+$servers[count]+"/images/small.bmp").then(function(retval) {
      getLatency(retval,count);
    }).catch(function(error) {
      console.log(String(error));
    });
  }
}