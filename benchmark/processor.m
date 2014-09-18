(* ::Package:: *)

(* ::Input:: *)
(*cwdPath=NotebookDirectory[];*)
(*outPath=cwdPath<>"out/";*)
(*outPath="/home/michal/Documents/inz/results_sig-10_dry/out-iter2/";*)
(*outPath="/home/michal/Documents/inz/results_t440_dry/out/";*)
(**)
(*s4K=4*1024;*)
(*s512K=512*1024;*)
(*s1M=2*s512K;*)
(*s4M=4*s1M;*)
(*s16M=16*s1M;*)
(*s32M=32*s1M;*)
(*s64M=64*s1M;*)
(*s128M=128*s1M;*)
(**)
(*gNodes={1,2,3,4,5,6,7,8};*)
(*gSizes={s4K,s512K,s1M,s4M,s16M,s32M,s64M};*)
(*gThred={1,2,3,4,5,6,7,8};*)
(*gActon={"create","read","update"};*)
(**)
(*MeanVal[iter_,data_]:={Mean[data],MeanDeviation[data]}/10^6/iter//N;*)
(**)
(*ParsePhase1[readListResult_]:={#1,#2,#4/(#3*#2)//N}&@@@readListResult;*)
(*ParsePhase2[nodesNum_,readListResult_]:=Prepend[#,nodesNum]&/@ParsePhase1[readListResult];*)
(*ParsePhase3[action_]:=ParsePhase2[#,ReadList[outPath<>action<>"-"<>ToString[#]<>"n.log"]]&/@gNodes//Flatten[#,1]&;*)
(*(*Result:{{nodes,size,threads,{us per request, us ..., us ...}},...}*)*)
(**)
(*MergePhase[rawData_]:=Table[{node,size,thread,#4&@@@Cases[rawData,{node,size,thread,_}]//Flatten},*)
(*{node,gNodes},{size,gSizes},{thread,gThred}]//Flatten[#,2]&;*)
(**)
(*MeanReqPerSec[data_]:=If[Length[data]>0,{Mean[data]^-1,MeanDeviation[data]/Mean[data]^2}*10^6//N,{0,0}];*)
(*ReducePhase[mergedRawData_]:={#1,#2,#3,MeanReqPerSec[#4]}&@@@mergedRawData;*)
(**)
(*RawDataCreate=ParsePhase3["create"];*)
(*RawDataRead=ParsePhase3["read"];*)
(*RawDataUpdate=ParsePhase3["update"];*)
(**)
(*RawDataCreate=ReducePhase[MergePhase[RawDataCreate]];*)
(*RawDataRead=ReducePhase[MergePhase[RawDataRead]];*)
(*RawDataUpdate=ReducePhase[MergePhase[RawDataUpdate]];*)
(**)
(**)
(*GetData[collection_,node_,size_,thrd_]:=Cases[collection,{node,size,thrd,_}][[1]][[4]];*)
(*GetCreate[node_,size_,thrd_]:=GetData[RawDataCreate,node,size,thrd];*)
(*GetRead[node_,size_,thrd_]:=GetData[RawDataRead,node,size,thrd];*)
(*GetUpdate[node_,size_,thrd_]:=GetData[RawDataUpdate,node,size,thrd];*)
(**)
(*GetSeriesInNodes[collection_,nodes_,size_,thrd_]:={#,GetData[collection,#,size,thrd][[1]]}&/@nodes;*)
(*GetSeriesInSizes[collection_,node_,sizes_,thrd_]:={#,GetData[collection,node,#,thrd][[1]]}&/@sizes;*)
(*GetSeriesInThrds[collection_,node_,size_,thrds_]:={#,GetData[collection,node,size,#][[1]]}&/@thrds;*)
(**)
(*GetCreateSeriesInNodes[n_,s_,t_]:=GetSeriesInNodes[RawDataCreate,n,s,t];*)
(*GetCreateSeriesInSizes[n_,s_,t_]:=GetSeriesInSizes[RawDataCreate,n,s,t];*)
(*GetCreateSeriesInThrds[n_,s_,t_]:=GetSeriesInThrds[RawDataCreate,n,s,t];*)
(**)
(*GetReadSeriesInNodes[n_,s_,t_]:=GetSeriesInNodes[RawDataRead,n,s,t];*)
(*GetReadSeriesInSizes[n_,s_,t_]:=GetSeriesInSizes[RawDataRead,n,s,t];*)
(*GetReadSeriesInThrds[n_,s_,t_]:=GetSeriesInThrds[RawDataRead,n,s,t];*)
(**)
(*GetUpdateSeriesInNodes[n_,s_,t_]:=GetSeriesInNodes[RawDataUpdate,n,s,t];*)
(*GetUpdateSeriesInSizes[n_,s_,t_]:=GetSeriesInSizes[RawDataUpdate,n,s,t];*)
(*GetUpdateSeriesInThrds[n_,s_,t_]:=GetSeriesInThrds[RawDataUpdate,n,s,t];*)
(**)


(* ::Input:: *)
(*PrettyPlot[series_,plotLabel_,legendLabel_,axesLabel_]:=ListLinePlot[*)
(*#2&@@@series,*)
(**)
(*BaseStyle->{FontFamily->"Helvetica",FontSize->12},*)
(*Filling->Axis,*)
(*AspectRatio->1/GoldenRatio,*)
(*InterpolationOrder->None,*)
(*PlotMarkers->{Automatic,10},*)
(**)
(*PlotLabel->plotLabel,*)
(*LabelStyle->{FontColor->Black,FontFamily->"Helvetica",FontSize->12},*)
(**)
(*FrameLabel->axesLabel,*)
(*Frame->True,*)
(*AxesOrigin->{1,0},*)
(*AxesStyle->{FontFamily->"Helvetica",FontSize->12},*)
(*PlotRange->{{1,Automatic},{Automatic,Automatic}},*)
(**)
(*GridLines->Automatic,*)
(*GridLinesStyle->Directive[LightGray,Dashed],*)
(**)
(*PlotLegends->Placed[*)
(*LineLegend[*)
(*{#1&@@@series},*)
(*LegendLabel-> legendLabel,*)
(*LabelStyle->{FontFamily->"Helvetica",FontSize->12},*)
(*LegendLayout->"Column",LegendFunction->shadowbox*)
(*],{0.75,0.75}]*)
(*];*)
(**)
(*shadowbox[legend_]:=Graphics[{{Gray,Rectangle[{0.05,-0.05},{1.05,0.95}]},{White,EdgeForm[Gray],Rectangle[]},Inset[legend,{0.5,0.5},Center]},ImageSize->60];*)


(* ::Input:: *)
(*(* n nodes / n threads *)*)
(*PrettyPlot[*)
(*{*)
(*{"series 1",Table[{n,GetData[#1,n,s4K,n][[1]]},{n,8}]}*)
(*},*)
(*#2,*)
(*"series",*)
(*{"nodes","requests/s"}*)
(*]&@@@{*)
(*{RawDataCreate,"'create' performance"},*)
(*{RawDataRead,"'read' performance"},*)
(*{RawDataUpdate,"'update' performance"}*)
(*}*)
(**)


(* ::Input:: *)
(*PrettyPlot[*)
(*{*)
(*{"1",Table[{n,GetData[#1,1,s4K,n][[1]]},{n,8}]},*)
(*{"2",Table[{n,GetData[#1,2,s4K,n][[1]]},{n,8}]},*)
(*{"3",Table[{n,GetData[#1,3,s4K,n][[1]]},{n,8}]},*)
(*{"4",Table[{n,GetData[#1,4,s4K,n][[1]]},{n,8}]}*)
(*(*{"5",Table[{n,GetData[#1,5,s4K,n][[1]]},{n,8}]},*)
(*{"6",Table[{n,GetData[#1,6,s4K,n][[1]]},{n,8}]},*)
(*{"7",Table[{n,GetData[#1,7,s4K,n][[1]]},{n,8}]},*)
(*{"8",Table[{n,GetData[#1,8,s4K,n][[1]]},{n,8}]}*)*)
(*},*)
(*#2,*)
(*"nodes",*)
(*{"concurrent threads","requests/s"}*)
(*]&@@@{*)
(*{RawDataCreate,"'create' performance"},*)
(*{RawDataRead,"'read' performance"},*)
(*{RawDataUpdate,"'update' performance"}*)
(*}*)


(* ::Input:: *)
(*PrettyPlot[*)
(*{*)
(*{"4K",{#1,1/#2}&@@@GetSeriesInNodes[#1, gNodes,s4K,gThred[[4]]]},*)
(*{"512K",{#1,1/#2}&@@@GetSeriesInNodes[#1,gNodes,s512K,gThred[[4]]]},*)
(*{"1M",{#1,1/#2}&@@@GetSeriesInNodes[#1,gNodes,s1M,gThred[[4]]]},*)
(*{"4M",{#1,1/#2}&@@@GetSeriesInNodes[#1,gNodes,s4M,gThred[[4]]]}*)
(*},*)
(*#2,*)
(*"sample size",*)
(*{"nodes","requests/s"}*)
(*]&@@@{*)
(*{RawDataCreate,"'create' performance"},*)
(*{RawDataRead,"'read' performance"},*)
(*{RawDataUpdate,"'update' performance"}*)
(*}*)


(* ::Input:: *)
(*PrettyPlot[*)
(*{*)
(*(*{"4M",{#1,1/#2}&@@@GetSeriesInNodes[#1, gNodes,s4M,gThred[[4]]]},*)*)
(*{"16M",{#1,1/#2}&@@@GetSeriesInNodes[#1,gNodes,s16M,gThred[[4]]]},*)
(*{"32M",{#1,1/#2}&@@@GetSeriesInNodes[#1,gNodes,s32M,gThred[[4]]]},*)
(*{"64M",{#1,1/#2}&@@@GetSeriesInNodes[#1,gNodes,s64M,gThred[[4]]]}*)
(*},*)
(*#2,*)
(*"sample size",*)
(*{"nodes","requests/s"}*)
(*]&@@@{*)
(*{RawDataCreate,"'create' performance"},*)
(*{RawDataRead,"'read' performance"},*)
(*{RawDataUpdate,"'update' performance"}*)
(*}*)


(* ::Input:: *)
(*PrettyPlot[*)
(*{*)
(*{"1",{#1,1/#2}&@@@GetSeriesInNodes[#1,gNodes,s4M,1]},*)
(*{"2",{#1,1/#2}&@@@GetSeriesInNodes[#1,gNodes,s4M,2]},*)
(*{"3",{#1,1/#2}&@@@GetSeriesInNodes[#1,gNodes,s4M,3]},*)
(*{"4",{#1,1/#2}&@@@GetSeriesInNodes[#1,gNodes,s4M,4]}*)
(*},*)
(*#2,*)
(*"threads",*)
(*{"nodes","requests/s"}*)
(*]&@@@{*)
(*{RawDataCreate,"'create' performance"},*)
(*{RawDataRead,"'read' performance"},*)
(*{RawDataUpdate,"'update' performance"}*)
(*}*)
