Carat=0.9
Clarity=2
WeightsPlot=vector()

FctNN=function(x1,x2){
  EffInpH1=x1*H1In1+x2*H1In2+Bias1
  EffInpH2=x1*H2In1+x2*H2In2+Bias2
  Act1=1/(1+exp(-EffInpH1))
  Act2=1/(1+exp(-EffInpH2))
  Out=BiasOut+H1Out*Act1+H2Out*Act2
  return(Out)
}

WeightsPlot[1]=Bias1=0.1
WeightsPlot[2]=H1In1=-0.9 #9000*(-3.3333) transf. allows to use unnorm Carat and Clarity
WeightsPlot[3]=H1In2=0.5   #-9000/-5 transf. allows to use unnorm Carat and Clarity
Bias2=-0.1
H2In1=0.8
H2In2=0.6
BiasOut=0.1
H1Out=0.8
H2Out=0.9

FctNN(Carat ,Clarity) 

(EffInpH1=Carat*H1In1+Clarity*H1In2+Bias1)
(EffInpH2=Carat*H2In1+Clarity*H2In2+Bias2)
(Act1=1/(1+exp(-EffInpH1)))
(Act2=1/(1+exp(-EffInpH2)))



