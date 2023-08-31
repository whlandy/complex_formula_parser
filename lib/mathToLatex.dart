import 'dart:math';


import 'package:equations/equations.dart';
import 'package:math_parser/math_parser.dart';

import 'package:sprintf/sprintf.dart';


RegExp decimalDelete = RegExp('00+[0-9]');

///${name.toString} works the same as + name.toString + , especially using .method
///counting has problem to show 0 as int and calculate 0.0 as double
///scientific expression (fixing)
ScientificCounting(num num){
  ///0.2e means contain two decimal places

  late int i;
  // late String _output;
  if(num>=0){
    if(num>=100){
      i = 0;
      while(num > 10)
      {
        num = num/10.0;//别忘了小数点
        i++;
        ////print("$num:$i");
      }
      String output = sprintf('%.2f', [num])+'\\times10^{$i}';
      return output;
    } else{
      if(num<0.1) {
        if(num != 0){
          String initData = sprintf('%.2e', [num]) + "}";
          return initData.replaceAll(RegExp('e-0*'), "\\times10^{-");
        }else{
          return 0;
        }
      }else{
        if(RegExp('\\.').hasMatch(num.toString()) == true){
          String output = sprintf('%.2f', [num]);
          return output;
        }else{
          return sprintf('%d',[num]);
        }
      }
    }
  }else{
   num = -num;
   if(num>=100){
     i = 0;
     while(num > 10)
     {
       num = num/10.0;//别忘了小数点
       i++;
       ////print("$num:$i");
     }

     String output = "-${sprintf('%.2f', [num])}\\times10^{$i}";
     return output;
   } else{
     if(num<0.1) {
       String initData = '-'+sprintf('%.2e', [num]) + "}";

       return initData.replaceAll(RegExp('e-0*'), "\\times10^{-");
     }else{
       if(RegExp('\\.').hasMatch(num.toString()) == true){
         String output = '-'+sprintf('%.2f', [num]);
         return output;
       }else{
         String output = "-${sprintf('%d',[num])}";
         return output;
       }
     }
   }
  }
}

///show latex complex number addition
Addition(Complex num_1,num_2){
  List<dynamic> _displayList = ["$num_1+$num_2"];

  num _rePart1 = num_1.real;
  num _imPart1 = num_1.imaginary;
  num _rePart2 = num_2.real;
  num _imPart2 = num_2.imaginary;

  String step1 = ScientificCounting(_rePart1).toString().toString()+"+"+ScientificCounting(_rePart2).toString()
      +"+"+ScientificCounting(_imPart1).toString()+"i+"+ScientificCounting(_imPart2).toString()+"i";

  _displayList.add(step1.replaceAll(decimalDelete, ''));

  Complex step2 = Complex((_rePart1+_rePart2).toDouble(),  (_imPart1+_imPart2).toDouble() );
  _displayList.add(step2.toString());
  //print(_displayList);
  return _displayList;
}


///show latex complex number subtraction
Subtraction(Complex num_1,num_2){
  List<dynamic> _displayList = ["$num_1-$num_2"];
  num _rePart1 = num_1.real;
  num _imPart1 = num_1.imaginary;
  num _rePart2 = num_2.real;
  num _imPart2 = num_2.imaginary;
  String step1 = "${ScientificCounting(_rePart1).toString()}-${ScientificCounting(_rePart2).toString()}"
      "+${ScientificCounting(_imPart1).toString()}i-${ScientificCounting(_imPart2).toString()}i";

  // String step1 = ScientificCounting(_rePart1).toString()+'-'+ScientificCounting(_rePart2).toString()+'+'
  //     +ScientificCounting(_imPart1).toString()+"i-"+ScientificCounting(_imPart2).toString()+"i";
  _displayList.add(step1);
  Complex step2 = Complex((_rePart1-_rePart2).toDouble(),  (_imPart1-_imPart2).toDouble() );
  ///if im part is negative ignore the plus sign
  _displayList.add(step2.toString());
  //print(_displayList);
  return _displayList;
}


