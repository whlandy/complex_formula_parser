import 'dart:math';

import 'package:equations/equations.dart';

import 'package:petitparser/petitparser.dart';

///还没有做角度和弧度的转化
///视所有的元素都带着未知数
///String output = readyToParser(input);
///final coefficientS = stringToComplex(output);


String readyToParser(String input){
  /// \}\d & \)\d are not usually used.
  String outputAddMulti = input.replaceAllMapped(RegExp(r"\d\(|\)\{i\}|\{i\}\(|\d\{"),(m) {
    List listAddMultiSign = m[0]!.split("");
    listAddMultiSign.insert(1, "*");
    return listAddMultiSign.join();
  });
  print(outputAddMulti);



  String outputReal = outputAddMulti.replaceAllMapped(RegExp(r"\d+(\.\d+)?|(?<!\d)-\d+(\.\d+)?"), (match) {
    String output = "Complex(${match[0]},0)";
    return output;
  });
  ///xxxxxxxx   可以再精简一点，检测{x}前面有没有+，-，*，/，),(
  String initOutput = outputReal.replaceAll(RegExp(r"{x}"), "Complex(1,0)*{x}");
  // String initOutput = outputReal.replaceAll(RegExp(r"{x}"), "{x}");

  String outputOrigin = initOutput.replaceAll("{i}","Complex(0, 1)");
  ///sin^{-1} to arcsin
  String arcsinChange = outputOrigin.replaceAll(RegExp(r"sin\^{Complex\(-1,0\)}"), "arcsin");
  String arccosChange = arcsinChange.replaceAll(RegExp(r"cos\^{Complex\(-1,0\)}"), "arccos");
  String arctanChange = arccosChange.replaceAll(RegExp(r"tan\^{Complex\(-1,0\)}"), "arctan");

  ///log_{}() to log_()*logArgument()
  String logChange = arctanChange.replaceAll(RegExp(r"}\("), ")*logArgument(");
  ///frac{}{} to frac()*denominator()
  String fractionChange = logChange.replaceAll(RegExp(r"}{"), ")/denominator(");
  ///sqrt[]{} to sqrt()^_sqrtBase()
  String sqrtChange = fractionChange.replaceAll("sqrt[", "sqrt_[").replaceAll(RegExp(r"]{"), ")^_sqrtBase(");

  String output = sqrtChange.replaceAll("[", "(").replaceAll("]", ")").replaceAll("{", "(").replaceAll("}", ")").replaceAll("{", "(").replaceAll("}", ")").replaceAll("\\", '');

  // print(output);
  return output;
}

