function sendQualityLog(logString) {
  var d= new Date();
  var timeString = "["+d.getHours() + ":" + d.getMinutes()+ ":" + d.getSeconds() +"]";
  var timestamp =  d.getTime();
  logString= timestamp+" Time: "+timeString+" "+logString;
  $.post("/logQuality",{loggedstring: logString}, function(data){
     if(data==='done'){
        console.log("QLog: "+ logString);
     } else { 
      console.log("QLog failed: "+ logString);
     }
  }); 
}

function sendServerLog(logString) {
  var d= new Date();
  var timeString = "["+d.getHours() + ":" + d.getMinutes()+ ":" + d.getSeconds() +"]";
  var timestamp =  d.getTime();
  logString= timestamp+" Time: "+timeString+" "+logString;
  $.post("/logServer",{loggedstring: logString}, function(data){
     if(data==='done'){
        console.log("SLog: "+ logString);
     } else { 
      console.log("SLog failed: "+ logString);
     }
  }); 
}

function sendLog(logString) {
  var d= new Date();
  var timeString = "["+d.getHours() + ":" + d.getMinutes()+ ":" + d.getSeconds() +"]";
  var timestamp =  d.getTime();
  logString= timestamp+" Time: "+timeString+" "+logString;
  $.post("/logthis",{loggedstring: logString}, function(data){
     if(data==='done'){
        console.log("Log: "+ logString);
     } else { 
      console.log("Log failed: "+ logString);
     }
  }); 
}

function newLog(){
  //$.post("/newlog", function(data, status){
  //      alert("Data: " + data + "\nStatus: " + status);
  //  });
  $.post("/newlog",{}, function(data){
     if(data==='done'){
        console.log("Log: "+ status);
     } else { 
      console.log("Log failed: "+ status);
     }
  }); 
}

String.prototype.replaceAll = function(search, replace)
{
    //if replace is not sent, return original string otherwise it will
    //replace search string with 'undefined'.
    if (replace === undefined) {
        return this.toString();
    }

    return this.replace(new RegExp('[' + search + ']', 'g'), replace);
};