///show latex complex number Multiplication ----- input data format is Complex() imported by extended_math
Multiplication(Complex num_1,num_2){

    List _displayList = ["$num_1 \\times $num_2"];
    num _rePart1 = num_1.real;
    num _imPart1 = num_1.imaginary;
    num _rePart2 = num_2.real;
    num _imPart2 = num_2.imaginary;

    ///avoid name 4 Strings ----- version 3
    String step1 = "${num_1.real.toString()}\\times${num_2.real.toString()}+${num_1.real.toString()}\\times${num_2.imaginary.toString()}i+"
        "${num_2.real.toString()}\\times${num_1.real.toString()}i+${num_1.imaginary.toString()}\\times${num_2.imaginary.toString()}i^{2}";

    _displayList.add(step1.replaceAll(decimalDelete, ''));

    num _real_1 = _rePart1*_rePart2;
    num _real_2 = _imPart1*_imPart2;
    num _imaginary_1 = _rePart1*_imPart2;
    num _imaginary_2 = _imPart1*_rePart2;

    String step2 = "(${_real_1.toString()}-${_real_2.toString()})+(${_imaginary_1.toString()}+${_imaginary_2.toString()})i";

    _displayList.add(step2.replaceAll(decimalDelete, ''));

    Complex result = Complex(_real_1-_real_2.toDouble(), _imaginary_1+_imaginary_2.toDouble() );

    String resultString = "${ScientificCounting(result.real).toString()}+${ScientificCounting(result.imaginary).toString()}i";
    _displayList.add(resultString); ///error

    //print(_displayList);
    return _displayList;
  }


///show latex complex number Division ----- input data format is Complex() imported by extended_math
Division(Complex num_1,num_2){

  List<dynamic> _displayList = ["$num_1{\\div}$num_2"];
  num _rePart1 = num_1.real;
  num _imPart1 = num_1.imaginary;
  num _rePart2 = num_2.real;
  num _imPart2 = num_2.imaginary;

  ///avoid name 4 Strings ----- version 3
  String step1 = "\\frac{(${_rePart1.toString()}+${_imPart1.toString()}i)\\times(${_rePart2.toString()}-${_imPart2.toString()}i)}"
      "{(${_rePart2.toString()}+${_imPart2.toString()}i)\\times(${_rePart2.toString()}-${_imPart2.toString()}i)}";

  _displayList.add(step1.replaceAll(decimalDelete, ''));

  String step2Up = _rePart1.toString()+"\\times"+_rePart2.toString()+"-"+_rePart1.toString()
      +"\\times"+_imPart2.toString()+"i+"+_imPart1.toString()+"\\times"
      +_rePart2.toString()+"i-"+_imPart1.toString()+"\\times"+_imPart2.toString()+'i^{2}';
  String step2Below = _rePart2.toString()+"^{2}+"+_imPart2.toString()+"^{2}";
  String step2 = "\\frac{$step2Up}{$step2Below}";

  _displayList.add(step2.replaceAll(decimalDelete, ''));
  num _coefficient = (_rePart2*_rePart2)+(_imPart2*_imPart2);
  num _real_1 = _rePart1*_rePart2;
  num _real_2 = _imPart1*_imPart2;
  num _imaginary_1 = _rePart1*_imPart2;
  num _imaginary_2 = _rePart2*_imPart1;
  String step3 = "\\frac{"+_real_1.toString()+"+"+_real_2.toString()
      +"-"+_imaginary_1.toString()+"i+"+_imaginary_2.toString()
      +"i}{$_coefficient}";

  _displayList.add(step3.replaceAll(decimalDelete, ''));
  Complex result = Complex((_real_1+_real_2)/_coefficient, (_imaginary_2-_imaginary_1)/_coefficient );
  _displayList.add("${ScientificCounting(result.real).toString()}+${ScientificCounting(result.imaginary).toString()}i");
  //print(_displayList);
  return _displayList;
}




///show latex matrix addition A B (2x2
matrixAddition(List matrixA,matrixB){
  
  
  Complex num1A = matrixA[0][0];
  Complex num1B = matrixA[0][1];
  Complex num1C = matrixA[1][0];
  Complex num1D = matrixA[1][1];


  Complex num2A = matrixB[0][0];
  Complex num2B = matrixB[0][1];
  Complex num2C = matrixB[1][0];
  Complex num2D = matrixB[1][1];
  
  List _displayList = ["\\begin{bmatrix} $num1A & $num1B\\\\$num1C &$num1D \\end{bmatrix} + \\begin{bmatrix} $num2A & $num2B\\\\$num2C &$num2D \\end{bmatrix}"];
  //List _displayList =[];
  ///all Addition has 2 steps, and index 0,1
  List listA = Addition(num1A, num2A);
  List listB = Addition(num1B, num2B);
  List listC = Addition(num1C, num2C);
  List listD = Addition(num1D, num2D);
  for(int i=0; i<listA.length; i++){
    Map<String,String> stepInside = {'A':'','B':'','C':'','D':''};
    stepInside['A'] = listA[i].toString();
    stepInside['B'] = listB[i].toString();
    stepInside['C'] = listC[i].toString();
    stepInside['D'] = listD[i].toString();

    String step = "\\begin{pmatrix}${stepInside['A']} & ${stepInside['B']}\\\\${stepInside['C']} & ${stepInside['D']}\\end{pmatrix}";

    _displayList.add(step.replaceAll(decimalDelete, ''));
  }
  //print(_displayList);
  return _displayList;
}

