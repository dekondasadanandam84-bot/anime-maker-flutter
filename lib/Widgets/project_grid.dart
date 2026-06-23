import 'package:flutter/material.dart';
import 'project_card.dart';

class ProjectGrid extends StatelessWidget {
  final List<Map<String, dynamic>> projects;
  final Function(int) onDelete;

  const ProjectGrid({
    super.key,
    required this.projects,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return ProjectCard(
          project: projects[index],
          onOpen: () {},
          onEdit: () {},
          onDelete: () => onDelete(index),
        );
      },
    );
  }
}