Complex stringToComplex(String inputWaiting) {

  String input = readyToParser(inputWaiting);

   final builderPoly = ExpressionBuilder();

///polynomial
  final numberParser = (char('-').optional() &
  digit().plus() &
  (char('.') & digit().plus()).optional())
      .flatten()
      .trim()
      .map((value) => double.parse(value));

  final parserComplex = (
    string('Complex') &
    char('(') &
    numberParser &
    char(",") &
    numberParser &
    char(')'))
      .trim()
      .map((result) {
    final real = result[2] as double;
    final imag = result[4] as double;
    return Complex(real, imag);
  });

   final piParser = string("(pi)").map((_) => Complex(pi, 0));
   final eParser = string("(e)").map((_) => Complex(e, 0));

   final xParser = string("(x)").map((_) => "(x)");

   ///优先级最高，最先开始
   builderPoly.group().primitive(( parserComplex | piParser| eParser | xParser));

   /// argument of sqrt
   builderPoly.group().wrapper(stringIgnoreCase("sqrt_") & char("("), char(")"), (left, value, right) {
     Complex argument = value;
     Complex argumentR = Complex(1,0)/argument;
     print(argumentR);
     return argumentR;
   });

   /// base of sqrt
   builderPoly.group().wrapper(stringIgnoreCase("sqrtBase") & char("("), char(")"), (left, value, right) {
     Complex baseR = value;
     return baseR;
   });


   /// upper of fraction
   builderPoly.group().wrapper(stringIgnoreCase("frac") & char("("), char(")"), (left, value, right) {
     // Complex upper = value;
     Complex upperR = value;
     return upperR;
   });
   /// denominator(lower) of fraction
   builderPoly.group().wrapper(stringIgnoreCase("denominator") & char("("), char(")"), (left, value, right) {
     //Complex denominator = value;
     Complex denominatorR = value;
     return denominatorR;
   });



  /// base of log
   builderPoly.group().wrapper(stringIgnoreCase("log_") & char("("), char(")"), (left, value, right) {
     Complex base = value;
     Complex baseR = Complex(log(base.real), 0);
     return baseR;
   });
/// argument of log
   builderPoly.group().wrapper(stringIgnoreCase("logArgument") & char("("), char(")"), (left, value, right) {
     Complex argument = value;
     Complex argumentR = Complex(log(argument.real), 0);
     return argumentR;
   });

   /// arcsin = sin^{-1} but in the former part, {} was replaced by ()
   builderPoly.group().wrapper(stringIgnoreCase("arcsin")& char("("), char(")"), (left, value, right) {

     ///if including imaginary part  Using toString so the Complex becomes the format of x+yi, so detect "i"
     if(RegExp(r"i").hasMatch(value.toString())){
       // value = z = x+yi
       Complex z = value;
       Complex coefficient = Complex(0, -1);
       Complex arcSinLn1 = z * Complex.i();
       Complex arcSin1_z2 = Complex(1,0) - z.pow(2);
       Complex arcSinAbs = Complex(arcSin1_z2.abs(), 0).sqrt();
       Complex arcSinE = Complex(0, 0.5*arcSin1_z2.phase());
       arcSinE = arcSinE.exp();
       Complex arcSinLn = arcSinLn1 + arcSinAbs * arcSinE;
       double r = sqrt(arcSinLn.real*arcSinLn.real+arcSinLn.imaginary*arcSinLn.imaginary);
       double theta = atan2(arcSinLn.imaginary,arcSinLn.real);
       Complex lnR = Complex(log(r), theta.toDouble());
       Complex arcSinR = coefficient * lnR;
       return arcSinR;

     }else{
       Complex arcSin = value;
       Complex arcSinR = Complex(asin(arcSin.real.toDouble()), 0);
       return arcSinR;
     }
   });

   /// arccos = cos^{-1}
   builderPoly.group().wrapper(stringIgnoreCase("arccos")& char("("), char(")"), (left, value, right) {
     if(RegExp(r"i").hasMatch(value.toString())){
       // value = z = x+yi
       Complex z = value;
       Complex coefficient = Complex(0, -1);
       Complex arcSinLn1 = z;
       Complex arcSin1_z2 = Complex(1,0) - z.pow(2);
       Complex arcSinAbs = Complex(arcSin1_z2.abs(), 0).sqrt()*Complex.i();
       Complex arcSinE = Complex(0, 0.5*arcSin1_z2.phase());
       arcSinE = arcSinE.exp();
       Complex arcSinLn = arcSinLn1 + arcSinAbs * arcSinE;
       double r = sqrt(arcSinLn.real*arcSinLn.real+arcSinLn.imaginary*arcSinLn.imaginary);
       double theta = atan2(arcSinLn.imaginary,arcSinLn.real);
       Complex lnR = Complex(log(r), theta.toDouble());
       Complex arcSinR = coefficient * lnR;
       return arcSinR;

     }else {
       Complex arccos = value;
       Complex arccosR = Complex(acos(arccos.real), 0);
       return arccosR;
     }
   });

   /// arctan = tan^{-1}
   builderPoly.group().wrapper(stringIgnoreCase("arctan")& char("("), char(")"), (left, value, right) {
     if(RegExp(r"i").hasMatch(value.toString())){

       Complex arcTan = value;
       Complex arcTanLn = Complex(-arcTan.real,1-arcTan.imaginary)/Complex(arcTan.real,1+arcTan.imaginary);
       print(arcTanLn);
       double r = sqrt(arcTanLn.real*arcTanLn.real+arcTanLn.imaginary*arcTanLn.imaginary);
       double theta = atan2(arcTanLn.imaginary,arcTanLn.real);
       Complex lnR = Complex.fromImaginary(-0.5) * Complex(log(r), theta.toDouble());
       return lnR;
     }else {
       Complex arctan = value;
       Complex arctanR = Complex(atan(arctan.real), 0);
       return arctanR;
     }
   });



  builderPoly.group().wrapper(stringIgnoreCase("sin") & char("("), char(")"), (left, value, right) {
    Complex sinR = value;
    return sinR.sin();
  });

  builderPoly.group().wrapper(stringIgnoreCase("cos") & char("("), char(")"), (left, value, right) {
    Complex cosR = value;
    return cosR.cos();
  });

  builderPoly.group().wrapper(stringIgnoreCase("tan") & char("("), char(")"), (left, value, right) {
    Complex tanR = value;
    return tanR.tan();
  });

  builderPoly.group().wrapper(stringIgnoreCase("sqrt")& char("("), char(")"), (left, value, right) {
    Complex sqrtR = value;
    return sqrtR.sqrt();
  });

  ///ln support complex number
   builderPoly.group().wrapper(stringIgnoreCase("ln")& char("("), char(")"), (left, value, right) {
      Complex ln = value;

      double r = sqrt(ln.real*ln.real+ln.imaginary*ln.imaginary);
      double theta = atan2(ln.imaginary,ln.real);
      Complex lnR = Complex(log(r), theta.toDouble());

      return lnR;
   });

    ///下面的都是括号外的运算
   builderPoly.group().wrapper(char('(').trim(), char(')').trim(), (left, value, right) => value);

   builderPoly.group().prefix(char('-').trim(), (operator, value) => -value);


   ///define ^_ is the reverse version of ^ (开方)
   builderPoly.group().right(string('^_').trim(), (left, operator, right) {
     Complex powerResult = right.pow(left.real);
     return powerResult;
   });

  builderPoly.group().right(char('^').trim(), (left, operator, right) {
    Complex powerResult = left.pow(right.real);
    return powerResult;
  });



  builderPoly.group()
    ..right(string('cdot').trim(), (a, op, b) => a * b)
    ..right(char("*").trim(), (a, op, b) => a * b)
    ..right(char('/').trim(), (a, op, b) => a / b);


  builderPoly.group()
    ..left(char('+').trim(), (a, op, b) => a + b)
    ..left(char('-').trim(), (a, op, b) => a - b);

   ///优先级最低，最后开始


  final parserPoly = builderPoly.build().end();
  final result = parserPoly.parse(input);

  print(result.buffer);

  // return result.value;
   if (result.isSuccess) {
     // if(RegExp("x").hasMatch(result.toString())){
     //   return result.value.toString();
     // }
     return result.value;
   } else {
     print(result);
     print('Parsing failed at position ${result.position}: ${result.message}');
     return const Complex(0,0);

     ///写一个错误dialog
   }

}

String variables(){

  return "null";
}


Parser<double> real() {
  return char('-').optional().seq(digit().plus()
      .seq(char('.').optional().seq(digit().plus()).optional()))
      .flatten()
      .map(double.parse);
}

Parser<double> imaginary() {
  return real().optional().map((value) => value ?? 1.0);
}

