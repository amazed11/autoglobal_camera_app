import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({super.key, required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  double _pitch = 0.0; // Rotation around X-axis
  double _roll = 0.0; // Rotation around Z-axis
  double _distance = 0.0; // Distance to the object

  // Desired values based on the sample image
  final double _desiredPitch =
      5.0; // Replace with the pitch value from your analysis
  final double _desiredRoll =
      0.0; // Replace with the roll value from your analysis
  final double _desiredDistance =
      3.0; // Replace with the distance value from your analysis
  final double _threshold = 5.0; // Acceptable deviation in degrees

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeSensors();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(widget.cameras[0], ResolutionPreset.high);
    await _controller!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  void _initializeSensors() {
    _accelerometerSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      setState(() {
        _pitch = math.atan2(event.y, event.z) * 180 / math.pi;
        _roll = math.atan2(event.x, event.z) * 180 / math.pi;
      });
    });
  }

  bool _isAngleCorrect(double angle, double desiredAngle) {
    return (angle - desiredAngle).abs() <= _threshold;
  }

  // Placeholder for distance calculation function
  void _updateDistance() {
    // Use your preferred method to calculate the distance
    // This could involve object detection and size estimation
    // For now, we'll use a placeholder value
    setState(() {
      _distance = _desiredDistance;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Camera with Angle Feedback')),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Positioned(
            top: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pitch: ${_pitch.toStringAsFixed(2)}°',
                  style: TextStyle(
                    fontSize: 24,
                    color: _isAngleCorrect(_pitch, _desiredPitch)
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                Text(
                  'Roll: ${_roll.toStringAsFixed(2)}°',
                  style: TextStyle(
                    fontSize: 24,
                    color: _isAngleCorrect(_roll, _desiredRoll)
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                Text(
                  'Distance: ${_distance.toStringAsFixed(2)} meters',
                  style: TextStyle(
                    fontSize: 24,
                    color: _distance == _desiredDistance
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                _isAngleCorrect(_pitch, _desiredPitch) &&
                        _isAngleCorrect(_roll, _desiredRoll) &&
                        _distance == _desiredDistance
                    ? const Text(
                        'Position is correct! Take the picture.',
                        style: TextStyle(fontSize: 24, color: Colors.green),
                      )
                    : const Text(
                        'Adjust the position.',
                        style: TextStyle(fontSize: 24, color: Colors.red),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
