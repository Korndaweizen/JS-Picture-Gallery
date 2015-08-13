$quality="medium";
$qualityMode="";
$throughput="";

function changeQualityMode(){
    console.log("Quality Settings are being changed:")
    if($("#radio_ownsrcset").is(":checked"))
      $qualityMode="Quality_Screensize";
    if($("#radio_qtpt").is(":checked"))
      $qualityMode="Quality_Throughput";  
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
      setQualitybyTpt();    
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

function setQualitybyTpt() {
    getTpt($server+"images/1mb.jpg", 1018).then(function(speed) {
      $throughput=speed.toFixed(2);
      sendLog("Set_New_Quality "+$quality+ " Mode "+$qualityMode + " Throughput_In_KB_s " + $throughput);
    }).catch(function(error) {
      console.log("setQualitybyTpt Error: "+String(error));
    });
    
}