import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo/ui/projects/components/project_info_card.dart';

class ViewProject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("View project"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Project",
                    style:
                        TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
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
                        "2021-08-09",
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(fontSize: 18)),
                      ),
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
                  ],
                ),
              ),
              _projectCheckListWidget(),
              const Divider(
                height: 10,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Overall progress"),
              ),
              Center(
                child: CircularPercentIndicator(
                  radius: 200.0,
                  lineWidth: 5.0,
                  percent: 0.6,
                  center: Text(
                    "60%",
                    textAlign: TextAlign.center,
                  ),
                  progressColor: Colors.green,
                ),
              ),
              const Divider(
                height: 10,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Dependent projects"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 150,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 40,
                      itemBuilder: (context, index) {
                        // return Text("asdf");
                        return SizedBox(
                          height: 40,
                          width: 200,
                          child: ProjectInfoCard(
                              title: "test",
                              projectId: 0,
                              progress: 0.0,
                              deadline: "----",
                              onDeleteClicked: () {}),
                        );
                      }),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _projectCheckListWidget() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        child: Row(
          children: [
            Checkbox(value: false, onChanged: (bool? value) {}),
            Expanded(
              child: Text("checklist"),
            ),
          ],
        ),
      ),
    );
  }
}
