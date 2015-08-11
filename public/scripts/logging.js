function sendLog(logString) {
  $.post("http://localhost:21210/logthis",{loggedstring: logString}, function(data){
     if(data==='done'){
        console.log("ServerLog: "+ logString);
     } else { 
     	console.log("ServerLog failed: "+ logString);
     }
  });	
}