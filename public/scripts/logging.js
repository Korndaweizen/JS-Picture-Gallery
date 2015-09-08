function sendLog(logString) {
  var d= new Date();
  var timeString = "["+d.getHours() + ":" + d.getMinutes()+ ":" + d.getSeconds() +"]";
  var timestamp =  d.getTime();
  logString= timestamp+" Time: "+timeString+" "+logString;
  $.post("/logthis",{loggedstring: logString}, function(data){
     if(data==='done'){
        console.log("ServerLog: "+ logString);
     } else { 
     	console.log("ServerLog failed: "+ logString);
     }
  });	
}

function newLog(){
  $.get("/newlog", function(data, status){
        alert("Data: " + data + "\nStatus: " + status);
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