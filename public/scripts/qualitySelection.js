$quality="medium";

function setQuality() {
    console.log("Quality Settings are being changed::")
    if($("#radio_ownsrcset").is(":checked"))
      setQualityByScreenSize();
    if($("#radio_qtpt").is(":checked"))
      setQualitybyTpt();    
    if($("#radio_uncompressed").is(":checked"))
      $quality="uncompressed";    
    if($("#radio_large").is(":checked"))
      $quality="large";
    if($("#radio_medium").is(":checked"))
      $quality="medium";
    if($("#radio_small").is(":checked"))
      $quality="small";
    console.log("New Quality: "+$quality);
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
}

function setQualitybyTpt() {
    getTpt($server+"images/1mb.jpg", 1018).then(function(speed) {
      console.log("TpT: "+ speed + "KB/s");
    }).catch(function(error) {
      console.log("setQualitybyTpt Error: "+String(error));
    });  
}