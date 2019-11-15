within Simulator.Unit_Operations.Distillation_Column;

  model Cond
    import Simulator.Files.*;
    parameter Integer Nc = 2;
    parameter Boolean Bin = false;
    parameter Chemsep_Database.General_Properties comp[Nc];
    Real P(min = 0, start = 101325), T(min = 0, start = 273.15);
    Real Fin(min = 0, start = 100), Fout(min = 0, start = 100), Fvapin(min = 0, start = 100), Fliqout(min = 0, start = 100), xin_c[Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)), xout_c[Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)), xvapin_c[Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)), xliqout_c[Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)), Hin, Hvapin, Hliqout, Q, Hout, Hliqout_c[Nc];
    Real x_pc[3, Nc](each min = 0, each max = 1, each start = 1/(Nc + 1)), Pdew(min = 0, start = sum(comp[:].Pc)/Nc), Pbubl(min = 0, start = sum(comp[:].Pc)/Nc);
    //String sideDrawType(start = "Null");
    //L or V
    parameter String Ctype "Partial or Total";
    replaceable Simulator.Files.Connection.matConn In(Nc = Nc) if Bin annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn In_Dmy(Nc = Nc, P = 0, T = 0, mixMolFrac = zeros(3, Nc), mixMolFlo = 0, mixMolEnth = 0, mixMolEntr = 0, vapPhasMolFrac = 0) if not Bin annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.matConn Out(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.trayConn Out_Liq(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.trayConn In_Vap(Nc = Nc) annotation(
      Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Files.Connection.enConn En annotation(
      Placement(visible = true, transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
//connector equation
    if Bin then
      In.x_pc[1, :] = xin_c[:];
      In.H = Hin;
      In.F = Fin;
    else
      In_Dmy.x_pc[1, :] = xin_c[:];
      In_Dmy.H = Hin;
      In_Dmy.F = Fin;
    end if;
    
    Out.P = P;
    Out.T = T;
    Out.x_pc[1, :] = xout_c[:];
    Out.F = Fout;
    Out.H = Hout;
    Out_Liq.F = Fliqout;
    Out_Liq.H = Hliqout;
    Out_Liq.x_pc[:] = xliqout_c[:];
    In_Vap.F = Fvapin;
    In_Vap.H = Hvapin;
    In_Vap.x_pc[:] = xvapin_c[:];
    En.Q = Q;
//Adjustment for thermodynamic packages
    x_pc[1, :] = (Fout .* xout_c[:] + Fliqout .* xliqout_c[:]) ./ (Fout + Fliqout);
     x_pc[2, :] = xliqout_c[:];
     x_pc[3, :] = K[:] .* x_pc[2, :];
//Bubble point calculation
    Pbubl = sum(gmabubl_c[:] .* x_pc[1, :] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6]) ./ philiqbubl_c[:]);
//Dew point calculation
    Pdew = 1 / sum(x_pc[1, :] ./ (gmadew_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6])) .* phivapdew_c[:]);
//molar balance
//Fin + Fvapin = Fout + Fliqout;
    Fin .* xin_c[:] + Fvapin .* xvapin_c[:] = Fout .* xout_c[:] + Fliqout .* xliqout_c[:];
//equillibrium
    if Ctype == "Partial" then
      xout_c[:] = K[:] .* xliqout_c[:];
    elseif Ctype == "Total" then
      xout_c[:] = xliqout_c[:];
    end if;
//summation equation
//  sum(xliqout_c[:]) = 1;
    sum(xout_c[:]) = 1;
// Enthalpy balance
    Fin * Hin + Fvapin * Hvapin = Fout * Hout + Fliqout * Hliqout + Q;
//Temperature calculation
    if Ctype == "Total" then
      P = sum(xout_c[:] .* exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6]));
    elseif Ctype == "Partial" then
      1 / P = sum(xout_c[:] ./ exp(C[:].VP[2] + C[:].VP[3] / T + C[:].VP[4] * log(T) + C[:].VP[5] .* T .^ C[:].VP[6]));
    end if;
// outlet liquid molar enthalpy calculation
    for i in 1:Nc loop
      Hliqout_c[i] = Simulator.Files.Thermodynamic_Functions.HLiqId(C[i].SH, C[i].VapCp, C[i].HOV, C[i].Tc, T);
    end for;
    Hliqout = sum(xliqout_c[:] .* Hliqout_c[:]) + Hres_p[2];
    annotation(
      Diagram(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
      Icon(coordinateSystem(extent = {{-100, -40}, {100, 40}})),
      __OpenModelica_commandLineOptions = "");
  end Cond;