///show latex matrix Subtraction A B (2x2
matrixSubtraction(List matrixA,matrixB){
  Complex num1A = matrixA[0][0];
  Complex num1B = matrixA[0][1];
  Complex num1C = matrixA[1][0];
  Complex num1D = matrixA[1][1];


  Complex num2A = matrixB[0][0];
  Complex num2B = matrixB[0][1];
  Complex num2C = matrixB[1][0];
  Complex num2D = matrixB[1][1];
  List _displayList = ["\\begin{bmatrix} $num1A & $num1B\\\\$num1C &$num1D \\end{bmatrix} - \\begin{bmatrix} $num2A & $num2B\\\\$num2C &$num2D \\end{bmatrix}"];
  ///all Addition has 2 steps, and index 0,1
  List listA = Subtraction(num1A, num2A);
  List listB = Subtraction(num1B, num2B);
  List listC = Subtraction(num1C, num2C);
  List listD = Subtraction(num1D, num2D);
  for(int i=0; i<listA.length; i++){
    Map<String,String> stepInside = {'A':'','B':'','C':'','D':''};
    stepInside['A'] = listA[i];
    stepInside['B'] = listB[i];
    stepInside['C'] = listC[i];
    stepInside['D'] = listD[i];

    String step = "\\begin{pmatrix}${stepInside['A']} & ${stepInside['B']}\\\\${stepInside['C']} & ${stepInside['D']}\\end{pmatrix}";

    _displayList.add(step.replaceAll(decimalDelete, ''));
  }
  // //print(_displayList);
  return _displayList;
}

///show latex matrix Multiplication A B (2x2)
matrixMultiplication(List matrixA,matrixB){
    // Complex num1A, num1B, num1C, num1D, num2A,num2B,num2C,num2D){

  Complex num1A = matrixA[0][0];
  Complex num1B = matrixA[0][1];
  Complex num1C = matrixA[1][0];
  Complex num1D = matrixA[1][1];


  Complex num2A = matrixB[0][0];
  Complex num2B = matrixB[0][1];
  Complex num2C = matrixB[1][0];
  Complex num2D = matrixB[1][1];
  List<String> _displayList = ["\\begin{bmatrix} $num1A & $num1B\\\\$num1C &$num1D \\end{bmatrix} \\times \\begin{bmatrix} $num2A & $num2B\\\\$num2C &$num2D \\end{bmatrix}"];
  ///all Addition has 3 steps, and index 0,1,2
  List listA_1 = Multiplication(num1A, num2A);
  List listA_2 = Multiplication(num1B, num2C);

  List listB_1 = Multiplication(num1A, num2B);
  List listB_2 = Multiplication(num1B, num2D);

  List listC_1 = Multiplication(num1C, num2A);
  List listC_2 = Multiplication(num1D, num2B);

  List listD_1 = Multiplication(num1C, num2B);
  List listD_2 = Multiplication(num1D, num2D);

  for(int i=0; i<listA_1.length; i++){
    Map<String,String> stepInside = {'A':'','B':'','C':'','D':''};
    stepInside['A'] = "${listA_1[i].toString()}+${listA_2[i].toString()}";
    stepInside['B'] = "${listB_1[i].toString()}+${listB_2[i].toString()}";
    stepInside['C'] = "${listC_1[i].toString()}+${listC_2[i].toString()}";
    stepInside['D'] = "${listD_1[i].toString()}+${listD_2[i].toString()}";

    String step = "\\begin{pmatrix}${stepInside['A']} & ${stepInside['B']}\\\\${stepInside['C']} & ${stepInside['D']}\\end{pmatrix}";

    _displayList.add(step.replaceAll(decimalDelete, ''));
  }

  Complex matrix_1 = (num1A*num2A)+(num1B*num2C);
  Complex matrix_2 = (num1A*num2B)+(num1B*num2D);
  Complex matrix_3 = (num1C*num2A)+(num1D*num2B);
  Complex matrix_4 = (num1C*num2B)+(num1D*num2D);

  String result = "\\begin{pmatrix}$matrix_1 & $matrix_2\\\\$matrix_3 & $matrix_4\\end{pmatrix}";

  _displayList.add(result.replaceAll(decimalDelete, ''));
  // //print(_displayList);
  return _displayList;
}

