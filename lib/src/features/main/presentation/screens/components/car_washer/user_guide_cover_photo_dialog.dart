import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/configs/route_config.dart';

class UserGuideCoverPhotoDialog extends StatefulWidget {
  final List<String> imagePaths;
  final List<String> descriptions;

  const UserGuideCoverPhotoDialog(
      {super.key, required this.imagePaths, required this.descriptions});

  @override
  _UserGuideCoverPhotoDialogState createState() =>
      _UserGuideCoverPhotoDialogState();
}

class _UserGuideCoverPhotoDialogState extends State<UserGuideCoverPhotoDialog> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: widget.imagePaths.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(widget.imagePaths[index]),
                          const SizedBox(height: 10),
                          Text(
                            widget.descriptions[index],
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    left: 10,
                    top: 150,
                    child: _currentIndex > 0
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            },
                          )
                        : Container(),
                  ),
                  Positioned(
                    right: 10,
                    top: 150,
                    child: _currentIndex < widget.imagePaths.length - 1
                        ? IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            },
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.imagePaths.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: _currentIndex == index ? 12.0 : 8.0,
                  height: _currentIndex == index ? 12.0 : 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pushNamed(RouteConfig.coverImageRoute);
              },
              child: const Text('Got it'),
            ),
          ],
        ),
      ),
    );
  }
}
