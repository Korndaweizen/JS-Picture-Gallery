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
    if($("#radio_xlarge").is(":checked"))
      $qualityMode="Quality_Manual"; 
    if($("#radio_medium").is(":checked"))
      $qualityMode="Quality_Manual"; 
    if($("#radio_small").is(":checked"))
      $qualityMode="Quality_Manual"; 
    sendQualityLog("Changed_Quality_Mode "+$qualityMode + " ServerIP " + $server);
    setQuality();
};

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
    if($("#radio_xlarge").is(":checked"))
      $quality="xlarge";
    if($("#radio_large").is(":checked"))
      $quality="large";
    if($("#radio_medium").is(":checked"))
      $quality="medium";
    if($("#radio_small").is(":checked"))
      $quality="small";
    if($qualityMode=="Quality_Manual"){
      sendQualityLog("Set_New_Quality "+$quality+ " Mode "+$qualityMode + " ServerIP " + $server);
    }
};

function setQualityByScreenSize() {
    console.log("screen.Width: "+screen.width);
    $quality="uncompressed";
    if (viewportWidth<= 2048)
      $quality="xlarge";
    if (viewportWidth<= 1024)
      $quality="large";
    if (viewportWidth<= 640)
      $quality="medium";
    if (viewportWidth<= 320)
      $quality="small";
    sendQualityLog("Set_New_Quality "+$quality+ " Mode "+$qualityMode + " Width " + viewportWidth + " Height "+ viewportHeight + " ServerIP " + $server);  
};

function getTptBackground() {
    getTpt($server+"images/1mb.jpg", 1018).then(function(speed) {
      var throughput = speed[1].toFixed(2);
      setQualityByTpt(throughput);
    }).catch(function(error) {
      console.log("getTpt Error: "+String(error));
    });
};

/**
 * Pings a url.
 * @param  {String} url
 * @param  {Number} multiplier - optional, factor to adjust the ping by.  0.3 works well for HTTP servers.
 * @return {Promise} promise that resolves to a ping (ms, float).
 */
function getTptOTF(imgUrl,imgNo) {
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
          sendQualityLog("Current_Quality "+$quality+ " Mode "+$qualityMode + " LoadTime: " + loadTime + " ImgSize: " + request.getResponseHeader("Content-Length") + " Throughput_In_KB_s " + throughput + " Picture: " + imgNo +" ServerIP " + $server);
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
};

function setQualityByTpt(throughput){
  var quality=$quality;
  //if(throughput!=3000)
    $quality="uncompressed";
  if(throughput<1500)
    $quality="xlarge";
  if(throughput<500)
    $quality="large";
  if(throughput<300)
    $quality="medium";
  if(throughput<100)
    $quality="small";
  if (quality != $quality)
    sendQualityLog("Set_New_Quality "+$quality+ " Mode "+$qualityMode + " Throughput_In_KB_s " + throughput + " ServerIP " + $server);
  if (quality == $quality)
    sendQualityLog("Quality_did_not_change "+$quality+ " Mode "+$qualityMode + " Throughput_In_KB_s " + throughput + " ServerIP " + $server);
};