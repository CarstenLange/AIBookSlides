/*
Christmas Edition
       /\
      /  \
     /  o \
    / o    \
   /      o \
  /__________\
      |  |
      |__|    
*/

var IsOLSGraphVisible="true", IsLogRegGraphVisible="true", IsDataVisible="true",
    Is50LevGraphVisible="legendonly", IsDecBouGraphVisible="legendonly"
var beta1=0.1, beta2=-4
var MSELin=0, MSELog=0


function FctLogistic(x){
    return 1/(1+ Math.exp(- (beta1*x+beta2)))
}

function FctLinear(x){
    var beta1linopt=0.002294383, beta2linopt=0.1418117;
    return beta1linopt*x+beta2linopt
}





function UpdatePlot() {
    // Generate values
    var MSELin=0, MSELog=0


    var xLinRegrValues = [], xLogRegrValues=[];
    var yLinRegrValues = [], yLogRegrValues=[];
    
        

    for (var x = 0; x <= 600; x += 1) {
        yLinRegrValues.push(FctLinear(x));
        xLinRegrValues.push(x);
                
        yLogRegrValues.push(FctLogistic(x));
        xLogRegrValues.push(x);
    }

   var xPValues=[45,50,55,60,67,250,280,320,370,500];
   var yPValues=[1,0,0,0,0,1,1,1,1,1];

   for (var i = 0; i<yPValues.length; i += 1) {
    MSELin=MSELin+Math.pow(yPValues[i]-FctLinear(xPValues[i]), 2)/10
    MSELog=MSELog+Math.pow(yPValues[i]-FctLogistic(xPValues[i]),2)/10
    console.log(yPValues[i]-FctLinear(xPValues[i]))
   
   }

   document.getElementById("mselin").innerText = MSELin;
   document.getElementById("mselog").innerText = MSELog;
   
   
    // Define Data
    var data = [
        {
            x: xLinRegrValues,
            y: yLinRegrValues,
            mode: "lines", 
            name: "OLS",
            visible: IsOLSGraphVisible,
            line: {color: "blue"}
        }, 
        {
            x: xLogRegrValues,
            y: yLogRegrValues,
            mode: "lines", 
            name: "Logistic Regr.",
            line: {color: "magenta"},
            visible: IsLogRegGraphVisible,
        },
        {
            x: xPValues,
            y: yPValues,
            mode: "markers", 
            name: "Data",
            visible: IsDataVisible,
        },
        {
            x: [-beta2/beta1, -beta2/beta1],
            y: [0, 1.1],
            mode: "lines", 
            line: {color: "red"},
            name: "Dec. Bound.",
            visible: IsDecBouGraphVisible,
        },
        {
            x: [0, 600],
            y: [0.5,0.5],
            mode: "lines",
            line: {color: 'red', dash: 'dash'} ,
            name: "50% Level",
            visible: Is50LevGraphVisible,
        }
    ];

    // Define Layout
    var layout = {
        xaxis: {title: "Income"}, //pop() last item of list 
        yaxis: {title: "Yacht Ownership",
                range: [-0.1, 1.2], tickvals: [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1],
               },
        title: "Logistic vs. Opt. Linear Regression"
    };

    // Display using Plotly
    Plotly.newPlot("plot-area", data, layout);
}

function UpdatePage () {
    // console.log("Changing!") //for testing

    beta1 = parseFloat(document.getElementById("beta1-entry-field").value);
    beta2 = parseFloat(document.getElementById("beta2-entry-field").value);
    UpdatePlot();
}

UpdatePlot();









