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