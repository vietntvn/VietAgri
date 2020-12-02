import 'package:flutter/material.dart';
import 'package:vietagri/models/Area.dart';
import 'package:vietagri/pages/area/area-detail.dart';
import 'package:vietagri/widgets/create-area-widget.dart';
import 'package:vietagri/widgets/header.dart';

class StepByStepProduction extends StatefulWidget {
  final Area area;

  StepByStepProduction({ this.area });

  @override
  _StepByStepProductionState createState() => _StepByStepProductionState();
}

class _StepByStepProductionState extends State<StepByStepProduction> {
  bool shouldShowDivider = true;
  

  List<TableRow> loadProductionTable(String period, String stageStartDate, String stageEndDate, String taskStartDate, String taskEndDate) {
    List<TableRow> tasks = [];
    tasks.add(TableRow(
      children: [
        cellPadding(
          Text(
            "No.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        cellPadding(
          Text(
            "Task",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        cellPadding(
          Text(
            "Repeat",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        cellPadding(
          Text(
            "Days",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ));
    List stages = widget.area.riceSeed.stages.where((i) => i['period'] == period && i['startDate'] == stageStartDate && i['endDate'] == stageEndDate).toList();
    List stageTasks = stages.length > 0 ? stages[0]['tasks'].where((i) => i['startDate'] == taskStartDate && i['endDate'] == taskEndDate).toList() : [];
    for (int i = 0; i < stageTasks.length; i++) {
      tasks.add(TableRow(children: [
        cellPadding(Text("${i + 1}")),
        cellPadding(Text("${stageTasks[i]['task']}", overflow: TextOverflow.ellipsis,)),
        cellPadding(Text("${stageTasks[i]['repeat']} times")),
        cellPadding(Text("${stageTasks[i]['days']}"))
      ]));
    }
    return tasks;
  }

  Widget productionTable(String period, String stageStartDate, String stageEndDate, String taskStartDate, String taskEndDate) {
    return Table(
      border: TableBorder(
        top: tableBorder(),
        right: tableBorder(),
        bottom: tableBorder(),
        left: tableBorder(),
        horizontalInside: tableBorder(),
      ),
      columnWidths: {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(2)
      },
      children: loadProductionTable(period, stageStartDate, stageEndDate, taskStartDate, taskEndDate)
    );
  }

  Widget productionStage(String stage, String days) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        children: [
          TextSpan(
            text: "$stage",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: "$days")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        title: "Step-by-step production",
        showSearchIcon: false,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(15.0),
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.orange[100],
                    border: Border.all(color: Colors.orange[200]),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Text(
                    "The standard production is divided follow different periods (06 month = 180 days)"),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              ExpansionTile(
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                onExpansionChanged: (bool isOpen) {
                  setState(() => shouldShowDivider = !isOpen);
                },
                title: Text(
                  "1. First period (60 days)",
                  style: TextStyle(color: Colors.green),
                ),
                children: [
                  productionStage("- First stage", "(01st day - 20th day)"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("+ 01st day - 05th day: Do the following tasks"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("1", "1", "20", "1", "5"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("+ 06th - 10th: Do the following tasks"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("1", "1", "20", "6", "10"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("+ 10th - 15th: Do the following tasks"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("1", "1", "20", "10", "15"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("+ 15th - 20th: Do the following tasks"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("1", "1", "20", "15", "20"),

                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionStage("- Second stage", "(20th day - 40th day)"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("1", "20", "40", "1", "40"),

                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionStage("- Third stage", "(40th day - 60th day)"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("1", "40", "60", "1", "60")
                ],
              ),
              shouldShowDivider ? Divider() : Text(''),
              ExpansionTile(
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                onExpansionChanged: (bool isOpen) {
                  setState(() => shouldShowDivider = !isOpen);
                },
                title: Text(
                  "2. Second period (60 days)",
                  style: TextStyle(color: Colors.green),
                ),
                children: [
                  productionStage("- First stage", "(01st day - 20th day)"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("+ 01st day - 05th day: Do the following tasks"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("2", "1", "20", "1", "5"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("+ 06th - 10th: Do the following tasks"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("2", "1", "20", "6", "10"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("+ 10th - 15th: Do the following tasks"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("2", "1", "20", "10", "15"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("+ 15th - 20th: Do the following tasks"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("2", "1", "20", "15", "20"),

                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionStage("- Second stage", "(20th day - 40th day)"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("2", "20", "40", "1", "40"),

                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionStage("- Third stage", "(40th day - 60th day)"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("2", "40", "60", "1", "60")
                ],
              ),
              shouldShowDivider ? Divider() : Text(''),
              ExpansionTile(
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                onExpansionChanged: (bool isOpen) {
                  setState(() => shouldShowDivider = !isOpen);
                },
                title: Text(
                  "3. Third period (60 days)",
                  style: TextStyle(color: Colors.green),
                ),
                children: [
                  productionStage("- First stage", "(01st day - 20th day)"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("+ 01st day - 05th day: Do the following tasks"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("3", "1", "20", "1", "5"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("+ 06th - 10th: Do the following tasks"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("3", "1", "20", "6", "10"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("+ 10th - 15th: Do the following tasks"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("3", "1", "20", "10", "15"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text("+ 15th - 20th: Do the following tasks"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("3", "1", "20", "15", "20"),

                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionStage("- Second stage", "(20th day - 40th day)"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("3", "20", "40", "1", "40"),

                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionStage("- Third stage", "(40th day - 60th day)"),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  productionTable("3", "40", "60", "1", "60")
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: createAreaWidget(context)
          )
        ],
      )
    );
  }
}
