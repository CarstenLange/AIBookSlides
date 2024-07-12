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

var IsOLSGraphVisible="legendonly",  IsDataVisible="true"
    
var beta1=0.1, beta2=-4
var MSELin=0, MSELog=0




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
                
        
    }

   var xPValues=[45,50,55,60,67,250,280,320,370,500];
   var yPValues=[1,0,0,0,0,1,1,1,1,1];

   
   
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
            x: xPValues,
            y: yPValues,
            mode: "markers", 
            name: "Data",
            marker: {
              color: 'green',
              size: 10
            }
        },
        
    ];

    // Define Layout
    var layout = {
        xaxis: {title: "Income"}, //pop() last item of list 
        yaxis: {title: "Yacht Ownership",
                range: [-0.1, 1.2], tickvals: [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1],
               },
        title: "Linear Regression (Linear Probability Model; LPM)"
    };

    // Display using Plotly
    Plotly.newPlot("plot-area", data, layout);
}

function UpdatePage () {
    // console.log("Changing!") //for testing

    UpdatePlot();
}

UpdatePlot();









