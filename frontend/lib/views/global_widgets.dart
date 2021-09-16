import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:frontend/controllers/image_helpers.dart' as imageHelpers;
import 'package:frontend/globals.dart' as globals;

Widget notFoundMessage(BuildContext context, String title, String message) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
          height: MediaQuery.of(context).size.height / (24 * globals.getWidgetScaling()),
          color: globals.firstColor,
          child: Text(title,
              style: TextStyle(color: Colors.white,
                  fontSize:
                  (!globals.getIfOnPC())
                      ? (MediaQuery.of(context).size.height * 0.01) * 2.5
                      : (MediaQuery.of(context).size.height * 0.01) * 2
              )
          ),
        ),
        Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / (2 * globals.getWidgetScaling()),
            height: MediaQuery.of(context).size.height / (12 * globals.getWidgetScaling()),
            color: Colors.white,
            padding: EdgeInsets.all(12),
            child: Text(message,
                style: TextStyle(
                    fontSize:
                    (!globals.getIfOnPC())
                        ? (MediaQuery.of(context).size.height * 0.01) * 2.5
                        : (MediaQuery.of(context).size.height * 0.01) * 2
                )
            )
        ),
      ],
    ),
  );
}

final _transformationController = TransformationController();
TapDownDetails _doubleTapDetails;

_handleDoubleTapDown(TapDownDetails details) {
  _doubleTapDetails = details;
}

_handleDoubleTap() {
  if (_transformationController.value != Matrix4.identity()) {
    _transformationController.value = Matrix4.identity();
  } else {
    final position = _doubleTapDetails.localPosition;

    //Zoom 2x
    _transformationController.value = Matrix4.identity()
      ..translate(-position.dx, -position.dy)
      ..scale(2.0);
  }
}

showMemoryImage(BuildContext context, Uint8List bytes, String title, String fileType) {
  return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel:
      MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext ctx, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Container(
            height: MediaQuery.of(ctx).size.height - 80,
            width: (!globals.getIfOnPC())
                ? MediaQuery.of(ctx).size.width
                : 640,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(ctx).size.height - 128,
                  width: (!globals.getIfOnPC())
                      ? MediaQuery.of(ctx).size.width
                      : 640,
                  child: GestureDetector(
                    onDoubleTapDown: _handleDoubleTapDown,
                    onDoubleTap: _handleDoubleTap,
                    child: InteractiveViewer(
                      scaleEnabled: true,
                      constrained: false,
                      transformationController: _transformationController,
                      child: Container(
                        color: Colors.white,
                        child: Image.memory(
                          bytes,
                          width: (!globals.getIfOnPC())
                              ? MediaQuery.of(ctx).size.width
                              : 640,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Save'),
                        onPressed: (){
                          imageHelpers.saveMemoryImage(bytes,
                              title, fileType).then((result) {
                            if (result != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Image saved to downloads folder")));
                            }
                            Navigator.of(ctx).pop();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Go back'),
                        onPressed: (){
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

showAssetImage(BuildContext context, String asset, String title, String fileType) {
  return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel:
      MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext ctx, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Container(
            height: MediaQuery.of(ctx).size.height - 80,
            width: (!globals.getIfOnPC())
                ? MediaQuery.of(ctx).size.width
                : 640,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(ctx).size.height - 128,
                  width: (!globals.getIfOnPC())
                      ? MediaQuery.of(ctx).size.width
                      : 640,
                  child: GestureDetector(
                    onDoubleTapDown: _handleDoubleTapDown,
                    onDoubleTap: _handleDoubleTap,
                    child: InteractiveViewer(
                      scaleEnabled: true,
                      constrained: false,
                      transformationController: _transformationController,
                      child: Container(
                        color: Colors.white,
                        child: Image.asset(
                          asset,
                          width: (!globals.getIfOnPC())
                              ? MediaQuery.of(ctx).size.width
                              : 640,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Save'),
                        onPressed: (){
                          imageHelpers.saveImage(asset,
                              title, fileType).then((result) {
                            if (result != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Image saved to downloads folder")));
                            }
                            Navigator.of(ctx).pop();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Go back'),
                        onPressed: (){
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}