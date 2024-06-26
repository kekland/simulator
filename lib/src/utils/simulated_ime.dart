import 'dart:math';

import 'package:flutter/services.dart';
import 'package:simulator/src/platform_channels/system_text_input_channel_interceptor.dart';

class SimulatedIME {
  SimulatedIME({
    required this.id,
    required this.configuration,
  });

  final int id;
  TextEditingValue value = TextEditingValue.empty;

  TextInputConfiguration configuration;

  double? width;
  double? height;
  Matrix4? transform;

  Rect? markedTextRect;
  List<Rect> selectionRects = [];
  Rect? caretRect;

  String? fontFamily;
  double? fontSize;
  FontWeight? fontWeight;
  TextDirection? textDirection;
  TextAlign? textAlign;

  void setEditableSizeAndTransform(
    double width,
    double height,
    Matrix4 transform,
  ) {
    this.width = width;
    this.height = height;
    this.transform = transform;
  }

  void setMarkedTextRect(Rect rect) {
    markedTextRect = rect;
  }

  void setSelectionRects(List<Rect> rects) {
    selectionRects = rects;
  }

  void setStyle(
    String? fontFamily,
    double? fontSize,
    FontWeight? fontWeight,
    TextDirection textDirection,
    TextAlign textAlign,
  ) {
    this.fontFamily = fontFamily;
    this.fontSize = fontSize;
    this.fontWeight = fontWeight;
    this.textDirection = textDirection;
    this.textAlign = textAlign;
  }

  void setEditingState(TextEditingValue value) {
    this.value = value;
  }

  void setCaretRect(Rect rect) {
    caretRect = rect;
  }

  void _appendCharacter(String character) {
    value = value.replaced(
      value.selection,
      character,
    );
  }

  void _deleteCharacter(int offset) {
    var selection = value.selection;

    if (selection.isCollapsed) {
      selection = selection.extendTo(TextPosition(
        offset: max(0, selection.baseOffset + offset),
        affinity: selection.affinity,
      ));

      final selectionLength = selection.extentOffset - selection.baseOffset;

      if (selection.isCollapsed ||
          !selection.isValid ||
          selectionLength > value.text.length) {
        return;
      }
    }

    value = value.replaced(
      selection,
      '',
    );
  }

  void handleBackspacePress() {
    _deleteCharacter(-1);
    SystemTextInputChannelInterceptor.instance.updateEditingState(id, value);
  }

  void handleNewlinePress() {
    _appendCharacter('\n');
    SystemTextInputChannelInterceptor.instance.updateEditingState(id, value);
  }

  void handleKeyEvent(KeyEvent event) {
    final interceptor = SystemTextInputChannelInterceptor.instance;

    String? characterToAppend;

    // TODO: Make this work for macOS
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        handleBackspacePress();
        return;
      }

      characterToAppend = event.character;
    }

    if (event is KeyRepeatEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        handleBackspacePress();
        return;
      }

      characterToAppend = event.character;
    }

    if (characterToAppend != null) {
      _appendCharacter(characterToAppend);
      interceptor.updateEditingState(id, value);
    }
  }
}
