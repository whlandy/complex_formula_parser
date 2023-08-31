import 'dart:math';

import 'package:equations/equations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:getwidget/components/button/gf_button.dart';

import 'package:math_keyboard/math_keyboard.dart';


import 'complexDependencies.dart';
import 'mathToLatex.dart';

String matrixOperation = "";

List nextPageList = [];
List<Widget> stepList = [];
final ValueNotifier<List> listenList = ValueNotifier<List>(nextPageList);
late TabController _tabController;
final ScrollController _scrollController = ScrollController();
final _formKey = GlobalKey<FormState>();
final _controllerA11 = MathFieldEditingController();
final _controllerA12 = MathFieldEditingController();
final _controllerA21 = MathFieldEditingController();
final _controllerA22 = MathFieldEditingController();
final _controllerB11 = MathFieldEditingController();
final _controllerB12 = MathFieldEditingController();
final _controllerB21 = MathFieldEditingController();
final _controllerB22 = MathFieldEditingController();

late Map<String,Complex> sParA,sParB;
RegExp expLog = RegExp('log_');
RegExp expSqrt = RegExp('sqrt');

///main function
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, child) => Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: child,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Text('1'),
          onPressed: (){
            Complex arcsin = Complex(0.5, 0);


          },
        ),
        appBar: AppBar(
          title: const Text(
            'Diagram',
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Matrix-A",),
              Tab(text: "Operations",),
              Tab(text: "Matrix-B"),
            ],
          ),
        ),
        body:Flex(
          key: _formKey,
          direction: Axis.vertical,
          children: [
            Container(
              height: 200,
              child:
              TabBarView(
                  controller: _tabController,
                  children: [
                    Flex(
                      direction: Axis.horizontal,children: [
                      Flexible(
                        flex: 3,
                        child: Form(

                          child: Column(
                            children: [
                              // S11 & S12 parameters
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  //S11 Matrix
                                  Expanded(
                                    flex: 10,
                                    child: MathField(

                                      variables: ['i',"x"],
                                      onSubmitted: (value){
                                        // _formKey.currentState!.save();
                                        print(value);
                                      },
                                      controller: _controllerA11,
                                      decoration: InputDecoration(
                                        helperText: 'please type in S11',
                                        label:Math.tex('S_{11}  ',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(
                                            fontSize: 30,fontWeight:FontWeight.w500,
                                          ),
                                        ),
                                        suffix: MouseRegion(
                                          cursor: MaterialStateMouseCursor.clickable,
                                          child: GestureDetector(
                                            onTap: (){
                                              _controllerA11.clear();
                                            },
                                            child: const Icon(
                                              Icons.highlight_remove_rounded,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex:1,child: VerticalDivider(width: 1,color: Colors.black,)),
                                  //S12 Matrix
                                  Expanded(
                                    flex: 10,
                                    child: MathField(
                                      variables: ['i'],
                                      onSubmitted: (value){
                                        _formKey.currentState?.save();
                                        // sPar['S12'] = value;
                                        print(value);
                                      },
                                      controller: _controllerA12,
                                      decoration: InputDecoration(
                                        helperText: 'please type in S12',
                                        label:Math.tex('S_{12}  ',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(
                                            fontSize: 30,fontWeight:FontWeight.w500,
                                          ),
                                        ),
                                        suffix: MouseRegion(
                                          cursor: MaterialStateMouseCursor.clickable,
                                          child: GestureDetector(
                                            onTap: (){
                                              _controllerA12.clear();
                                            },
                                            child: const Icon(
                                              Icons.highlight_remove_rounded,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // S21 & S22 parameters
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  //S11 Matrix
                                  Expanded(
                                    flex: 10,
                                    child: MathField(
                                      variables: ['i'],
                                      onSubmitted: (value){
                                        _formKey.currentState?.save();
                                        // sPar['S21'] = value;
                                        print(value);
                                      },
                                      controller: _controllerA21,
                                      decoration: InputDecoration(
                                        helperText: 'please type in S21',
                                        label:Math.tex('S_{21}',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(
                                            fontSize: 30,fontWeight:FontWeight.w500,
                                          ),
                                        ),
                                        suffix: MouseRegion(
                                          cursor: MaterialStateMouseCursor.clickable,
                                          child: GestureDetector(
                                            onTap: (){
                                              _controllerA21.clear();
                                            },
                                            child: const Icon(
                                              Icons.highlight_remove_rounded,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex:1,child: VerticalDivider(width: 1,color: Colors.black,)),
                                  //S12 Matrix
                                  Expanded(
                                    flex: 10,
                                    child: MathField(
                                      variables: ['i'],
                                      onSubmitted: (value){
                                        _formKey.currentState?.save();
                                        // sPar['S22'] = value;
                                        print(value);
                                      },
                                      controller: _controllerA22,
                                      decoration: InputDecoration(
                                        helperText: 'please type in S22',
                                        label:Math.tex('S_{22}',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(
                                            fontSize: 30,fontWeight:FontWeight.w500,
                                          ),
                                        ),
                                        suffix: MouseRegion(
                                          cursor: MaterialStateMouseCursor.clickable,
                                          child: GestureDetector(
                                            onTap: (){
                                              _controllerA22.clear();
                                            },
                                            child: const Icon(
                                              Icons.highlight_remove_rounded,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],),
                    Center(
                      child: Column(
                        children: [
                          Text("Please choose operation!"),
                          Wrap(
                            spacing:  20,
                            children: [
                              GFButton(
                                  text: "+",
                                  onPressed: (){
                                    print("+");
                                    matrixOperation = "+";
                                  }
                              ),
                              GFButton(
                                  text: "-",
                                  onPressed: (){
                                    print("-");
                                    matrixOperation = "-";
                                  }
                              ),
                              GFButton(
                                  text: "*",
                                  onPressed: (){
                                    print("*");
                                    matrixOperation = "*";
                                  }
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                    Flex(
                      direction: Axis.horizontal,children: [
                      Flexible(
                        flex: 3,
                        child: Form(

                          child: Column(
                            children: [
                              // S11 & S12 parameters
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  //S11 Matrix
                                  Expanded(
                                    flex: 10,
                                    child: MathField(

                                      variables: ['i'],
                                      onSubmitted: (value){
                                        _formKey.currentState!.save();
                                        print(value);
                                      },
                                      controller: _controllerB11,
                                      decoration: InputDecoration(
                                        helperText: 'please type in S11',
                                        label:Math.tex('S_{11}  ',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(
                                            fontSize: 30,fontWeight:FontWeight.w500,
                                          ),
                                        ),
                                        suffix: MouseRegion(
                                          cursor: MaterialStateMouseCursor.clickable,
                                          child: GestureDetector(
                                            onTap: (){
                                              _controllerB11.clear();
                                            },
                                            child: const Icon(
                                              Icons.highlight_remove_rounded,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex:1,child: VerticalDivider(width: 1,color: Colors.black,)),
                                  //S12 Matrix
                                  Expanded(
                                    flex: 10,
                                    child: MathField(
                                      variables: ['i'],
                                      onSubmitted: (value){
                                        _formKey.currentState?.save();
                                        // sPar['S12'] = value;
                                        print(value);
                                      },
                                      controller: _controllerB12,
                                      decoration: InputDecoration(
                                        helperText: 'please type in S12',
                                        label:Math.tex('S_{12}  ',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(
                                            fontSize: 30,fontWeight:FontWeight.w500,
                                          ),
                                        ),
                                        suffix: MouseRegion(
                                          cursor: MaterialStateMouseCursor.clickable,
                                          child: GestureDetector(
                                            onTap: (){
                                              _controllerB12.clear();
                                            },
                                            child: const Icon(
                                              Icons.highlight_remove_rounded,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // S21 & S22 parameters
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  //S11 Matrix
                                  Expanded(
                                    flex: 10,
                                    child: MathField(
                                      variables: ['i'],
                                      onSubmitted: (value){
                                        _formKey.currentState?.save();
                                        // sPar['S21'] = value;
                                        print(value);
                                      },
                                      controller: _controllerB21,
                                      decoration: InputDecoration(
                                        helperText: 'please type in S21',
                                        label:Math.tex('S_{21}',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(
                                            fontSize: 30,fontWeight:FontWeight.w500,
                                          ),
                                        ),
                                        suffix: MouseRegion(
                                          cursor: MaterialStateMouseCursor.clickable,
                                          child: GestureDetector(
                                            onTap: (){
                                              _controllerB21.clear();
                                            },
                                            child: const Icon(
                                              Icons.highlight_remove_rounded,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(flex:1,child: VerticalDivider(width: 1,color: Colors.black,)),
                                  //S12 Matrix
                                  Expanded(
                                    flex: 10,
                                    child: MathField(
                                      variables: ['i'],
                                      onSubmitted: (value){
                                        _formKey.currentState!.save();
                                        // sPar['S22'] = value;
                                        print(value);
                                      },
                                      controller: _controllerB22,
                                      decoration: InputDecoration(
                                        helperText: 'please type in S22',
                                        label:Math.tex('S_{22}',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(
                                            fontSize: 30,fontWeight:FontWeight.w500,
                                          ),
                                        ),
                                        suffix: MouseRegion(
                                          cursor: MaterialStateMouseCursor.clickable,
                                          child: GestureDetector(
                                            onTap: (){
                                              _controllerB22.clear();
                                            },
                                            child: const Icon(
                                              Icons.highlight_remove_rounded,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],)
                  ]
              ),

            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  GFButton(
                    text: 'Print',
                    onPressed: (){
                      _formKey.currentState?.save();


                      sParA = {
                        'S11': _controllerA11.isEmpty ? Complex(0,0):stringToComplex(_controllerA11.currentEditingValue()),
                        'S12': _controllerA12.isEmpty ? Complex(0,0):stringToComplex(_controllerA12.currentEditingValue()),
                        'S21': _controllerA21.isEmpty ? Complex(0,0):stringToComplex(_controllerA21.currentEditingValue()),
                        'S22': _controllerA22.isEmpty ? Complex(0,0):stringToComplex(_controllerA22.currentEditingValue()),
                      };

                      print(sParA.toString());

                      final matrixA = ComplexMatrix.fromData(
                          columns: 2,
                          rows: 2,
                          data:  [
                            [ sParA["S11"]! , sParA["S12"]! ],
                            [ sParA["S21"]! , sParA["S22"]! ],
                          ]
                      );
                      print(matrixA.toList());

                      sParB = {
                        'S11': _controllerB11.isEmpty ? Complex(0,0):stringToComplex(_controllerB11.currentEditingValue()),
                        'S12': _controllerB12.isEmpty ? Complex(0,0):stringToComplex(_controllerB12.currentEditingValue()),
                        'S21': _controllerB21.isEmpty ? Complex(0,0):stringToComplex(_controllerB21.currentEditingValue()),
                        'S22': _controllerB22.isEmpty ? Complex(0,0):stringToComplex(_controllerB22.currentEditingValue()),
                      };

                      print(sParB.toString());

                      final matrixB = ComplexMatrix.fromData(
                          columns: 2,
                          rows: 2,
                          data:  [
                            [ sParB["S11"]! , sParB["S12"]! ],
                            [ sParB["S21"]! , sParB["S22"]! ],
                          ]
                      );
                      print(matrixB.toList());

                    },
                  ),
                  GFButton(
                      text:'result',
                      onPressed: (){
                        _formKey.currentState?.save();

                        sParA = {
                          'S11': _controllerA11.isEmpty ? Complex(0,0):stringToComplex(_controllerA11.currentEditingValue()),
                          'S12': _controllerA12.isEmpty ? Complex(0,0):stringToComplex(_controllerA12.currentEditingValue()),
                          'S21': _controllerA21.isEmpty ? Complex(0,0):stringToComplex(_controllerA21.currentEditingValue()),
                          'S22': _controllerA22.isEmpty ? Complex(0,0):stringToComplex(_controllerA22.currentEditingValue()),
                        };


                        final matrixA = ComplexMatrix.fromData(
                            columns: 2,
                            rows: 2,
                            data:  [
                              [ sParA["S11"]! , sParA["S12"]! ],
                              [ sParA["S21"]! , sParA["S22"]! ],
                            ]
                        );


                        sParB = {
                          'S11': _controllerB11.isEmpty ? Complex(0,0):stringToComplex(_controllerB11.currentEditingValue()),
                          'S12': _controllerB12.isEmpty ? Complex(0,0):stringToComplex(_controllerB12.currentEditingValue()),
                          'S21': _controllerB21.isEmpty ? Complex(0,0):stringToComplex(_controllerB21.currentEditingValue()),
                          'S22': _controllerB22.isEmpty ? Complex(0,0):stringToComplex(_controllerB22.currentEditingValue()),
                        };



                        final matrixB = ComplexMatrix.fromData(
                            columns: 2,
                            rows: 2,
                            data:  [
                              [ sParB["S11"]! , sParB["S12"]! ],
                              [ sParB["S21"]! , sParB["S22"]! ],
                            ]
                        );



                        Matrix result = ComplexMatrix.fromData(rows: 2,columns: 2, data: [[Complex(0,0),Complex(0,0)],[Complex(0,0),Complex(0,0)]]);
                        // print(result.toList());

                        if(matrixOperation.isEmpty){
                          _tabController.animateTo(1);
                        }else{
                          switch (matrixOperation) {
                            case "+":
                              result = matrixA+matrixB;
                              print("+");
                              listenList.value.clear();
                              nextPageList.addAll(matrixAddition(matrixA.toListOfList(), matrixB.toListOfList()));
                              //listenList.value = nextPageList;
                              break;

                            case "-":
                              result = matrixA-matrixB;
                              print("-");
                              listenList.value.clear();
                              nextPageList.addAll(matrixSubtraction(matrixA.toListOfList(), matrixB.toListOfList()));
                              //listenList.value = nextPageList;
                              break;

                            case "*" :
                              result = matrixA*matrixB;
                              print("*");
                              listenList.value.clear();
                              nextPageList.addAll(matrixMultiplication(matrixA.toListOfList(), matrixB.toListOfList()));
                              //listenList.value = nextPageList;
                              break;
                            default:
                              print("default");
                              break;

                          // case "/":
                          //   result = matrixA/matrixB;
                          //   print(result);
                          //   nextPageList.addAll(matrixD(matrixA.toList(), matrixB.toList()));
                          //   break;
                          /// add an Default case

                          }
                        }


                        listenList.value = nextPageList;
                        listenList.notifyListeners();
                        print("listenList：${listenList.value.toString()}");

                      }),
                ],
              ),
            ),
            ValueListenableBuilder(
                valueListenable: listenList,
                builder: (context,List listChange,child){
                  return Flexible(
                    flex: 5,
                    child:Container(
                      height: 800,
                      width: 600,
                      child: InteractiveViewer(
                        boundaryMargin: EdgeInsets.all(20.0),
                        maxScale: 1,
                        minScale: 0.1,
                        constrained: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List<Container>.generate(listChange.length, (i) {
                            return Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Row(
                                  children: [
                                    Text('$i'),
                                    Math.tex(
                                        listChange[i],
                                        // mathStyle: MathStyle.display,
                                        textStyle: const TextStyle(fontSize: 20, height: 50, color: Colors.black)
                                    ),
                                  ],
                                )
                            );
                          }),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ],
        )
    );
  }
}



