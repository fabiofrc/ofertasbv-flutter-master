import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TesteCard extends StatefulWidget {
  @override
  _TesteCardState createState() => _TesteCardState();
}

class _TesteCardState extends State<TesteCard> {
  DateTime agora;



  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');


    return Scaffold(
      appBar: AppBar(
        title: Text("Teste card"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            DateTimeField(
              //initialValue: agora,
              format: dateFormat,
              validator: (value) =>
              value == null ? "campo obrigário" : null,
             // onSaved: (value) => agora = value,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  initialDate:
                  currentValue ?? DateTime.now(),
                  locale: Locale('pt', 'BR'),
                  lastDate: DateTime(2030),
                );
              },
              onChanged: (DateTime teste){
                setState(() {
                  agora = teste;
                  print("${agora}");
                });
              },
            ),



            Text(
              "Card principal $agora",
              style: GoogleFonts.cabin(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),
            Text(
              "Card principal $agora",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ),
            Text(
              "Card principal ${DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(DateTime.now())}",
              style: GoogleFonts.abel(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[100],
                blurRadius: 4.0,
                spreadRadius: 3.5,
                offset: Offset(0.0, 2)),
          ],
        ),
      ),
    );
  }
}