///matrix inverse (2x2)
matrixInverse(List matrix){

  Complex numA = matrix[0][0];
  Complex numB = matrix[0][1];
  Complex numC = matrix[1][0];
  Complex numD = matrix[1][1];
  List<String> _displayList = ["\\begin{bmatrix} $numA & $numB \\\\ $numC & $numD  \\end{bmatrix} ^{-1}"];
  Complex coefficient = numA*numD-numB*numC;
  Complex accompanyingA = numD;
  Complex accompanyingB = -numC;
  Complex accompanyingC = -numB;
  Complex accompanyingD = numA;

  String step = "\\frac{1}{$coefficient} \\times \\begin{bmatrix} $accompanyingA & $accompanyingB \\\\ $accompanyingC & $accompanyingD  \\end{bmatrix}";
  _displayList.add(step);

  List matrixPositionA = Division(accompanyingA, coefficient);
  List matrixPositionB = Division(accompanyingB, coefficient);
  List matrixPositionC = Division(accompanyingC, coefficient);
  List matrixPositionD = Division(accompanyingD, coefficient);

  for(int i=0; i<matrixPositionA.length; i++){
    Map<String,String> stepInside = {'A':'','B':'','C':'','D':''};
    stepInside['A'] = matrixPositionA[i].toString();
    stepInside['B'] = matrixPositionB[i].toString();
    stepInside['C'] = matrixPositionC[i].toString();
    stepInside['D'] = matrixPositionD[i].toString();

    String stepDivision = "\\begin{pmatrix} ${stepInside['A']} & ${stepInside['B']} \\\\ ${stepInside['C']} & ${stepInside['D']} \\end{pmatrix}";

    _displayList.add(stepDivision.replaceAll(decimalDelete, ''));
  }
  return _displayList;
}


///matrix multiply for n*n
matrixMultiply(List matrixA,matrixB) {
  ///matrix is defined as List =[[3,2],[4,7]]  == [ 3  2 ] ， and the matrix is filled with num form
  ///                                             [ 4  7 ]

  List _list = [];
  List _list_ = [];

  ///notice that matrix multiply needs three loops

  for (int i = 0; i < matrixA.length; i++) {          ///i represent number of column  有多少列

    for(int k=0; k <matrixA.length; k++){             ///k aims to loop one row to every column
      
      // _list.indexOf([0-3]);
    for (int j = 0; j < matrixB.length; j++) {         ///j represent number of row     有多少行


        num num1 = matrixA[i][j] * matrixB[j][k];
        _list.add(num1);
        //print(_list);

      }
    }
  }
  return _list;
}


/// arcsin/arcsin/arccos complex number

