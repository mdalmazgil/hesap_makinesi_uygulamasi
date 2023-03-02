import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  String kullaniciGiris = "";
  String sonuc = "0";

  final List<String> buttonList = [
    'C', '(', ')', '/',
    '7', '8', '9', '*',
    '4', '5', '6', '+',
    '1', '2', '3', '-',
    'AC', '0', '.', '=',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Flexible(child: sonucWidget(), flex: 1,),
              Flexible(child: buttonWidget(), flex: 2,),
            ],
          ),
        ),
    );
  }

  // Kullanici tarafından girilen ifadelerin ve sonuc değerinin gosterildiği widget.
  Widget sonucWidget() {
    // return Container(color: Colors.red,);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          child: Text(
            kullaniciGiris,
            style: const TextStyle(fontSize: 32),
          ),
        ),
        Divider(),
        Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          child: Text(
            sonuc,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Buton icerisinde hesap makinesi bilesenlerinin olusturulduğu widget.
  Widget buttonWidget() {
    return GridView.builder(
      itemCount: buttonList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4
        ),
      itemBuilder: (BuildContext context, int index){
        return button(buttonList[index]);
        },
    );
  }

  Widget button(String text){
    return Container(
      margin: EdgeInsets.all(8) ,
      child: MaterialButton(onPressed: (){
        setState(() {
          buttonPress(text);
        });
      },
        color: renkGetir(text),
        textColor: Colors.white,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 25
          ),
        ),
        shape: const CircleBorder(),
      ),
    );
  }

  // Bir butonun icerdigi bilgiye gore butona tiklandiginda calisan fonksiyon.
  buttonPress(String text){
    if(text == "AC"){
      // Hesap makinesi ekrani resetlenecektir.
      kullaniciGiris = "";
      sonuc = "0";
      return;
    }
    if(text == "C"){
      // Yazilan son deger silinecektir.
      kullaniciGiris = kullaniciGiris.substring(0,kullaniciGiris.length -1);
      return;
    }
    if(text == "="){
      // Sonuc hesaplanacaktir.
      sonuc = hesapla();
      if(sonuc.endsWith(".0")) sonuc = sonuc.replaceAll(".0", "");
      return;
    }
    
    kullaniciGiris = kullaniciGiris + text;
  }

  String hesapla(){
    try {
      var exp = Parser().parse(kullaniciGiris);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return "Err";
    }
  }

  renkGetir(String text){
    if (text == "/" || text == "*" || text == "+" || text == "-") {
      return Colors.orangeAccent;
    }
    if (text == "C" || text == "AC" || text == "=") {
      return Colors.red;
    }
    if (text == "(" || text == ")") {
      return Colors.blueGrey;
    }
    return Colors.blueAccent;
  }
}

