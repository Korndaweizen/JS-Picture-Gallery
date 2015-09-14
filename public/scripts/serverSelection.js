$server="http://78.46.49.57:21210/";
$latency=9999999;
$temporalBestServer="";
$timer=null;
$timerInterval=30; //Seconds
$latencyArray=[];
$serverMode="";

$HIGHEST_THROUGHPUT="Server_Highest_Throughput";
$LOWEST_LATENCY="Server_Lowest_Latency";
$MANUAL="Server_Manual";

$servers=[];

$.get("/serverlist", function(data, status){
      $servers=data.availableServers;
      console.log("Data: " + $servers + "\nStatus: " + status);
      addManualSelectors();
}).then(function() {
  changeQualityMode();
  changeServerMode();
});     

function changeServerMode(){
    if($("#radio_htpt").is(":checked")){
      $serverMode=$Highest_Throughput;
    }
    if($("#radio_lpng").is(":checked")){
      $serverMode=$LOWEST_LATENCY;
    }
    if(!($("#radio_htpt").is(":checked")) && !($("#radio_lpng").is(":checked"))){
      $serverMode=$MANUAL;
    }
    sendServerLog("Changed_Server_Mode "+$serverMode);
    setServer();
}

function setServer() {
    clearInterval($timer);

    console.log("Server is going to be changed:")
    if($serverMode==$HIGHEST_THROUGHPUT){
      setServerByHighestTpt();
    }
    if($serverMode=="Server_Lowest_Latency"){
      setServerByLowestlatency();
      $timer = setInterval(setServerByLowestlatency, $timerInterval*1000);
    }
    if($serverMode==$MANUAL){
      setServerByHand();
    }
}
function setServerByHighestTpt() {
    console.log("Server-selection by tpt:");
    $server="http://78.46.49.57:21210/";
    sendServerLog("Set_New_Server "+$server+ " Mode "+$serverMode);    
}
function setServerByLowestlatency() {
  console.log("Server-selection by latency:");
  $latency=9999999;
  var temp=[$latency,"init"];
  getLatency(temp,-1);
}
function setServerByHand() {
  console.log("Server-selection by hand:"); //sad method.... the clean solution was not working due to some black magic -.-          
  var count=1;
  var checkup=$("input[name=serverAlgo]:checked").val().replace("server","");
  for (val of $servers) {
    if(count==checkup){
      $server="http://"+val+"/";
      sendServerLog("Set_New_Server "+$server+ " Mode "+$serverMode);
    }
    count=count+1;
  }
}

/*
 *
 *This function checks the latency of all servers and sets 
 *the server to the server with the lowest latency once it is finished.
 *
*/
function getLatency(ret, count) {
  var tmpUrl="";
  if(count >= 0){
    var tmplatency=ret[0];
    tmpUrl=ret[1].replace("images/small.bmp", "");
    $latencyArray[count]=tmplatency;
    sendServerLog("Evaluate_Server "+tmpUrl+ " Mode "+$serverMode + " Latency "+ tmplatency);
    //console.log("Server: "+tmpUrl+", latency: "+tmplatency); 
    if(tmplatency<$latency){
      $latency=tmplatency;
      $temporalBestServer=tmpUrl;
      sendServerLog("Updated_Best_Server "+tmpUrl+ " Mode "+$serverMode + " Latency "+ tmplatency); 
    } 
  }      
  count++;
  if(count < $servers.length){
    ping("http://"+$servers[count]+"/images/small.bmp").then(function(retval) {
      getLatency(retval,count);
    }).catch(function(error) {
      console.log("Error: "+ String(error));
      var errorRetval=[];
      errorRetval[1]="http://"+$servers[count]+"/";
      errorRetval[0]=9999999;
      getLatency(errorRetval,count);
    });
  }
  if(count >= $servers.length && tmpUrl != ""){
    $server=$temporalBestServer;
    sendServerLog("Set_New_Server "+$server+ " Mode "+$serverMode + " Latency "+ $latency);
  }
}

function addManualSelectors() {
  console.log("Adding all Servers to Sidebar");
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

    $("#servers").append(radio);
    $("#servers").append(label);

    var br = document.createElement("br");
    $("#servers").append(br);

    console.log(val);
    count=count+1;
  }  
}