arcsinComplex(Complex complex) {

  List _displayList = [];

  Complex complexSqrt = Complex(1+complex.imaginary*complex.imaginary-complex.real*complex.real, -2*complex.real*complex.imaginary);
  String step1 = "-iLn(i$complex+\\sqrt{1-$complex^{2}})";
  _displayList.add(step1);

  if(complexSqrt.imaginary>0){   ///sqrt(a+bi) = x+yi x==complexSqrt.re; y==complexSqrt.im;  b>0___same sign; b<0___opposite sign;
    String step2 = "-iLn(i\\times$complex+\\sqrt{1-${complex.imaginary}^{2}-${complex.real}^{2}-2\\times(${complex.real}\\times${complex.imaginary}i)})";
    _displayList.add(step2);
    num lnContentRe = sqrt(0.5*(complexSqrt.real+sqrt(complexSqrt.real*complexSqrt.real+complexSqrt.imaginary*complexSqrt.imaginary)));
    num lnContentIm = sqrt(0.5*(-complexSqrt.real+sqrt(complexSqrt.real*complexSqrt.real+complexSqrt.imaginary*complexSqrt.imaginary)));
    String step3 = "-iLn(i\\times${ScientificCounting(complex.real)}+${ScientificCounting(complex.imaginary)}i\\pm${ScientificCounting(lnContentRe)}\\pm${ScientificCounting(lnContentIm)}i)";
    _displayList.add(step3);
    /// b>0  same sign
    Complex lnContentPositive = Complex( lnContentRe-complex.imaginary, lnContentIm+complex.real);
    Complex lnContentNegative = Complex( -lnContentRe-complex.imaginary, -lnContentIm+complex.real);


    String step4 = "\\left\\{\\begin{matrix} -iLn(${ScientificCounting(lnContentPositive.real)}+${ScientificCounting(lnContentPositive.imaginary)}) "
        "\\\\ -iLn(${ScientificCounting(lnContentNegative.real)}+${ScientificCounting(lnContentNegative.imaginary)}i) \\end{matrix}\\right.";
    _displayList.add(step4);

    //print(lnContentNegative);
    //print(lnContentPositive);



    String step5 = "\\left\\{\\begin{matrix}"
        "i\\times(\\ln_{}{\\sqrt{(${ScientificCounting(lnContentPositive.real)})^{2}+(${ScientificCounting(lnContentPositive.imaginary)})^{2}+"
        "\\arctan\\frac{${ScientificCounting(lnContentPositive.imaginary)}}{${ScientificCounting(lnContentPositive.real)}}}})  "
        "\\\\  i\\times(\\ln_{}{\\sqrt{(${ScientificCounting(lnContentNegative.real)})^{2}+(${ScientificCounting(lnContentNegative.imaginary)})^{2}+"
        "\\arctan\\frac{${ScientificCounting(lnContentNegative.imaginary)}}{${ScientificCounting(lnContentNegative.real)}}}})"
        "\\end{matrix}\\right.";
    _displayList.add(step5);

    num r1 = sqrt(lnContentPositive.real*lnContentPositive.real+lnContentPositive.imaginary*lnContentPositive.imaginary);
    num r2 = sqrt(lnContentNegative.real*lnContentNegative.real+lnContentNegative.imaginary*lnContentNegative.imaginary);

    num theta1 = MathNodeExpression.fromString('atan(${lnContentPositive.imaginary}/${lnContentPositive.real})',).calc(MathVariableValues({'x': 0}),);
    num theta2 = MathNodeExpression.fromString('atan(${lnContentNegative.imaginary}/${lnContentNegative.real})',).calc(MathVariableValues({'x': 0}),);

    String step6 = "\\left\\{\\begin{matrix} -${ScientificCounting(theta1)}+\\ln_{}{${ScientificCounting(r1)}}  "
        "\\\\  -${ScientificCounting(theta2)}+\\ln_{}{${ScientificCounting(r2)}}  \\end{matrix}\\right.";
    _displayList.add(step6);

    //print(theta1);
    //print(theta2);

    num resultPositiveRe =
    MathNodeExpression.fromString('ln($r1)',)
        .calc(MathVariableValues({'x': 0}),);

    //print(resultPositiveRe);

    Complex resultPositive = Complex( theta1.toDouble(),  -resultPositiveRe.toDouble());


    num resultNegativeRe =
    MathNodeExpression.fromString('ln($r2)',)
        .calc(MathVariableValues({'x': 0}),);

    //print(resultNegativeRe);

    Complex resultNegative = Complex( theta2.toDouble(),  -resultNegativeRe.toDouble());
    String step7 = "\\left\\{\\begin{matrix} ${ScientificCounting(resultPositive.real)}+${ScientificCounting(resultPositive.imaginary)}i  "
        "\\\\  ${ScientificCounting(resultNegative.real)}+${ScientificCounting(resultNegative.imaginary)}i  \\end{matrix}\\right.";
    _displayList.add(step7);
    return _displayList;

  }else{
    String step2 = "-iLn(i\\times$complex+\\sqrt{1-${complex.imaginary}^{2}-${complex.real}^{2}-2\\times(${complex.real}\\times${complex.imaginary}i)})";
    _displayList.add(step2);
    num lnContentRe = sqrt(0.5*(complexSqrt.real+sqrt(complexSqrt.real*complexSqrt.real+complexSqrt.imaginary*complexSqrt.imaginary)));
    num lnContentIm = sqrt(0.5*(-complexSqrt.real+sqrt(complexSqrt.real*complexSqrt.real+complexSqrt.imaginary*complexSqrt.imaginary)));
    String step3 = "-iLn(i\\times${ScientificCounting(complex.real)}+${ScientificCounting(complex.imaginary)}i\\pm${ScientificCounting(lnContentRe)}\\mp${ScientificCounting(lnContentIm)}i)";
    _displayList.add(step3);
    /// b>0  same sign
    Complex lnContentPositive = Complex(-lnContentRe-complex.imaginary, lnContentIm+complex.real);
    Complex lnContentNegative = Complex( lnContentRe-complex.imaginary, -lnContentIm+complex.real);
    String step4 = "\\left\\{\\begin{matrix} -iLn(${ScientificCounting(lnContentPositive.real)}+${ScientificCounting(lnContentPositive.imaginary)}) "
        "\\\\ -iLn(${ScientificCounting(lnContentNegative.real)}+${ScientificCounting(lnContentNegative.imaginary)}i) \\end{matrix}\\right.";
    _displayList.add(step4);

    //print(lnContentNegative);
    //print(lnContentPositive);

    String step5 = "\\left\\{\\begin{matrix}"
        "i\\times(\\ln_{}{\\sqrt{(${ScientificCounting(lnContentPositive.real)})^{2}+(${ScientificCounting(lnContentPositive.imaginary)})^{2}+"
        "\\arctan\\frac{${ScientificCounting(lnContentPositive.imaginary)}}{${ScientificCounting(lnContentPositive.real)}}}})  "
        "\\\\  i\\times(\\ln_{}{\\sqrt{(${ScientificCounting(lnContentNegative.real)})^{2}+(${ScientificCounting(lnContentNegative.imaginary)})^{2}+"
        "\\arctan\\frac{${ScientificCounting(lnContentNegative.imaginary)}}{${ScientificCounting(lnContentNegative.real)}}}})"
        "\\end{matrix}\\right.";
    _displayList.add(step5);

    num r1 = sqrt(lnContentPositive.real*lnContentPositive.real+lnContentPositive.imaginary*lnContentPositive.imaginary);
    num r2 = sqrt(lnContentNegative.real*lnContentNegative.real+lnContentNegative.imaginary*lnContentNegative.imaginary);

    num theta1 = MathNodeExpression.fromString('atan(${lnContentPositive.imaginary}/${lnContentPositive.real})',).calc(MathVariableValues({'x': 0}),);
    num theta2 = MathNodeExpression.fromString('atan(${lnContentNegative.imaginary}/${lnContentNegative.real})',).calc(MathVariableValues({'x': 0}),);
    String step6 = "\\left\\{\\begin{matrix} -${ScientificCounting(theta1)}+\\ln_{}{${ScientificCounting(r1)}}  "
        "\\\\  -${ScientificCounting(theta2)}+\\ln_{}{${ScientificCounting(r2)}}  \\end{matrix}\\right.";
    _displayList.add(step6);
    //print(theta1);
    //print(theta2);

    num resultPositiveRe =
    MathNodeExpression.fromString('ln($r1)',)
        .calc(MathVariableValues({'x': 0}),);

    //print(resultPositiveRe);

    Complex resultPositive = Complex( theta1.toDouble(),  -resultPositiveRe.toDouble());


    num resultNegativeRe =
    MathNodeExpression.fromString('ln($r2)',)
        .calc(MathVariableValues({'x': 0}),);

    //print(resultNegativeRe);

    Complex resultNegative = Complex( theta2.toDouble(),  -resultNegativeRe.toDouble());

    String step7 = "\\left\\{\\begin{matrix} ${ScientificCounting(resultPositive.real)}+${ScientificCounting(resultPositive.imaginary)}i  "
        "\\\\  ${ScientificCounting(resultNegative.real)}+${ScientificCounting(resultNegative.imaginary)}i  \\end{matrix}\\right.";
    _displayList.add(step7);
    return _displayList;

  }
}
arccosComplex(Complex complex) {
  List _displayList = [];
  Complex complexSqrt = Complex(
       1 + complex.imaginary * complex.imaginary - complex.real * complex.real,
       -2 * complex.real * complex.imaginary);
  String step1 = "-iLn(i$complex+\\sqrt{1-$complex^{2}})";
  _displayList.add(step1);
  if (complexSqrt.imaginary > 0) {
    ///sqrt(a+bi) = x+yi x==complexSqrt.real; y==complexSqrt.imaginary;  b>0___same sign; b<0___opposite sign;
    String step2 = "-iLn($complex+i\\times\\sqrt{1-${complex.imaginary}^{2}-${complex
        .real}^{2}-2\\times(${complex.real}\\times${complex.imaginary}i)})";
    _displayList.add(step2);
    num lnContentRe = sqrt(0.5 * (complexSqrt.real + sqrt(
        complexSqrt.real * complexSqrt.real + complexSqrt.imaginary * complexSqrt.imaginary)));
    num lnContentIm = sqrt(0.5 * (-complexSqrt.real + sqrt(
        complexSqrt.real * complexSqrt.real + complexSqrt.imaginary * complexSqrt.imaginary)));
    String step3 = "-iLn(${ScientificCounting(complex.real)}+${ScientificCounting(
        complex.imaginary)}i+i\\times(\\pm${ScientificCounting(
        lnContentRe)}\\pm${ScientificCounting(lnContentIm)}i))";
    _displayList.add(step3);

    /// b>0  same sign
    Complex lnContentPositive = Complex(
         complex.real - lnContentIm,  complex.imaginary + lnContentRe);
    Complex lnContentNegative = Complex(
         complex.real + lnContentIm,  complex.imaginary - lnContentRe);
    String step4 = "\\left\\{\\begin{matrix} -iLn(${ScientificCounting(
        lnContentPositive.real)}+${ScientificCounting(lnContentPositive.imaginary)}) "
        "\\\\ -iLn(${ScientificCounting(
        lnContentNegative.real)}+${ScientificCounting(
        lnContentNegative.imaginary)}i) \\end{matrix}\\right.";
    _displayList.add(step4);

    //print(lnContentNegative);
    //print(lnContentPositive);
    String step5 = "\\left\\{\\begin{matrix}"
        "i\\times(\\ln_{}{\\sqrt{(${ScientificCounting(
        lnContentPositive.real)})^{2}+(${ScientificCounting(
        lnContentPositive.imaginary)})^{2}+"
        "\\arctan\\frac{${ScientificCounting(
        lnContentPositive.imaginary)}}{${ScientificCounting(
        lnContentPositive.real)}}}})  "
        "\\\\  i\\times(\\ln_{}{\\sqrt{(${ScientificCounting(
        lnContentNegative.real)})^{2}+(${ScientificCounting(
        lnContentNegative.imaginary)})^{2}+"
        "\\arctan\\frac{${ScientificCounting(
        lnContentNegative.imaginary)}}{${ScientificCounting(lnContentNegative.real)}}}})"
        "\\end{matrix}\\right.";
    _displayList.add(step5);
    num r1 = sqrt(lnContentPositive.real * lnContentPositive.real +
        lnContentPositive.imaginary * lnContentPositive.imaginary);
    num r2 = sqrt(lnContentNegative.real * lnContentNegative.real +
        lnContentNegative.imaginary * lnContentNegative.imaginary);

    num theta1 = MathNodeExpression.fromString(
      'atan(${lnContentPositive.imaginary}/${lnContentPositive.real})',).calc(
      MathVariableValues({'x': 0}),);
    num theta2 = MathNodeExpression.fromString(
      'atan(${lnContentNegative.imaginary}/${lnContentNegative.real})',).calc(
      MathVariableValues({'x': 0}),);

    //print(theta1);
    //print(theta2);
    String step6 = "\\left\\{\\begin{matrix} -${ScientificCounting(
        theta1)}+\\ln_{}{${ScientificCounting(r1)}}  "
        "\\\\  -${ScientificCounting(theta2)}+\\ln_{}{${ScientificCounting(
        r2)}}  \\end{matrix}\\right.";
    _displayList.add(step6);

    num resultPositiveRe =
    MathNodeExpression.fromString('ln($r1)',).calc(
      MathVariableValues({'x': 0}),);

    //print(resultPositiveRe);

    Complex resultPositive = Complex( theta1.toDouble(),  -resultPositiveRe.toDouble());


    num resultNegativeRe =
    MathNodeExpression.fromString('ln($r2)',).calc(
      MathVariableValues({'x': 0}),);

    //print(resultNegativeRe);

    Complex resultNegative = Complex( theta2.toDouble(),  -resultNegativeRe.toDouble());

    String step7 = "\\left\\{\\begin{matrix} ${ScientificCounting(
        resultPositive.real)}+${ScientificCounting(resultPositive.imaginary)}i  "
        "\\\\  ${ScientificCounting(resultNegative.real)}+${ScientificCounting(
        resultNegative.imaginary)}i  \\end{matrix}\\right.";
    _displayList.add(step7);
    return _displayList;
  } else {
    String step2 = "-iLn($complex+i\\times\\sqrt{1-${complex.imaginary}^{2}-${complex
        .real}^{2}-2\\times(${complex.real}\\times${complex.imaginary}i)})";
    _displayList.add(step2);
    num lnContentRe = sqrt(0.5 * (complexSqrt.real + sqrt(
        complexSqrt.real * complexSqrt.real + complexSqrt.imaginary * complexSqrt.imaginary)));
    num lnContentIm = sqrt(0.5 * (-complexSqrt.real + sqrt(
        complexSqrt.real * complexSqrt.real + complexSqrt.imaginary * complexSqrt.imaginary)));
    String step3 = "-iLn(${ScientificCounting(complex.real)}+${ScientificCounting(
        complex.imaginary)}i+i\\times(\\pm${ScientificCounting(
        lnContentRe)}\\mp${ScientificCounting(lnContentIm)}i))";
    _displayList.add(step3);

    /// b<0  opposite sign
    Complex lnContentPositive = Complex(
         complex.real + lnContentIm,  complex.imaginary + lnContentRe);
    Complex lnContentNegative = Complex(
         complex.real - lnContentIm,  complex.imaginary - lnContentRe);
    String step4 = "\\left\\{\\begin{matrix} -iLn(${ScientificCounting(
        lnContentPositive.real)}+${ScientificCounting(lnContentPositive.imaginary)}) "
        "\\\\ -iLn(${ScientificCounting(
        lnContentNegative.real)}+${ScientificCounting(
        lnContentNegative.imaginary)}i) \\end{matrix}\\right.";
    _displayList.add(step4);

    //print(lnContentNegative);
    //print(lnContentPositive);
    String step5 = "\\left\\{\\begin{matrix}"
        "i\\times(\\ln_{}{\\sqrt{(${ScientificCounting(
        lnContentPositive.real)})^{2}+(${ScientificCounting(
        lnContentPositive.imaginary)})^{2}+"
        "\\arctan\\frac{${ScientificCounting(
        lnContentPositive.imaginary)}}{${ScientificCounting(
        lnContentPositive.real)}}}})  "
        "\\\\  i\\times(\\ln_{}{\\sqrt{(${ScientificCounting(
        lnContentNegative.real)})^{2}+(${ScientificCounting(
        lnContentNegative.imaginary)})^{2}+"
        "\\arctan\\frac{${ScientificCounting(
        lnContentNegative.imaginary)}}{${ScientificCounting(lnContentNegative.real)}}}})"
        "\\end{matrix}\\right.";
    _displayList.add(step5);
    num r1 = sqrt(lnContentPositive.real * lnContentPositive.real +
        lnContentPositive.imaginary * lnContentPositive.imaginary);
    num r2 = sqrt(lnContentNegative.real * lnContentNegative.real +
        lnContentNegative.imaginary * lnContentNegative.imaginary);

    num theta1 = MathNodeExpression.fromString(
      'atan(${lnContentPositive.imaginary}/${lnContentPositive.real})',).calc(
      MathVariableValues({'x': 0}),);
    num theta2 = MathNodeExpression.fromString(
      'atan(${lnContentNegative.imaginary}/${lnContentNegative.real})',).calc(
      MathVariableValues({'x': 0}),);

    //print(theta1);
    //print(theta2);
    String step6 = "\\left\\{\\begin{matrix} -${ScientificCounting(
        theta1)}+\\ln_{}{(${ScientificCounting(r1)})}  "
        "\\\\  -(${ScientificCounting(theta2)})+\\ln_{}{(${ScientificCounting(
        r2)})}  \\end{matrix}\\right.";
    _displayList.add(step6);

    num resultPositiveRe =
    MathNodeExpression.fromString('ln($r1)',).calc(
      MathVariableValues({'x': 0}),);

    //print(resultPositiveRe);

    Complex resultPositive = Complex(theta1.toDouble(),  -resultPositiveRe.toDouble());


    num resultNegativeRe =
    MathNodeExpression.fromString('ln($r2)',).calc(
      MathVariableValues({'x': 0}),);

    //print(resultNegativeRe);

    Complex resultNegative = Complex( theta2.toDouble(),  -resultNegativeRe.toDouble());

    simplification(num imPart) {
      if (imPart > 0) {
        return "+${ScientificCounting(imPart)}";
      }
      if (imPart < 0) {
        return "${ScientificCounting(imPart)}";
      }
    }
      //print(simplification(resultPositive.imaginary));


      String step7 = "\\left\\{\\begin{matrix} ${ScientificCounting(resultPositive.real)}+${simplification(resultPositive.imaginary)}i  "
          "\\\\  ${ScientificCounting(resultNegative.real)} ${simplification(resultNegative.imaginary)}i  \\end{matrix}\\right.";
      _displayList.add(step7);
      return _displayList;

  }
}
arctanComplex(Complex complex) {
    List _displayList = [];
    String step1 = "\\frac{1}{2i}\\times Ln(\\frac{1+i\\times($complex)}{1-i\\times($complex)})";
    _displayList.add(step1);
    Complex upComplex = Complex( 1 - complex.imaginary,  complex.real);
    Complex downComplex = Complex( 1 + complex.imaginary,  -complex.real);

    String step2 = "\\frac{1}{2i}\\times Ln(\\frac{$upComplex}{$downComplex})";
    _displayList.add(step2);
    //print(upComplex);
    //print(downComplex);
    num _coefficient = (downComplex.real * downComplex.real) +
        (downComplex.imaginary * downComplex.imaginary);
    //print(_coefficient);
    num _real_1 = upComplex.real * downComplex.real;
    num _real_2 = upComplex.imaginary * downComplex.imaginary;
    num _imaginary_1 = upComplex.real * downComplex.imaginary;
    num _imaginary_2 = downComplex.real * upComplex.imaginary;
    Complex lnContent = Complex( (_real_1 + _real_2) / _coefficient,
         (_imaginary_2 - _imaginary_1) / _coefficient);
    List divisionList = Division(upComplex, downComplex);
    for (int i = 1; i < divisionList.length; i++) {
      String step = "\\frac{1}{2i}\\times Ln(${divisionList[i]})";
      _displayList.add(step);
    }
    //print(lnContent);

    num r = sqrt(lnContent.real * lnContent.real + lnContent.imaginary * lnContent.imaginary);
    num theta = MathNodeExpression.fromString(
      'atan(${lnContent.imaginary}/${lnContent.real})',).calc(
      MathVariableValues({'x': 0}),);

    num lnr = MathNodeExpression.fromString('ln($r)',).calc(
      MathVariableValues({'x': 0}),);

    String step6 = "\\frac{${ScientificCounting(lnr)}+${ScientificCounting(
        theta)}i}{2i}";
    _displayList.add(step6);
    if (theta < 0) {
      Complex result = Complex( 0.5 * (theta + pi),  -0.5 * (lnr));
      String step7 = "${ScientificCounting(result.real)}+${ScientificCounting(
          result.imaginary)}i";
      _displayList.add(step7);
      return _displayList;
    } else {
      Complex result = Complex(0.5 * (theta),  -0.5 * (lnr));
      String step7 = "${ScientificCounting(result.real)}+${ScientificCounting(
          result.imaginary)}i";
      _displayList.add(step7);
      return _displayList;
    }
  }
