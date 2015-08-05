/**
 * Creates and loads an image element by url.
 * @param  {String} url
 * @return {Promise} promise that resolves to an image element or
 *                   fails to an Error.
 */
var request_image = function(url) {
    return new Promise(function(resolve, reject) {
        var img = new Image();
        img.onload = function() { resolve(img); };
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
        request_image(url).then(response).catch(response);
        
        // Set a timeout for max-pings, 5s.
        setTimeout(function() { reject(Error('Timeout')); }, 5000);
    });
};


/**
 * Tests connection speed to a server with a "/images/1mb.jpg"
 * @param  {String} url
 * @param  {Int} size - size of the image in KB 
 * @return {Promise} promise that resolves to dlSpeed (seconds, float).
 */
var getTpt = function(url, size) {
    return new Promise(function(resolve, reject) {
        var start = (new Date()).getTime();
        var response = function() { 
            var speed=0;
            speed = ((new Date()).getTime() - start);
            speed = size/speed; // speed= KB/ms
            speed *= 1000 //speed= KB/s

            resolve(speed); 
        };
        request_image(url).then(response).catch(resolve(-1));
        
        // Set a timeout for max-pings, 5s.
        setTimeout(function() { reject(Error('Timeout')); }, 5000);
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