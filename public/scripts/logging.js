function sendLog(logString) {
  $.post("http://localhost:21210/logthis",{loggedstring: logString}, function(data){
     if(data==='done'){
        console.log("ServerLog: "+ logString);
     } else { 
     	console.log("ServerLog failed: "+ logString);
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