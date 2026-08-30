
import 'package:flutter/material.dart';

import 'project_controller.dart';

class ProjectScope extends InheritedNotifier<ProjectController> {
  const ProjectScope({
    super.key,
    required ProjectController controller,
    required super.child,
  }) : super(
          notifier: controller,
        );

  static ProjectController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ProjectScope>();

    assert(
      scope != null,
      'ProjectScope was not found above this context.',
    );

    return scope!.notifier!;
  }

  static ProjectController read(BuildContext context) {
    final scope =
        context.getInheritedWidgetOfExactType<ProjectScope>();

    assert(
      scope != null,
      'ProjectScope was not found above this context.',
    );

    return scope!.notifier!;
  }
}

