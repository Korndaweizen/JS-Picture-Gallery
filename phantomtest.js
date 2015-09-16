var tests = ['radio_ownsrcset', 'radio_qtpt', 'radio_qtptotf', 'radio_uncompressed', 'radio_large', 'radio_medium', 'radio_small'];
var numberOfTestPictures = 10;
var numberOfTestRuns = 10;


/**
 * Wait until the test condition is true or a timeout occurs. Useful for waiting
 * on a server response or for a ui change (fadeIn, etc.) to occur.
 *
 * @param testFx javascript condition that evaluates to a boolean,
 * it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
 * as a callback function.
 * @param onReady what to do when testFx condition is fulfilled,
 * it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
 * as a callback function.
 * @param timeOutMillis the max amount of time to wait. If not specified, 3 sec is used.
 */
function waitFor(testFx, onReady, timeOutMillis) {
    var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 3000, //< Default Max Timout is 3s
        start = new Date().getTime(),
        condition = false,
        interval = setInterval(function() {
            if ( (new Date().getTime() - start < maxtimeOutMillis) && !condition ) {
                // If not time-out yet and condition not yet fulfilled
                condition = (typeof(testFx) === "string" ? eval(testFx) : testFx()); //< defensive code
            } else {
                if(!condition) {
                    // If condition still not fulfilled (timeout but condition is 'false')
                    console.log("'waitFor()' timeout");
                    phantom.exit(1);
                } else {
                    // Condition fulfilled (timeout and/or condition is 'true')
                    console.log("'waitFor()' finished in " + (new Date().getTime() - start) + "ms.");
                    typeof(onReady) === "string" ? eval(onReady) : onReady(); //< Do what it's supposed to do once the condition is fulfilled
                    clearInterval(interval); //< Stop this interval
                }
            }
        }, 250); //< repeat check every 250ms
};

function waitForPictureVisible(onReady, timeOutMillis) {
    var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 10000; //< Default Max Timout is 10s  

    // Wait for 'centered picture' to be visible
    waitFor(function() {
        // Check in the page if object with class "centered_picture" is now visible
        return page.evaluate(function() {
            return $(".centered_image").is(":visible");
        });
    }, onReady ,maxtimeOutMillis);
}

function waitForPictureRecursive(counter) {
    page.render('example_'+(counter+1)+'.png');
    console.log("Picture "+(counter+1)+" should be visible now.");
    if(counter>0){
      page.evaluate(function() {
          $(".imgButton_Next").click();
      });
      waitForPictureVisible( function() {
        //if(counter>0){
          waitForPictureRecursive(counter-1);
        //}
        //else{
        //  //reset page make ready for new tests
        //  page.evaluate(function(){
        //      $('html').click();
        //      $readyForTesting=true;
        //  });
        //  page.render('example_fin.png');
        //}
      });
    }
    else{
      //reset page make ready for new tests
      page.evaluate(function(){
          $('html').click();
          $readyForTesting=true;
      });
      page.render('example_fin.png');
    }
}

function waitForTestRowFinished(onReady, timeOutMillis) {
    var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 120000; //< Default Max Timout is 120s  

    // Wait for 'centered picture' to be visible
    waitFor(function() {
          // Check in the page if "$readyForTesting" is true
          return page.evaluate(function() {
              return $readyForTesting;
          });
        }, onReady ,maxtimeOutMillis);
}

function waitForTestingRecursive(counter) {
    console.log("Test Row "+counter+":")
    runTestRow(numberOfTestPictures);
    waitForTestRowFinished( function() {
      if(counter>0){
        waitForTestingRecursive(counter-1);
      }
      else{
        phantom.exit();
      }
    });
}

function runTestRow(noOfPictures) {
    page.evaluate(function() {
        $readyForTesting=false;
        $("#image_1").click();
    });  
      // Wait for 'centered picture' to be visible, then call waitForPictureRecursive(noOfPictures-1)
    waitForPictureVisible( function() {
       waitForPictureRecursive(noOfPictures-1);
    });
}

function runTestSet(numberOfTestPictures, numberOfTestRuns) {
    waitForTestRowFinished( function() {
        console.log("Starting Test Row");
        page.evaluate(function() {
            $("#"+tests[testCount]).click();
            testCount++;
        });
        waitForTestingRecursive(numberOfTestRuns)
    });
}

var page = require('webpage').create();
page.viewportSize = { width: 1024, height: 768 };
//page.includeJs("https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.4/jquery.min.js", function() {
  page.open('http://localhost:21210/', function(status) {
    console.log("Status: " + status);
    if(status === "success") {
      runTestSet(numberOfTestPictures, numberOfTestRuns);
    }
  });
//});

//$('input[name=qualityAlgo]:checked').val();
//$("#radio_qtpt").click();