import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class PageviewCubit extends Cubit<int> {
  PageviewCubit() : super(0);

  PageController _itemImagePageController = PageController();
  PageController get itemImagePageController => _itemImagePageController;

  void setPageController(PageController pageController) {
    _itemImagePageController = pageController;
  }

  void changePage(int pageIdx) {
    _itemImagePageController.animateToPage(pageIdx,
        duration: const Duration(milliseconds: 2), curve: Curves.easeInOut);
    emit(pageIdx);
  }

  void reset() {
    emit(0);
  }
}
