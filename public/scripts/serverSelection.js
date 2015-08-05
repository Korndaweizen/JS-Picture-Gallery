$server="http://78.46.49.57:21210/";
$latency=9999999;
$temporalBestServer="";
$timer=null;
$timerInterval=30; //Seconds
$latencyArray=[];

$servers=[];
$.get("/serverlist", function(data, status){
      $servers=data.availableServers;
      console.log("Data: " + $servers + "\nStatus: " + status);
      addManualSelectors();
});

function setServer() {
    clearInterval($timer);

    console.log("Server Settings are being changed:")
    if($("#radio_htpt").is(":checked"))
      setServerByHighestTpt();
    if($("#radio_lpng").is(":checked")){
      setServerByLowestlatency();
      $timer = setInterval(setServerByLowestlatency, $timerInterval*1000);
    }
    if(!($("#radio_htpt").is(":checked")) && !($("#radio_lpng").is(":checked")))
    {
      setServerByHand();
    }
    console.log('New Server: '+$server);
}
function setServerByHighestTpt() {
    console.log("Server-selection by tpt:");
    $server="http://78.46.49.57:21210/";
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
  console.log("Server: "+ret[1]+", latency: "+ret[0]); 
  if(count >= 0){
    var tmplatency=ret[0];
    var tmpUrl=ret[1];
    $latencyArray[count]=tmplatency;
    console.log("Server: "+tmpUrl+", latency: "+tmplatency); 
    if(tmplatency<$latency){
      $latency=tmplatency;
      $temporalBestServer=tmpUrl.replace("images/small.bmp", "");
      console.log("Updated best Server"); 
    } 
  }      
  count++;
  if(count < $servers.length){
    ping("http://"+$servers[count]+"/images/small.bmp").then(function(retval) {
      getLatency(retval,count);
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

    var br = document.createElement("br");

    $("#servers").append(br);
    $("#servers").append(radio);
    $("#servers").append(label);
    
    console.log(val);
    count=count+1;
  }  
}