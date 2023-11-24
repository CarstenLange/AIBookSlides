var beta1=1, beta2=0

function FctLogistic(x){
    return 1/(1+ Math.exp(- (beta1*x+beta2)))
}







function UpdatePlot() {
    // Generate values
    


    var xLogRegrValues=[];
    var yLogRegrValues=[];
    
        

    for (var x = -10; x <= 10; x += 0.1) {
        yLogRegrValues.push(FctLogistic(x));
        xLogRegrValues.push(x);
    }


   
    // Define Data
    var data = [
        
        {
            x: xLogRegrValues,
            y: yLogRegrValues,
            mode: "lines", 
            name: "Logistic Regr.",
            line: {color: "magenta"}
        },
        {
            x: [-10, 10],
            y: [0.5,0.5],
            mode: "lines",
            line: {color: 'red', dash: 'dash'} ,
        }
    ];

    // Define Layout
    var layout = {
        xaxis: {title: "Income", tickvals: [-10,-8, -6,-4,-2,0, 2, 4, 6, 8, 10]}, //pop() last item of list 
        yaxis: {title: "Yacht Ownership",
                range: [-0.1, 1.2], tickvals: [0, 0.1, 0.2, 0,3, 0.4,0.5, 0.6, 0.7, 0.8,0.9,1],
               },
        title: "Logistic Regression Function",
        showlegend: false,
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









