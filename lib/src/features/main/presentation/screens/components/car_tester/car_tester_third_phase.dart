import 'package:flutter/material.dart';

class CarTesterThirdPhase extends StatefulWidget {
  const CarTesterThirdPhase({super.key});

  @override
  _CarTesterThirdPhaseState createState() => _CarTesterThirdPhaseState();
}

class _CarTesterThirdPhaseState extends State<CarTesterThirdPhase> {
  final List<ChecklistItem> items = [
    ChecklistItem(
      mainDevice: 'Self-diagnosis',
      item: 'Prime mover',
      applicableParts: '',
      situation: Situation.Good,
      priceSurvey: '',
      remarks: '',
    ),
    ChecklistItem(
      mainDevice: 'Self-diagnosis',
      item: 'Transmission',
      applicableParts: '',
      situation: Situation.Good,
      priceSurvey: '',
      remarks: '',
    ),
    ChecklistItem(
      mainDevice: 'Prime mover',
      item: 'Oil leak',
      applicableParts: 'Cylinder cover (rocker arm cover)',
      situation: Situation.DoesNotExist,
      priceSurvey: '',
      remarks: '',
    ),
    // Add more items here as needed.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: buildExpansionTiles(items),
      ),
    );
  }

  List<ExpansionTile> buildExpansionTiles(List<ChecklistItem> items) {
    Map<String, List<ChecklistItem>> groupedItems = {};

    for (var item in items) {
      if (!groupedItems.containsKey(item.mainDevice)) {
        groupedItems[item.mainDevice] = [];
      }
      groupedItems[item.mainDevice]!.add(item);
    }

    return groupedItems.keys.map((mainDevice) {
      return ExpansionTile(
        title: Text(mainDevice),
        children: groupedItems[mainDevice]!
            .map((item) => ChecklistCard(
                  item: item,
                  onChanged: (situation) {
                    setState(() {
                      item.situation = situation;
                    });
                  },
                ))
            .toList(),
      );
    }).toList();
  }
}

class ChecklistItem {
  String mainDevice;
  String item;
  String applicableParts;
  Situation situation;
  String priceSurvey;
  String remarks;

  ChecklistItem({
    required this.mainDevice,
    required this.item,
    required this.applicableParts,
    required this.situation,
    required this.priceSurvey,
    required this.remarks,
  });
}

enum Situation { Good, Error, DoesNotExist, MinorOil, OilLeak }

class ChecklistCard extends StatefulWidget {
  final ChecklistItem item;
  final ValueChanged<Situation> onChanged;

  const ChecklistCard({super.key, required this.item, required this.onChanged});

  @override
  _ChecklistCardState createState() => _ChecklistCardState();
}

class _ChecklistCardState extends State<ChecklistCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item: ${widget.item.item}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('Applicable Parts: ${widget.item.applicableParts}'),
            const SizedBox(height: 5),
            const Text('Situation:'),
            buildRadioButtons(context),
            const SizedBox(height: 5),
            Text('Price Survey/Calculation Amount: ${widget.item.priceSurvey}'),
            const SizedBox(height: 5),
            Text('Remarks: ${widget.item.remarks}'),
          ],
        ),
      ),
    );
  }

  Widget buildRadioButtons(BuildContext context) {
    return Column(
      children: Situation.values.map((situation) {
        return RadioListTile<Situation>(
          title: Text(situation.toString().split('.').last),
          value: situation,
          groupValue: widget.item.situation,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                widget.onChanged(value);
              });
            }
          },
        );
      }).toList(),
    );
  }
}
