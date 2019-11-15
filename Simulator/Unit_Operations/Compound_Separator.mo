within Simulator.Unit_Operations;

model Compound_Separator
  extends Simulator.Files.Icons.Compound_Separator;
  parameter Integer Nc "Number of components", SepStrm "Specified Stream";
  parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc] "Components array";
  Real Pin(min = 0, start = 101325) "inlet pressure", Tin(min = 0, start = 273.15) "inlet temperature", xin_c[Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "inlet mixture mole fraction", Fin(min = 0, start = 100) "inlet mixture molar flow", Fin_c[Nc](each min = 0, each start = 100) "inlet compound molar flow", Fmin_c[Nc](each min = 0, each start = 100) "inlet compound mass flow", Hin "inlet mixture molar enthalpy";
  Real Pout_s[2](each min = 0, each start = 100) "outlet Pressure", Tout_s[2](each min = 0, each start = 273.15) "outlet temperature", xout_sc[2, Nc](each min = 0, each max = 1, each start = 1 / (Nc + 1)) "outlet mixture mole fraction", Fout_s[2](each min = 0, each start = 100) "Outlet mixture molar flow", Fout_sc[2, Nc](each min = 0, each start = 100) "outlet compounds molar flow", Fmout_sc[2, Nc](each min = 0, each start = 100) "outlet compound mass flow", Hout_s[2] "outlet mixture molar enthalpy";
  Real Q "energy required";
  Real SepVal_c[Nc] "Separation factor value";
  parameter String SepFact_c[Nc] "Separation factor";
  // separation factor: Molar_Flow, Mass_Flow, Inlet_Molar_Flow_Percent, Inlet_Mass_Flow_Percent.
  Simulator.Files.Connection.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn Out1(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.enConn En annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Connection.matConn Out2(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// Connector equation
  In.P = Pin;
  In.T = Tin;
  In.F  = Fin;
  In.x_pc[1, :] = xin_c[:];
  In.H = Hin;
  Out1.P = Pout_s[1];
  Out1.T = Tout_s[1];
  Out1.mixMolFlo = Fout_s[1];
  Out1.mixMolFrac[1, :] = xout_sc[1, :];
  Out1.mixMolEnth = Hout_s[1];
  Out2.mixMolFlo = Fout_s[2];
  Out2.mixMolFrac[1, :] = xout_sc[2, :];
  Out2.mixMolEnth = Hout_s[2];
  Out2.P = Pout_s[2];
  Out2.T = Tout_s[2];
  En.Q = Q;
// Pressure and temperature equations
  Pout_s[1] = Pin;
  Pout_s[2] = Pin;
  Tout_s[1] = Tin;
  Tout_s[2] = Tin;
// mole balance
  Fin = sum(Fout_s[:]);
  Fin_c[:] = xout_sc[1, :] * Fout_s[1] + xout_sc[2, :] * Fout_s[2];
// Conversion
  Fin_c = xin_c .* Fin;
  Fmin_c = Fin_c .* comp[:].MW;
  for i in 1:2 loop
    Fout_sc[i, :] = xout_sc[i, :] .* Fout_s[i];
    Fmout_sc[i, :] = Fout_sc[i, :] .* comp[:].MW;
  end for;
  sum(xout_sc[2, :]) = 1;
  for i in 1:Nc loop
    if SepFact_c[i] == "Molar_Flow" then
      SepVal_c[i] = Fout_sc[SepStrm, i];
    elseif SepFact_c[i] == "Mass_Flow" then
      SepVal_c[i] = Fmout_sc[SepStrm, i];
    elseif SepFact_c[i] == "Inlet_Molar_Flow_Percent" then
      Fout_sc[SepStrm, i] = SepVal_c[i] * Fin_c[i] / 100;
    elseif SepFact_c[i] == "Inlet_Mass_Flow_Percent" then
      Fmout_sc[SepStrm, i] = SepVal_c[i] * Fmin_c[i] / 100;
    end if;
  end for;
//Energy balance
  Q = sum(Hout_s .* Fout_s) - Fin * Hin;

annotation(
    Icon(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
    Diagram(coordinateSystem(extent = {{-100, -200}, {100, 200}})),
    __OpenModelica_commandLineOptions = "");
  end Compound_Separator;
