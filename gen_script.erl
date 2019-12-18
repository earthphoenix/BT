-module(gen_script).
-export([start/0]).
-include("gen_script_config.hrl").

start() ->
	TimerStart = erlang:monotonic_time(),
	TestVector = [?TC1,?TC2,?TC3,?TC4,?TC5,?TC6,?TC7],
	%step1InitVector
	{In,_} = makeInitialTestvector(length(TestVector),TestVector,[],[]),
	if 
		In == [] ->
			io:format("No test vectors added. No TC selected?~n"),
			exit("Insufficient number of TCs.~nMight be due to invalid test case being called.~n");
		true ->
			ok
	end,
	{ok, Header} = file:open(?HeaderFile,[read]),
	{ok, HeaderTxt} = file:read(Header,1024 * 1024),
	file:close(Header),
	{ok, Footer} = file:open(?FooterFile,[read]),
	{ok, FooterTxt} = file:read(Footer,1024 * 1024),
	file:close(Footer),
	%step2BoolCombi
	InBoolean = makeBooleanCombinations(length(lists:flatten(In))),
	%step3FilterImportant
	{ImportantIn, UnimportantIn} = filter_importantIn(InBoolean,{[],[]}),
	CompleteIn = lists:append(ImportantIn,UnimportantIn),
	%step4AddOutputs
	CompleteSet = addExpectedOutputs(CompleteIn,[]),
	NumberOfTestSteps=length(CompleteSet),
	%step5ReplaceText
	Magic = replaceText(CompleteSet,"",NumberOfTestSteps),
	Output = lists:append([HeaderTxt,"
\/\/******************************************************************************","
			",Magic,"
\/\/******************************************************************************",FooterTxt]),
	{ok, Filedump} = file:open(?OutputFile, [write]),
	file:write(Filedump,Output),
	file:close(Filedump),
	io:format("That took ~p minutes to generate ~p teststeps.~n",[((erlang:monotonic_time()-TimerStart)/1000000)/60,length(CompleteIn)]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% STEP 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
makeInitialTestvector(_,[],Input,Output) ->
	{Input,Output};
makeInitialTestvector(TotalNumberTC,TempList,Input,Output) ->
	[First|NewTempList] = TempList,
	TC = TotalNumberTC - length(NewTempList),
	if 
		First == false ->
			NewInput = Input,
			NewOutput = Output;
		true ->
			{NewInput,NewOutput} = addTestCase(TC,Input,Output)
	end,
	makeInitialTestvector(TotalNumberTC,NewTempList,NewInput,NewOutput).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% addTestCase adds specific atoms for each variable to the lists. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%311 fire detectors
addTestCase(1,[],[]) ->
	{[[tc1a,tc1b,tc1av,tc1bv]],[tc4c002,tc90,tc92,csct4c1]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%312 battery
addTestCase(2,Input,_) ->
	case ?TC1 of
		true ->
			Output = [tc4c002,tc4c000,tc90,tc92,csct4c1];
		false ->
			Output = [tc4c000,tc90,tc92,csct4c1]
	end,
	{lists:append(Input,[[tc2a,tc2ba,tc2bb,tc2c,tc2av,tc2bav,tc2bbv,tc2cv]]),Output};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%321 derail
addTestCase(3,Input,_) ->
	case {?TC1,?TC2} of
		{true,true} ->
			Output = [tc4c002,tc4c000,tc4c004,tc90,tc92,csct4c1];
		{true,false} ->
			Output = [tc4c002,tc4c004,tc90,tc92,csct4c1];
		{false,true} ->
			Output = [tc4c000,tc4c004,tc90,tc92,csct4c1];
		{false,false} ->
			Output = [tc4c004,tc90,tc92,csct4c1]
	end,
	{lists:append(Input,[[tc3a,tc3b,tc3av,tc3bv]]),Output};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addTestCase(_,_,_) ->
	io:format("Invalid Test Case called.~n"),
	{[],[]}.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% STEP 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
makeBooleanCombinations(1) ->
[[A] || 	A <- [true,false]];
makeBooleanCombinations(2) ->
[[A,B] || 
	A <- [true,false], 
	B <- [true,false]];
makeBooleanCombinations(3) ->
[[A,B,C] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false]];
makeBooleanCombinations(4) ->
[[A,B,C,D] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false],
	D <- [true,false]];
makeBooleanCombinations(5) ->
[[A,B,C,D,E] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false],
	D <- [true,false],
	E <- [true,false]];
makeBooleanCombinations(6) ->
[[A,B,C,D,E,F] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false],
	D <- [true,false],
	E <- [true,false],
	F <- [true,false]];
makeBooleanCombinations(7) ->
[[A,B,C,D,E,F,G] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false],
	D <- [true,false],
	E <- [true,false],
	F <- [true,false],
	G <- [true,false]];
makeBooleanCombinations(8) ->
[[A,B,C,D,E,F,G,H] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false],
	D <- [true,false],
	E <- [true,false],
	F <- [true,false],
	G <- [true,false],
	H <- [true,false]];
makeBooleanCombinations(9) ->
[[A,B,C,D,E,F,G,H,I] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false],
	D <- [true,false],
	E <- [true,false],
	F <- [true,false],
	G <- [true,false],
	H <- [true,false],
	I <- [true,false]];
makeBooleanCombinations(10) ->
[[A,B,C,D,E,F,G,H,I,J] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false],
	D <- [true,false],
	E <- [true,false],
	F <- [true,false],
	G <- [true,false],
	H <- [true,false],
	I <- [true,false],
	J <- [true,false]];
makeBooleanCombinations(11) ->
[[A,B,C,D,E,F,G,H,I,J,K] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false],
	D <- [true,false],
	E <- [true,false],
	F <- [true,false],
	G <- [true,false],
	H <- [true,false],
	I <- [true,false],
	J <- [true,false],
	K <- [true,false]];
makeBooleanCombinations(12) ->
[[A,B,C,D,E,F,G,H,I,J,K,L] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false],
	D <- [true,false],
	E <- [true,false],
	F <- [true,false],
	G <- [true,false],
	H <- [true,false],
	I <- [true,false],
	J <- [true,false],
	K <- [true,false],
	L <- [true,false]];
makeBooleanCombinations(13) ->
[[A,B,C,D,E,F,G,H,I,J,K,L,M] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false],
	D <- [true,false],
	E <- [true,false],
	F <- [true,false],
	G <- [true,false],
	H <- [true,false],
	I <- [true,false],
	J <- [true,false],
	K <- [true,false],
	L <- [true,false],
	M <- [true,false]];
makeBooleanCombinations(14) ->
[[A,B,C,D,E,F,G,H,I,J,K,L,M,N] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false],
	D <- [true,false],
	E <- [true,false],
	F <- [true,false],
	G <- [true,false],
	H <- [true,false],
	I <- [true,false],
	J <- [true,false],
	K <- [true,false],
	L <- [true,false],
	M <- [true,false],
	N <- [true,false]];
makeBooleanCombinations(15) ->
[[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false],
	D <- [true,false],
	E <- [true,false],
	F <- [true,false],
	G <- [true,false],
	H <- [true,false],
	I <- [true,false],
	J <- [true,false],
	K <- [true,false],
	L <- [true,false],
	M <- [true,false],
	N <- [true,false],
	O <- [true,false]];
makeBooleanCombinations(16) ->
[[A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P] || 
	A <- [true,false], 
	B <- [true,false],
	C <- [true,false],
	D <- [true,false],
	E <- [true,false],
	F <- [true,false],
	G <- [true,false],
	H <- [true,false],
	I <- [true,false],
	J <- [true,false],
	K <- [true,false],
	L <- [true,false],
	M <- [true,false],
	N <- [true,false],
	O <- [true,false],
	P <- [true,false]];
makeBooleanCombinations(FAULT) ->
	io:format("Illegal parameter called in makeBooleanCombinations.~n
		Only up to 16 permutations supported~n.
		Tried ~p~n",[FAULT]),
	[].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% STEP 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filter_importantIn([],{ImportantIn, UnimportantIn}) ->
	{ImportantIn, UnimportantIn};
filter_importantIn(In,{ImportantIn, UnimportantIn}) ->
	[First|Rest] = In, %First = [true,true,..,true]
	BoolFilter = tc1Filter(First),
	case BoolFilter of 
		true ->
			NewImportantIn = lists:append(ImportantIn,[First]),
			NewUnimportantIn = UnimportantIn;
		false ->
			NewImportantIn = ImportantIn,
			case ?IMPORTANCE of
				true ->
					NewUnimportantIn = [];
				false ->
					NewUnimportantIn = lists:append(UnimportantIn,[First])
			end
	end,
	filter_importantIn(Rest,{NewImportantIn, NewUnimportantIn}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tc1Filter(Input) ->
	case ?TC1 of
		true ->
			[First,Second,Third,Fourth|Rest] = Input,
			if
				(First 	and not Third and not 	Fourth) or 
				(Second and not Third and 		Fourth) or 
				(First 	and 	Third and 		Fourth) ->
					tc2Filter(Rest);
				true ->
					false
			end;
		false ->
			tc2Filter(Input)
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tc2Filter(Input) ->
	case ?TC2 of
		true ->
			[First,Second,Third,Fourth,Fifth,Sixth,Seventh,Eighth|Rest] = Input,
			case ?TC2jointtc2batc2bb of
				true -> 
				 	if 
						(Second == Third) and (Sixth == Seventh) ->
							if
								((First and Second and Third and Fourth) and
									(Fifth or (Sixth and Seventh) or Eighth)) or
								((Fifth and Sixth and Seventh and Eighth) and
									(First or (Second and Third) or Fourth)) ->
									tc3Filter(Rest);
								true ->
									false
							end;
						true ->
							false
					end;
				false ->
					false 
			end;
		false ->
			tc3Filter(Input)
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tc3Filter(Input) ->
	case ?TC3 of
		true ->
			[First,Second,Third,Fourth|Rest] = Input,
			if
				((	First	and not Third and not 	Fourth) or
				(	Second	and not Third and		Fourth) or
				(	First 	and 	Third and 		Fourth)) ->
					tc4Filter(Rest);
				true ->
					false
			end;
		false ->
			tc4Filter(Input)
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tc4Filter(Input) ->
	case ?TC4 of
		true ->
			io:format("tc4Filter(Input) not implemented yet~n"),
			tc5Filter(Input);
		false ->
			tc5Filter(Input)
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tc5Filter(Input) ->
	case ?TC4 of
		true ->
			io:format("tc5Filter(Input) not implemented yet~n"),
			tc6Filter(Input);
		false ->
			tc6Filter(Input)
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tc6Filter(Input) ->
	case ?TC4 of
		true ->
			io:format("tc6Filter(Input) not implemented yet~n"),
			tc7Filter(Input);
		false ->
			tc7Filter(Input)
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tc7Filter(Input) ->
	case ?TC4 of
		true ->
			io:format("tc7Filter(Input) not implemented yet~n~p",[Input]),
			true;
		false ->
			true
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% STEP 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addExpectedOutputs([],Output)->
	Output;
addExpectedOutputs(Input,Output)->
	[First|Rest] = Input,
	NewElem = addExpectedOutputs(First,[],1),
	NewOutput = lists:append(Output,[NewElem]),
	addExpectedOutputs(Rest,NewOutput).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addExpectedOutputs(Input,[],4)->
	Input;
addExpectedOutputs(Input,_,TC)->
	case TC of
		1 ->
			case ?TC1 of
				true ->
					[First,Second,Third,Fourth|_] = Input,
					if
						((Second and First) or (Fourth and Third)) and 			
						% at least one signal is valid and good and
						not ((Second and not First) or (Fourth and not Third)) -> 
						% the other signal is not valid and bad
							Output = lists:append(Input,[true,true,true,true]);
						true ->
							Output = lists:append(Input,[false,false,false,false])
					end;
				false ->
					Output = Input
			end;
		2 ->
			case ?TC2 of
				true ->
					case ?TC1 of
						true ->
							[_,_,_,_,First,Second,Third,Fourth,Fifth,Sixth,Seventh,Eighth|_] = Input;
						false ->
							[First,Second,Third,Fourth,Fifth,Sixth,Seventh,Eighth|_] = Input
					end,
					if
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
						(First and Second and Third and Fourth) and
						((Fifth and Sixth and Seventh) or			
							(Fifth and Eighth) or					
							(Sixth and Seventh and Eighth))			
						or											
						(Fifth and Sixth and Seventh and Eighth) and
						((First and Second and Third) or			
							(First and Fourth) or					
							(Second and Third and Fourth)) ->		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
							case ?TC1 of
								true ->
									BoolCheckTC2a = lists:last(Input),
									if
										BoolCheckTC2a == true -> % step in both tc1 and tc2 is true
											Output = lists:append(Input,[true]); 
										true -> % tc1 is present but evaluated to false
											Output = lists:append([
												lists:sublist(Input, length(Input)-3),%[..|f,f,f]
												[true],
												lists:sublist(Input, length(Input)-2,3)
											])
									end;	
								false -> %TC1 not present, just add TC2
									Output = lists:append(Input,[true,true,true,true])
							end;
						true -> %tc2 falsifies
							case ?TC1 of
								true ->%tc1 present
									BoolCheckTC2b = lists:last(Input),
									if
										BoolCheckTC2b == true-> % tc1 evaluated to true, but tc2 is false
											Output = lists:append([
												lists:sublist(Input, length(Input)-3),
												[false,false,false,false]
											]);%[..,t,f,f,f,f]
										true -> % tc1 is present but evaluated to false
											Output = lists:append(Input,[false])
									end;
								false -> %TC1 not present, just add TC2
									Output = lists:append(Input,[false,false,false,false])
							end
					end;
				false ->
					Output = Input
			end;
		3 ->
			case ?TC3 of
				true ->
					case {?TC1,?TC2} of
						{true,true} ->
							[_,_,_,_,_,_,_,_,_,_,_,_,First,Second,Third,Fourth|_] = Input;
						{true,false} ->
							[_,_,_,_,First,Second,Third,Fourth|_] = Input;
						{false,true} ->
							[_,_,_,_,_,_,_,_,First,Second,Third,Fourth|_] = Input;
						{false,false} ->
							[First,Second,Third,Fourth|_] = Input
					end,
					if
						First and Second and Third and Fourth -> %tc3 evals to true
							case {?TC1,?TC2} of
								{true,true} ->						%both tc1 and tc2 are present
									BoolCheckTC3a = lists:last(Input),
									if
										BoolCheckTC3a == true ->			%and they evaluated to true
											Output = lists:append(Input,[true]);
										true ->							%and they evaluated to false
											Output = lists:append([
												lists:sublist(Input, length(Input)-3),
												[true],
												lists:sublist(Input, length(Input)-2,3)
											])%[..,x,x,t,f,f,f]
									end;
								{true,false}  ->		%one of tc1 and tc2 is present
									BoolCheckTC3b = lists:last(Input),
									if
										BoolCheckTC3b == true ->				%and it evaluated to true
											Output = lists:append(Input,[true]);
										true ->							%and it evaluated to false
											Output = lists:append([
												lists:sublist(Input, length(Input)-3),
												[true],
												lists:sublist(Input, length(Input)-2,3)
											])%[..,x,x,t,f,f,f]
									end;
								{false,true}  ->		%one of tc1 and tc2 is present
									BoolCheckTC3c = lists:last(Input),
									if
										BoolCheckTC3c == true ->				%and it evaluated to true
											Output = lists:append(Input,[true]);
										true ->							%and it evaluated to false
											Output = lists:append([
												lists:sublist(Input, length(Input)-3),
												[true],
												lists:sublist(Input, length(Input)-2,3)
											])%[..,x,x,t,f,f,f]
									end;
								{false,false} ->					%neither tc1 nor tc2 are present
									Output = lists:append(Input,[true,true,true,true])
							end;
						true ->									%tc3 evals to false
							case {?TC1,?TC2} of
								{true,true} ->						%both tc1 and tc2 are present
									BoolCheckTC3d = lists:last(Input),
									if
										BoolCheckTC3d == true ->			%and they evaluated to true
											Output = lists:append([
												lists:sublist(Input, length(Input)-3),
												[false,false,false,false]]);%[..,x,x,t,f,f,f]
										true ->							%and they evaluated to false
											Output = lists:append(Input,[false])
									end;
								{true,false} ->		%one of tc1 and tc2 is present
									BoolCheckTC3e = lists:last(Input),
									if
										BoolCheckTC3e == true ->			%and they evaluated to true
											Output = lists:append([
												lists:sublist(Input, length(Input)-3),
												[false,false,false,false]
											]);%[..,x,x,t,f,f,f]
										true ->							%and they evaluated to false
											Output = lists:append(Input,[false])
									end;
								{false,true} ->		%one of tc1 and tc2 is present
									BoolCheckTC3f = lists:last(Input),
									if
										BoolCheckTC3f == true ->			%and they evaluated to true
											Output = lists:append([
												lists:sublist(Input, length(Input)-3),
												[false,false,false,false]
											]);%[..,x,x,t,f,f,f]
										true ->							%and they evaluated to false
											Output = lists:append(Input,[false])
									end;
								{false,false} ->					%neither tc1 nor tc2 are present
									Output = lists:append(Input,[false,false,false,false])
							end
						end;
				false ->
					Output = Input
			end;

		_ ->
			Output = Input,
			io:format("Illegal testcase called in addExpectedOutputs.~n"),
			exit("doh")
	end,
	addExpectedOutputs(Output,[],TC+1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% STEP 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
replaceText([],TextString,_) ->
	TextString;
replaceText(CompleteSet,TextString,NumberOfTestSteps) ->
	[First|Rest] = CompleteSet,
	NewStringToAdd = replaceTextTC1(First,""), %delivers the whole string for one step
	String1 = string:concat("
			/** Step-",			lists:flatten(io_lib:format("~p **/",[NumberOfTestSteps-length(CompleteSet)]))),
	String2 = string:concat("
			/** ",			lists:flatten(io_lib:format("~p **/",[First]))),
	String3 = string:concat("
            TraceHeader(\"STEP ",	lists:flatten(io_lib:format("~p\");
			
			",[NumberOfTestSteps-length(CompleteSet)]))),
	NewTextString = lists:append([TextString,String1,String2,String3,NewStringToAdd]),
	replaceText(Rest,NewTextString,NumberOfTestSteps).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
replaceTextTC1(InputList,OutputString) ->
	case ?TC1 of
		true ->
			[One,Two,Three,Four|Rest] = InputList,
			case One of
				true ->
					TempList1 = "RTSIM.SIGNAL_A.Force(true);
			";
				false ->
					TempList1 = "RTSIM.SIGNAL_A.Force(false);
			"
			end,
			case Two of
				true ->
					TempList2 = "RTSIM.SIGNAL_B.Force(true);
			";
				false ->
					TempList2 = "RTSIM.SIGNAL_B.Force(false);
			"
			end,
			case Three of
				true ->
					TempList3 = "RTSIM.SIGNAL_C.Force(true);
			";
				false ->
					TempList3 = "RTSIM.SIGNAL_C.Force(false);
			"
			end,
			case Four of
				true ->
					TempList4 = "RTSIM.SIGNAL_D.Force(true);
			";
				false ->
					TempList4 = "RTSIM.SIGNAL_D.Force(false);
			"
			end,
			TC1List = lists:append([OutputString,TempList1,TempList2,TempList3,TempList4]);
		false ->
			Rest = InputList,
			TC1List = ""
	end,
	replaceTextTC2(Rest,TC1List).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
replaceTextTC2(InputList,OutputString) ->
	case ?TC2 of
		true ->
			[One,Two,Three,Four,Five,Six,Seven,Eight|Rest] = InputList,
			case One of
				true ->
					TempList1 = "RTSIM.SIGNAL_E.Force(true);
			";
				false ->
					TempList1 = "RTSIM.SIGNAL_E.Force(false);
			"
			end,
			case Two of
				true ->
					TempList2 = "RTSIM.SIGNAL_G.Force(true);
			";
				false ->
					TempList2 = "RTSIM.SIGNAL_G.Force(false);
			"
			end,
			case Three of
				true ->
					TempList3 = "RTSIM.SIGNAL_I.Force(true);
			";
				false ->
					TempList3 = "RTSIM.SIGNAL_I.Force(false);
			"
			end,
			case Four of
				true ->
					TempList4 = "RTSIM.SIGNAL_K.Force(true);
			";
				false ->
					TempList4 = "RTSIM.SIGNAL_K.Force(false);
			"
			end,
			case Five of
				true ->
					TempList5 = "RTSIM.SIGNAL_F.Force(true);
			";
				false ->
					TempList5 = "RTSIM.SIGNAL_F.Force(false);
			"
			end,
			case Six of
				true ->
					TempList6 = "RTSIM.SIGNAL_H.Force(true);
			";
				false ->
					TempList6 = "RTSIM.SIGNAL_H.Force(false);
			"
			end,
			case Seven of
				true ->
					TempList7 = "RTSIM.SIGNAL_J.Force(true);
			";
				false ->
					TempList7 = "RTSIM.SIGNAL_J.Force(false);
			"
			end,
			case Eight of
				true ->
					TempList8 = "RTSIM.SIGNAL_L.Force(true);
			";
				false ->
					TempList8 = "RTSIM.SIGNAL_L.Force(false);
			"
			end,
			TC2List = lists:append([OutputString,TempList1,TempList2,TempList3,TempList4,TempList5,TempList6,TempList7,TempList8]);
		false ->
			Rest = InputList,
			TC2List = OutputString
	end,
	replaceTextTC3(Rest,TC2List).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
replaceTextTC3(InputList,OutputString) ->
	case ?TC3 of
		true ->
			[One,Two,Three,Four|Rest] = InputList,
			case One of
				true ->
					TempList1 = "RTSIM.SIGNAL_M.Force(true);
			";
				false ->
					TempList1 = "RTSIM.SIGNAL_M.Force(false);
			"
			end,
			case Two of
				true ->
					TempList2 = "RTSIM.SIGNAL_N.Force(true);
			";
				false ->
					TempList2 = "RTSIM.SIGNAL_N.Force(false);
			"
			end,
			case Three of
				true ->
					TempList3 = "RTSIM.SIGNAL_O.Force(true);
			";
				false ->
					TempList3 = "RTSIM.SIGNAL_O.Force(false);
			"
			end,
			case Four of
				true ->
					TempList4 = "RTSIM.SIGNAL_P.Force(true);
			";
				false ->
					TempList4 = "RTSIM.SIGNAL_P.Force(false);
			"
			end,
			TC3List = lists:append([OutputString,TempList1,TempList2,TempList3,TempList4]);
		false ->
			Rest = InputList,
			TC3List = OutputString
	end,
	replaceTextTC4(Rest,TC3List).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
replaceTextTC4(InputList,OutputString) ->
	case ?TC4 of
		true ->
			Rest = InputList,
			TC4List = OutputString;
		false ->
			Rest = InputList,
			TC4List = OutputString
	end,
	replaceTextTC5(Rest,TC4List).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
replaceTextTC5(InputList,OutputString) ->
	case ?TC5 of
		true ->
			Rest = InputList,
			TC5List = OutputString;
		false ->
			Rest = InputList,
			TC5List = OutputString
	end,
	replaceTextTC6(Rest,TC5List).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
replaceTextTC6(InputList,OutputString) ->
	case ?TC6 of
		true ->
			Rest = InputList,
			TC6List = OutputString;
		false ->
			Rest = InputList,
			TC6List = OutputString
	end,
	replaceTextTC7(Rest,TC6List).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
replaceTextTC7(InputList,OutputString) ->
	case ?TC7 of
		true ->
			Rest = InputList,
			TC7List = OutputString;
		false ->
			Rest = InputList,
			TC7List = OutputString
	end,
	replaceTextTCOut(Rest,TC7List).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
replaceTextTCOut(InputList,OutputString) ->
	case {?TC1,?TC2,?TC3} of
		{true,true,true} ->
			[One,Two,Three,Four,Five,Six] = InputList,
			case One of
				true ->
					TempList1 = "WaitForCondition(RTSIM.OUT_A, Is.Equal, 1, 1000);
			";
				false ->
					TempList1 = "WaitForCondition(RTSIM.OUT_A, Is.Equal, 0, 1000);
			"
			end,
			case Two of
				true ->
					TempList2 = "WaitForCondition(RTSIM.OUT_B, Is.Equal, 1, 1000);
			";
				false ->
					TempList2 = "WaitForCondition(RTSIM.OUT_B, Is.Equal, 0, 1000);
			"
			end,
			case Three of
				true ->
					TempList3 = "WaitForCondition(RTSIM.OUT_C, Is.Equal, 1, 1000);
			";
				false ->
					TempList3 = "WaitForCondition(RTSIM.OUT_C, Is.Equal, 0, 1000);
			"
			end,
			case Four of
				true ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 1, 1000);
			";
				false ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 0, 1000);
			"
			end,
			case Five of
				true ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 1, 1000);
			";
				false ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 0, 1000);
			"
			end,
			case Six of
				true ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 1, 1000);
			";
				false ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 0, 1000);
				"
			end,
			TCOutList = lists:append([OutputString,TempList1,TempList2,TempList3,TempList4,TempList5,TempList6]);
		{true,true,false} ->
			[One,Two,Four,Five,Six] = InputList,
			case One of
				true ->
					TempList1 = "WaitForCondition(RTSIM.OUT_A, Is.Equal, 1, 1000);
			";
				false ->
					TempList1 = "WaitForCondition(RTSIM.OUT_A, Is.Equal, 0, 1000);
			"
			end,
			case Two of
				true ->
					TempList2 = "WaitForCondition(RTSIM.OUT_B, Is.Equal, 1, 1000);
			";
				false ->
					TempList2 = "WaitForCondition(RTSIM.OUT_B, Is.Equal, 0, 1000);
			"
			end,
			case Four of
				true ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 1, 1000);
			";
				false ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 0, 1000);
			"
			end,
			case Five of
				true ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 1, 1000);
			";
				false ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 0, 1000);
			"
			end,
			case Six of
				true ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 1, 1000);
			";
				false ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 0, 1000);
			"
			end,
			TCOutList = lists:append([OutputString,TempList1,TempList2,TempList4,TempList5,TempList6]);
		{true,false,true} ->
			[One,Three,Four,Five,Six] = InputList,
			case One of
				true ->
					TempList1 = "WaitForCondition(RTSIM.OUT_A, Is.Equal, 1, 1000);
			";
				false ->
					TempList1 = "WaitForCondition(RTSIM.OUT_A, Is.Equal, 0, 1000);
			"
			end,
			case Three of
				true ->
					TempList3 = "WaitForCondition(RTSIM.OUT_C, Is.Equal, 1, 1000);
			";
				false ->
					TempList3 = "WaitForCondition(RTSIM.OUT_C, Is.Equal, 0, 1000);
			"
			end,
			case Four of
				true ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 1, 1000);
			";
				false ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 0, 1000);
			"
			end,
			case Five of
				true ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 1, 1000);
			";
				false ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 0, 1000);
			"
			end,
			case Six of
				true ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 1, 1000);
			";
				false ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 0, 1000);
			"
			end,
			TCOutList = lists:append([OutputString,TempList1,TempList3,TempList4,TempList5,TempList6]);
		{false,true,true} ->
			[Two,Three,Four,Five,Six] = InputList,
			case Two of
				true ->
					TempList2 = "WaitForCondition(RTSIM.OUT_B, Is.Equal, 1, 1000);
			";
				false ->
					TempList2 = "WaitForCondition(RTSIM.OUT_B, Is.Equal, 0, 1000);
			"
			end,
			case Three of
				true ->
					TempList3 = "WaitForCondition(RTSIM.OUT_C, Is.Equal, 1, 1000);
			";
				false ->
					TempList3 = "WaitForCondition(RTSIM.OUT_C, Is.Equal, 0, 1000);
			"
			end,
			case Four of
				true ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 1, 1000);
			";
				false ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 0, 1000);
			"
			end,
			case Five of
				true ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 1, 1000);
			";
				false ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 0, 1000);
			"
			end,
			case Six of
				true ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 1, 1000);
			";
				false ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 0, 1000);
			"
			end,
			TCOutList = lists:append([OutputString,TempList2,TempList3,TempList4,TempList5,TempList6]);
		{true,false,false} ->
			[One,Four,Five,Six] = InputList,
			case One of
				true ->
					TempList1 = "WaitForCondition(RTSIM.OUT_A, Is.Equal, 1, 1000);
			";
				false ->
					TempList1 = "WaitForCondition(RTSIM.OUT_A, Is.Equal, 0, 1000);
			"
			end,
			case Four of
				true ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 1, 1000);
			";
				false ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 0, 1000);
			"
			end,
			case Five of
				true ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 1, 1000);
			";
				false ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 0, 1000);
			"
			end,
			case Six of
				true ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 1, 1000);
			";
				false ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 0, 1000);
			"
			end,
			TCOutList = lists:append([OutputString,TempList1,TempList4,TempList5,TempList6]);
		{false,true,false} ->
			[Two,Four,Five,Six] = InputList,
			case Two of
				true ->
					TempList2 = "WaitForCondition(RTSIM.OUT_B, Is.Equal, 1, 1000);
			";
				false ->
					TempList2 = "WaitForCondition(RTSIM.OUT_B, Is.Equal, 0, 1000);
			"
			end,
			case Four of
				true ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 1, 1000);
			";
				false ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 0, 1000);
			"
			end,
			case Five of
				true ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 1, 1000);
			";
				false ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 0, 1000);
			"
			end,
			case Six of
				true ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 1, 1000);
			";
				false ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 0, 1000);
			"
			end,
			TCOutList = lists:append([OutputString,TempList2,TempList4,TempList5,TempList6]);
		{false,false,true} ->
			[Three,Four,Five,Six] = InputList,
			case Three of
				true ->
					TempList3 = "WaitForCondition(RTSIM.OUT_C, Is.Equal, 1, 1000);
			";
				false ->
					TempList3 = "WaitForCondition(RTSIM.OUT_C, Is.Equal, 0, 1000);
			"
			end,
			case Four of
				true ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 1, 1000);
			";
				false ->
					TempList4 = "WaitForCondition(RTSIM.OUTSHARE1, Is.Equal, 0, 1000);
			"
			end,
			case Five of
				true ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 1, 1000);
			";
				false ->
					TempList5 = "WaitForCondition(RTSIM.OUTSHARE2, Is.Equal, 0, 1000);
			"
			end,
			case Six of
				true ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 1, 1000);
			";
				false ->
					TempList6 = "WaitForCondition(RTSIM.OUTSHARE3, Is.Equal, 0, 1000);
			"
			end,
			TCOutList = lists:append([OutputString,TempList3,TempList4,TempList5,TempList6]);
		{false,false,false} ->
			TCOutList = "";
		{_,_,_} ->
			TCOutList = ""
	end,
	TCOutList.