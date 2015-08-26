$quality="medium";
$qualityMode="";

function changeQualityMode(){
    console.log("Quality Settings are being changed:")
    if($("#radio_ownsrcset").is(":checked"))
      $qualityMode="Quality_Screensize";
    if($("#radio_qtpt").is(":checked"))
      $qualityMode="Quality_Throughput";
    if($("#radio_qtptotf").is(":checked"))
      $qualityMode="Quality_Throughput_OTF";  
    if($("#radio_uncompressed").is(":checked"))
      $qualityMode="Quality_Manual";  
    if($("#radio_large").is(":checked"))
      $qualityMode="Quality_Manual"; 
    if($("#radio_medium").is(":checked"))
      $qualityMode="Quality_Manual"; 
    if($("#radio_small").is(":checked"))
      $qualityMode="Quality_Manual"; 
    sendLog("Changed_Quality_Mode "+$qualityMode);
    setQuality();
}

function setQuality() {
    console.log("Quality Settings are being changed:")
    if($qualityMode=="Quality_Screensize")
      setQualityByScreenSize();
    if($qualityMode=="Quality_Throughput")
      getTptBackground(); 

    //if($qualityMode=="Quality_Throughput_OTF")
    //  getTptOTF();   

    if($("#radio_uncompressed").is(":checked"))
      $quality="uncompressed";    
    if($("#radio_large").is(":checked"))
      $quality="large";
    if($("#radio_medium").is(":checked"))
      $quality="medium";
    if($("#radio_small").is(":checked"))
      $quality="small";
    if($qualityMode=="Quality_Manual"){
      sendLog("Set_New_Quality "+$quality+ " Mode "+$qualityMode);
    }
}

function setQualityByScreenSize() {
    console.log("screen.Width: "+screen.width);
    $quality="uncompressed";
    if (viewportWidth< 1536)
      $quality="large";
    if (viewportWidth< 640)
      $quality="medium";
    if (viewportWidth< 320)
      $quality="small";
    sendLog("Set_New_Quality "+$quality+ " Mode "+$qualityMode + " Width " + viewportWidth + " Height "+ viewportHeight);  
}

function getTptBackground() {
    getTpt($server+"images/1mb.jpg", 1018).then(function(speed) {
      var throughput = speed[1].toFixed(2);
      setQualityByTpt(throughput);
    }).catch(function(error) {
      console.log("getTpt Error: "+String(error));
    });
}

/**
 * Pings a url.
 * @param  {String} url
 * @param  {Number} multiplier - optional, factor to adjust the ping by.  0.3 works well for HTTP servers.
 * @return {Promise} promise that resolves to a ping (ms, float).
 */
function getTptOTF(imgUrl) {
  return new Promise(function(resolve, reject) {

    var request;
    var imgSize;
    var image;  

    request = $.ajax({
      type: "HEAD",
      url: imgUrl,
      success: function () {
        imgSize=request.getResponseHeader("Content-Length")/1000;
        console.log("Size is " + imgSize + " KB");
        console.log(request);
        getTpt(imgUrl, imgSize).then(function(retval) {
          var throughput=retval[1].toFixed(2);
          image=retval[0];
          var loadTime= retval[2];
          sendLog("Current_Quality "+$quality+ " Mode "+$qualityMode + " LoadTime: " + loadTime + " Throughput_In_KB_s " + throughput);
          if($qualityMode=="Quality_Throughput_OTF"){
            setQualityByTpt(throughput);
          }
          resolve(image);
        }).catch(function(error) {
          reject("setQualitybyTptOTF Error: "+String(error));
        });
      }
    });

    // Set a timeout for 10mins.
    var timeoutMs=600000; //ms
    var timeoutMinutes=timeoutMs/60000
    setTimeout(function() { reject(Error('Timeout: '+timeoutMinutes+'min')); }, timeoutMs);
  });
}

function setQualityByTpt(throughput){
  var quality=$quality;
  if(throughput>=3000)
    $quality="uncompressed";
  if(throughput<3000)
    $quality="large";
  if(throughput<2000)
    $quality="medium";
  if(throughput<1000)
    $quality="small";
  if (quality != $quality)
    sendLog("Set_New_Quality "+$quality+ " Mode "+$qualityMode + " Throughput_In_KB_s " + throughput);
  if (quality == $quality)
    sendLog("Quality_did_not_change "+$quality+ " Mode "+$qualityMode + " Throughput_In_KB_s " + throughput);
}