import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getwidget/getwidget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AddTodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                autofocus: true,
                controller: null,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textInputAction: TextInputAction.done,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                decoration: InputDecoration.collapsed(
                  hintText: 'Enter a title',
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 26,
                      fontWeight: FontWeight.w700),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.date_range_rounded,
                    color: Colors.deepPurpleAccent,
                    size: 45,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Text(
                      "Deadline",
                      style: GoogleFonts.nunito(
                          textStyle: TextStyle(fontSize: 18)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "-",
                      style: GoogleFonts.nunito(
                          textStyle: TextStyle(fontSize: 18)),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 24.0,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 5.0,
                    percent: 0.0,
                    center: Text(
                      "0%",
                      textAlign: TextAlign.center,
                    ),
                    progressColor: Colors.green,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Text(
                      "CheckLists",
                      style: GoogleFonts.nunito(
                          textStyle: TextStyle(fontSize: 18)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.add,
                    color: Colors.green,
                    size: 24.0,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: CheckboxListTile(
                  title: Text("Do task 1"),
                  value: true,
                  onChanged: (bool? value) {},
                  activeColor: Colors.green,
                  controlAffinity: ListTileControlAffinity.leading),
            ),
          ],
        ),
      ),
    );
  }
}
