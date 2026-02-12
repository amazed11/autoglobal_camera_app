import 'package:autoglobal_camera_app/src/core/app/dimensions.dart';
import 'package:autoglobal_camera_app/src/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CarTesterSecondPhase extends StatefulWidget {
  const CarTesterSecondPhase({super.key});

  @override
  _CarTesterFirstSecondState createState() => _CarTesterFirstSecondState();
}

class _CarTesterFirstSecondState extends State<CarTesterSecondPhase> {
  final List<Map<String, dynamic>> parts = [
    {'rank': 1, 'name': 'Front panel', 'selected': ''},
    {'rank': 2, 'name': 'Cross member', 'selected': ''},
    {'rank': 3, 'name': 'Inside panel (left)', 'selected': ''},
    {'rank': 4, 'name': 'Inside panel (right)', 'selected': ''},
    {'rank': 5, 'name': 'Rear panel', 'selected': ''},
    {'rank': 6, 'name': 'Trunk floor', 'selected': ''},
    {'rank': 7, 'name': 'Front side member (left)', 'selected': ''},
    {'rank': 8, 'name': 'Front side member (right)', 'selected': ''},
    {'rank': 9, 'name': 'Rear side member (left)', 'selected': ''},
    {'rank': 10, 'name': 'Rear side member (right)', 'selected': ''},
    {'rank': 11, 'name': 'Front wheel house (left)', 'selected': ''},
    {'rank': 12, 'name': 'Front wheel house (right)', 'selected': ''},
    {'rank': 13, 'name': 'Rear wheel house (left)', 'selected': ''},
    {'rank': 14, 'name': 'Rear wheel house (right)', 'selected': ''},
    {'rank': 15, 'name': 'Pillar panel A (left)', 'selected': ''},
    {'rank': 16, 'name': 'Pillar panel A (right)', 'selected': ''},
    {'rank': 17, 'name': 'Pillar panel B (left)', 'selected': ''},
    {'rank': 18, 'name': 'Pillar panel B (right)', 'selected': ''},
    {'rank': 19, 'name': 'Pillar panel C (left)', 'selected': ''},
    {'rank': 20, 'name': 'Pillar panel C (right)', 'selected': ''},
    {'rank': 21, 'name': 'Package tray', 'selected': ''},
    {'rank': 22, 'name': 'Dish panel', 'selected': ''},
    {'rank': 23, 'name': 'Floor panel', 'selected': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Sheet metal, welding repair, replacement and corrosion of major skeleton parts",
          ),
        ),
        vSizedBox2,
        _buildOptionHeader(),
        vSizedBox2,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildCheckboxHeader(),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: parts.length,
            itemBuilder: (context, index) {
              final part = parts[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    part['name'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: _buildCheckboxRow(part, index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOptionHeader() {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: [
        CustomText.ourText(
          'Exchange (B)',
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        CustomText.ourText(
          'Sheet Metal/Welding (C)',
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        CustomText.ourText(
          'Corrosion (D)',
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        CustomText.ourText(
          'Scratch (E)',
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        CustomText.ourText(
          'Irregularities (F)',
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        CustomText.ourText(
          'Damaged (G)',
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ],
    );
  }

  Widget _buildCheckboxHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomText.ourText(
            'B',
            fontWeight: FontWeight.bold,
          ),
          CustomText.ourText(
            'C',
            fontWeight: FontWeight.bold,
          ),
          CustomText.ourText(
            'D',
            fontWeight: FontWeight.bold,
          ),
          CustomText.ourText(
            'E',
            fontWeight: FontWeight.bold,
          ),
          CustomText.ourText(
            'F',
            fontWeight: FontWeight.bold,
          ),
          CustomText.ourText(
            'G',
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxRow(Map<String, dynamic> part, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCheckbox('B', part, index),
        _buildCheckbox('C', part, index),
        _buildCheckbox('D', part, index),
        _buildCheckbox('E', part, index),
        _buildCheckbox('F', part, index),
        _buildCheckbox('G', part, index),
      ],
    );
  }

  Widget _buildCheckbox(String title, Map<String, dynamic> part, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: part['selected'] == title,
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                parts[index]['selected'] = title;
              } else {
                parts[index]['selected'] = '';
              }
            });
          },
        ),
      ],
    );
  }
}
