within Simulator.Test;

model msTP
  //we have to first instance components to give to material stream model.
  import data = Simulator.Files.Chemsep_Database;
  //instantiation of chemsep database
  parameter data.Methanol meth;
  //instantiation of methanol
  parameter data.Ethanol eth;
  //instantiation of ethanol
  parameter data.Water wat;
  //instantiation of water
  extends Streams.MaterialStream(Nc = 3, C = {meth, eth, wat}, x_pc(each min = 0.01, each max = 1, start = {{0.33, 0.33, 0.34}, {0.32, 0.33, 0.34}, {0.53, 0.32, 0.14}}), F_p(each start = 50));
  //material stream model is extended and values of parameters Nc and comp are given. These parameters are declared in Material stream model. We are only giving them values here.
  //Nc - number of components, comp -  component array.
  //start values are given for convergence
  extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  //Thermodynamic package is extended. We can use other thermodynamics also(not yet added) after little modification and inclusion of residual properties equations.
equation
//These are the values to be specified by user. In this P, T, mixture mole fraction and mixture molar flow is specified. These variables are declared in Material stream model, only values are given here.
  P = 101325;
  T = 351;
  x_pc[1, :] = {0.33, 0.33, 0.34};
  F_p[1] = 100;
end msTP;
