within Simulator.Test;

package valve1
  model ms
    //This model will be instantiated in maintest model as outlet stream of valve. Dont run this model. Run maintest model for valve test
    extends Simulator.Streams.Material_Stream;
    //material stream extended
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
    //thermodynamic package Raoults law is extended
  end ms;

  model valve
    import data = Simulator.Files.Chemsep_Database;
    //instantiation of chemsep database
    parameter data.Methanol meth;
    //instantiation of methanol
    parameter data.Ethanol eth;
    //instantiation of ethanol
    parameter data.Water wat;
    //instantiation of water
    parameter Integer Nc = 3;
    parameter data.General_Properties comp[Nc] = {meth, eth, wat};
    Simulator.Unit_Operations.Valve valve1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {0, 4}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    ms inlet(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-74, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Test.valve1.ms outlet(Nc = Nc, C = C, T(start = 352), x_pc(start = {{0.33, 0.33, 0.34}, {0.26, 0.32, 0.40}, {0.47, 0.34, 0.18}})) annotation(
      Placement(visible = true, transformation(origin = {71, 3}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  equation
    connect(valve1.Out, outlet.In) annotation(
      Line(points = {{14, 4}, {35, 4}, {35, 3}, {60, 3}}, color = {0, 70, 70}));
    connect(inlet.Out, valve1.In) annotation(
      Line(points = {{-64, 4}, {-14, 4}}, color = {0, 70, 70}));
    inlet.x_pc[1, :] = {0.33, 0.33, 0.34};
//mixture molar composition
    inlet.P = 202650;
//input pressure
    valve1.Pdel = 101325;
//Pressure Drop
    inlet.T = 372;
//input temperature
    inlet.F_p[1] = 100;
//input molar flow
  end valve;
end valve1;
