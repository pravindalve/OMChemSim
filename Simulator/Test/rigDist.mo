within Simulator.Test;

package rigDist
  model Condenser
    extends Simulator.Unit_Operations.Distillation_Column.Cond;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end Condenser;

  model Tray
    extends Simulator.Unit_Operations.Distillation_Column.DistTray;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end Tray;

  model Reboiler
    extends Simulator.Unit_Operations.Distillation_Column.Reb;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end Reboiler;

  model DistColumn
    extends Simulator.Unit_Operations.Distillation_Column.DistCol;
    Condenser condenser(Nc = Nc, C = C, Ctype = Ctype, Bin = Bin[1], T(start = 300));
    Reboiler reboiler(Nc = Nc, C = C, Bin = Bin[Nt]);
    Tray tray[Nt - 2](each Nc = Nc, each C = C, Bin = Bin[2:Nt - 1], each Fliq_s(each start = 150), each Fvap_s(each start = 150));
  end DistColumn;

  model ms
    extends Simulator.Streams.Material_Stream;
    extends Simulator.Files.Thermodynamic_Packages.Raoults_Law;
  end ms;

  model Test
    parameter Integer Nc = 2;
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc] = {benz, tol};
    Simulator.Test.rigDist.DistColumn distCol(Nc = Nc, C = C, Nt = 4, Ni = 1, InT_s = {3}) annotation(
      Placement(visible = true, transformation(origin = {-22, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms feed(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms distillate(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms bottoms(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
  connect(distCol.Cduty, cond_duty.In) annotation(
      Line(points = {{3, 68}, {14.5, 68}, {14.5, 62}, {28, 62}}));
  connect(distCol.Rduty, reb_duty.In) annotation(
      Line(points = {{3, -52}, {38, -52}}));
  connect(distCol.Bot, bottoms.In) annotation(
      Line(points = {{3, -22}, {29.5, -22}, {29.5, -16}, {58, -16}}));
  connect(distCol.Dist, distillate.In) annotation(
      Line(points = {{3, 38}, {26.5, 38}, {26.5, 22}, {54, 22}}));
  connect(feed.Out, distCol.In[1]) annotation(
      Line(points = {{-66, 2}, {-57.5, 2}, {-57.5, 8}, {-47, 8}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.F_p[1] = 100;
    feed.x_pc[1, :] = {0.5, 0.5};
    distCol.condenser.P = 101325;
    distCol.reboiler.P = 101325;
    distCol.RR = 2;
    bottoms.F_p[1] = 50;
  end Test;

  model Test2
    parameter Integer Nc = 2;
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc] = {benz, tol};
    DistColumn distCol(Nc = Nc, C = C, Nt = 12, Ni = 1, InT_s = {7}) annotation(
      Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    ms feed(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms distillate(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms bottoms(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(distCol.Cduty, cond_duty.In) annotation(
      Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
    connect(distCol.Rduty, reb_duty.In) annotation(
      Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
    connect(distCol.Bot, bottoms.In) annotation(
      Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
    connect(distCol.Dist, distillate.In) annotation(
      Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
    connect(feed.Out, distCol.In[1]) annotation(
      Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.F_p[1] = 100;
    feed.x_pc[1, :] = {0.5, 0.5};
    distCol.condenser.P = 101325;
    distCol.reboiler.P = 101325;
    distCol.RR = 2;
    bottoms.F_p[1] = 50;
  end Test2;

  model Test3
    parameter Integer Nc = 2;
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc] = {benz, tol};
    DistColumn distCol(Nc = Nc, C = C, Ni = 1, Nt = 22, InT_s = {10}) annotation(
      Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    ms feed(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms distillate(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms bottoms(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(distCol.Cduty, cond_duty.In) annotation(
      Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
    connect(distCol.Rduty, reb_duty.In) annotation(
      Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
    connect(distCol.Bot, bottoms.In) annotation(
      Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
    connect(distCol.Dist, distillate.In) annotation(
      Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
    connect(feed.Out, distCol.In[1]) annotation(
      Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.F_p[1] = 100;
    feed.x_pc[1, :] = {0.3, 0.7};
    distCol.condenser.P = 101325;
    distCol.reboiler.P = 101325;
    distCol.RR = 1.5;
    bottoms.F_p[1] = 70;
  end Test3;

  model Test4
    parameter Integer Nc = 2;
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc] = {benz, tol};
    DistColumn distCol(Nc = Nc, C = C, Nt = 22, Ni = 1, InT_s = {10}, condenser.Ctype = "Partial", each tray.Fliq_s(each start = 100), each tray.Fvap_s(each start = 100)) annotation(
      Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    ms feed(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms distillate(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms bottoms(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(distCol.Cduty, cond_duty.In) annotation(
      Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
    connect(distCol.Rduty, reb_duty.In) annotation(
      Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
    connect(distCol.Bot, bottoms.In) annotation(
      Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
    connect(distCol.Dist, distillate.In) annotation(
      Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
    connect(feed.Out, distCol.In[1]) annotation(
      Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.F_p[1] = 96.8;
    feed.x_pc[1, :] = {0.3, 0.7};
    distCol.condenser.P = 151325;
    distCol.reboiler.P = 101325;
    distCol.RR = 1.5;
    bottoms.F_p[1] = 70;
  end Test4;

  model multiFeedTest
    parameter Integer Nc = 2;
    import data = Simulator.Files.Chemsep_Database;
    parameter data.Benzene benz;
    parameter data.Toluene tol;
    parameter Simulator.Files.Chemsep_Database.General_Properties C[Nc] = {benz, tol};
    DistColumn distCol(Nc = Nc, C = C, Nt = 5, Ni = 2, InT_s = {3, 4}) annotation(
      Placement(visible = true, transformation(origin = {-3, 3}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
    ms feed(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-76, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms distillate(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {64, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms bottoms(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {68, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream cond_duty annotation(
      Placement(visible = true, transformation(origin = {38, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Simulator.Streams.Energy_Stream reb_duty annotation(
      Placement(visible = true, transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    ms ms1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(ms1.Out, distCol.In[2]) annotation(
      Line(points = {{-70, 50}, {-26, 50}, {-26, 2}, {-28, 2}}));
    connect(distCol.Cduty, cond_duty.In) annotation(
      Line(points = {{12, 28}, {12, 28}, {12, 62}, {28, 62}, {28, 62}}));
    connect(distCol.Rduty, reb_duty.In) annotation(
      Line(points = {{16, -22}, {16, -22}, {16, -52}, {38, -52}, {38, -52}}));
    connect(distCol.Bot, bottoms.In) annotation(
      Line(points = {{22, -14}, {56, -14}, {56, -16}, {58, -16}}));
    connect(distCol.Dist, distillate.In) annotation(
      Line(points = {{22, 22}, {54, 22}, {54, 22}, {54, 22}}));
    connect(feed.Out, distCol.In[1]) annotation(
      Line(points = {{-66, 2}, {-30, 2}, {-30, 2}, {-28, 2}}));
    feed.P = 101325;
    feed.T = 298.15;
    feed.F_p[1] = 100;
    feed.x_pc[1, :] = {0.5, 0.5};
    distCol.condenser.P = 101325;
    distCol.reboiler.P = 101325;
    distCol.RR = 2;
    bottoms.F_p[1] = 50;
    ms1.P = 101325;
    ms1.T = 298.15;
    ms1.F_p[1] = 100;
    ms1.x_pc[1, :] = {0.5, 0.5};
  end multiFeedTest;
end rigDist;
