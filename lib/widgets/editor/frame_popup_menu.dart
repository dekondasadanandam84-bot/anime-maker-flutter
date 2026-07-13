import 'package:flutter/material.dart';

enum FrameAction {
  addBefore,
  addAfter,
  duplicate,
  delete,
}

Future<FrameAction?> showFramePopupMenu(
  BuildContext context,
  Offset position,
) {
  return showMenu<FrameAction>(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      position.dx,
      position.dy,
    ),
    items: const [
      PopupMenuItem(
        value: FrameAction.addBefore,
        child: ListTile(
          leading: Icon(Icons.add),
          title: Text("Add Before"),
          dense: true,
        ),
      ),
      PopupMenuItem(
        value: FrameAction.addAfter,
        child: ListTile(
          leading: Icon(Icons.add_box_outlined),
          title: Text("Add After"),
          dense: true,
        ),
      ),
      PopupMenuItem(
        value: FrameAction.duplicate,
        child: ListTile(
          leading: Icon(Icons.copy),
          title: Text("Duplicate"),
          dense: true,
        ),
      ),
      PopupMenuItem(
        value: FrameAction.delete,
        child: ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text("Delete"),
          dense: true,
        ),
      ),
    ],
  );
}