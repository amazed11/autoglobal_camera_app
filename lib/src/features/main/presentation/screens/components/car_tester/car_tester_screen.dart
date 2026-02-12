import 'package:flutter/material.dart';

import 'car_tester_first_phase.dart';
import 'car_tester_second_phase.dart';
import 'car_tester_third_phase.dart';

class CarTesterScreen extends StatefulWidget {
  const CarTesterScreen({super.key});

  @override
  _CarTesterScreenState createState() => _CarTesterScreenState();
}

class _CarTesterScreenState extends State<CarTesterScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _presentationNumberController =
      TextEditingController();
  final TextEditingController _borrowedNameController =
      TextEditingController(text: "Tucson Hybrid (NX4) Inspiration 4WD");
  final TextEditingController _modelYearController =
      TextEditingController(text: "2021");
  final TextEditingController _carRegistrationNumberController =
      TextEditingController();
  final TextEditingController _testValidityPeriodStartController =
      TextEditingController();
  final TextEditingController _testValidityPeriodEndController =
      TextEditingController();
  final TextEditingController _firstRegistrationDateController =
      TextEditingController();
  final TextEditingController _transmissionTypeController =
      TextEditingController();
  final TextEditingController _fuelUsedController = TextEditingController();
  final TextEditingController _vehicleIdentificationNumberController =
      TextEditingController();
  final TextEditingController _primeMoverTypeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Generation'),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          _buildPresentationNumberForm(),
          _buildPerformanceInspectionRecordForm(),
          const CarTesterFirstPhase(),
          const CarTesterSecondPhase(),
          const CarTesterThirdPhase(),
        ],
      ),
    );
  }

  Widget _buildPresentationNumberForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter the presentation number and performance inspection record.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _presentationNumberController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Presentation number',
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'If a trading member fails to record or falsely enters important information (presentation number, performance record, association/companies name), a fine of up to 100 million won will be imposed in accordance with the Act on Fair Labeling and Advertising (Article 20, Paragraph 1, No. 1).',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceInspectionRecordForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            'Performance inspection record',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            '• You can enter the items below directly or register with a photo in the performance inspection record.',
            style: TextStyle(fontSize: 14),
          ),
          const Text(
            '• After registration, you can edit it only once within 48 hours on My Page and cannot delete it.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          Table(
            border: TableBorder.all(color: Colors.grey),
            children: [
              _buildTableRow('Borrowed Name', _borrowedNameController),
              _buildTableRow('Model Year', _modelYearController),
              _buildTableRow(
                  'Car Registration Number', _carRegistrationNumberController),
              _buildTableRowWithDatePicker(
                  'Test validity period',
                  _testValidityPeriodStartController,
                  _testValidityPeriodEndController),
              _buildTableRow(
                  'First registration date', _firstRegistrationDateController),
              _buildTableRow('Transmission type', _transmissionTypeController),
              _buildTableRow('Fuel used', _fuelUsedController),
              _buildTableRow('Vehicle Identification Number',
                  _vehicleIdentificationNumberController),
              _buildTableRow('Prime Mover Type', _primeMoverTypeController),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: const Text('Previous'),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, TextEditingController controller) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRowWithDatePicker(
      String label,
      TextEditingController startController,
      TextEditingController endController) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: startController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Start date',
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await _selectDate(context);
                    if (pickedDate != null) {
                      startController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    }
                  },
                ),
              ),
            ),
            const Text(' ~ '),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: endController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'End date',
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await _selectDate(context);
                    if (pickedDate != null) {
                      endController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return pickedDate;
  }
}
