$server="http://78.46.49.57:21210/";
$ping=9999999;
$temporalBestServer="";

function setServer() {
    console.log("Server Settings are being changed:")
    if($("#radio_htpt").is(":checked"))
      setServerByHighestTpt();
    if($("#radio_lpng").is(":checked"))
      setServerByLowestPing();
    if(!($("#radio_htpt").is(":checked")) && !($("#radio_lpng").is(":checked")))
    {
      /*
      {
        console.log("Server-selection by hand:");
        var count=1;
        for (val of $servers) {
          var replaced = val.replace(":", "_");
          replaced = replaced.replace(".", "_");
          console.log("Server_"+count+": "+replaced+ $("#radio_"+replaced).is(":checked"));
          count=count+1;
          if($("#radio_"+replaced).is(":checked")){
            console.log("Setting server!!! Yeah i am the if")
            $server="http://"+val+"/";
          }
        }
      }
      */
      console.log("Server-selection by hand:"); //sad method.... the nice one (above) is not working due to some black magic -.-          
      var count=1;
      var checkup=$("input[name=serverAlgo]:checked").val().replace("server","");
      for (val of $servers) {
        if(count==checkup){
          console.log("Setting server!!! Yeah i am the if")
          $server="http://"+val+"/";
        }
        count=count+1;
      }
    }
    console.log('New Server: '+$server);
}
function setServerByHighestTpt() {
    console.log("Server-selection by tpt:");
    $server="http://78.46.49.57:21210/";
}
function setServerByLowestPing() {
  console.log("Server-selection by ping:");
  $ping=9999999;
  var temp=[$ping,"init"];
  pingQueue(temp,-1);
}
/*
function setServerByLowestPing() {
  console.log("Server-selection by ping:");
  for (val of $servers) {
    var serverurl= "http://"+val;
    ping(serverurl).then(function(retval) {
        console.log("Server: "+retval[1]+", Ping: "+retval[0]);
    }).catch(function(error) {
        console.log(String(error));
    });
  }
}
*/
function pingQueue(ret, count) {
  console.log("Server: "+ret[1]+", Ping: "+ret[0]); 
  if(count >= 0){
    var tmpPing=ret[0];
    var tmpUrl=ret[1];
    console.log("Server: "+tmpUrl+", Ping: "+tmpPing); 
    if(tmpPing<$ping){
      $ping=tmpPing;
      $temporalBestServer=tmpUrl;
      console.log("Updated best Server"); 
    } 
  }      
  count++;
  if(count < $servers.length){
    ping("http://"+$servers[count]+"/").then(function(retval) {
      pingQueue(retval,count);
    }).catch(function(error) {
      console.log(String(error));
    });
  }
  if(count >= $servers.length && tmpUrl != ""){
    $server=$temporalBestServer;
    console.log("Set Server to: "+$server);
  }
}

function addManualSelectors() {
  var count=0;   
  for (val of $servers) {
    var temp=count+1;
    var radio = document.createElement("input");
    radio.setAttribute('type', 'radio');
    radio.setAttribute('value', 'server'+temp);
    radio.setAttribute('name', 'serverAlgo');

    var replaced = val.replace(":", "_");
    replaced = replaced.replace(".", "_");
    radio.setAttribute('id', "radio_"+replaced);

    var label = document.createElement("label");
    label.setAttribute("for",replaced);
    label.innerHTML = "&nbsp"+"Server: "+temp;

    var br = document.createElement("br");

    $("#servers").append(br);
    $("#servers").append(radio);
    $("#servers").append(label);
    
    console.log(val);
    count=count+1;
  }  
}