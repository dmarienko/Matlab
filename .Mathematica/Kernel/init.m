(** User Mathematica initialization file **)
SetOptions[{Plot, ListPlot, ListLinePlot, ListLogPlot, LogPlot, LogLinearPlot, ParametricPlot, ParametricPlot3D,SmoothHistogram},
	PlotStyle -> ColorData[45, "ColorList"]
	];
SetOptions[{Plot, ListPlot, ListLinePlot, ListLogPlot, LogPlot, LogLinearPlot,SmoothHistogram},
	FillingStyle -> Directive[RGBColor[0.5, 0.4, 0.1]]
	];
SetOptions[{Plot, ListPlot, ListLinePlot, Plot3D, ListPlot3D, LogPlot, LogLinearPlot, ListLogPlot, ParametricPlot, ParametricPlot3D, TradingChart, CandlestickChart,SmoothHistogram},
	AxesStyle -> Directive[GrayLevel[0.75], FontSize -> 11, FontFamily -> "Ubuntu Mono"]
	];
SetOptions[{TradingChart, CandlestickChart},
  	TrendStyle -> {RGBColor[0, 0.8, 0], RGBColor[1, 0.1, 0]},
  	FrameTicksStyle -> Directive[GrayLevel[0.75], Dashed, FontSize -> 10,
    FontFamily -> "Ubuntu Mono"],
  	GridLinesStyle -> Directive[GrayLevel[0.5], Dashed]
 ];

Get[$UserBaseDirectory <> "/Kernel/PlotExplorer.m"]