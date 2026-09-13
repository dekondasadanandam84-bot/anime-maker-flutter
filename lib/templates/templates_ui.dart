import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_media.dart';
import 'templates_controller.dart';

class TemplatesUI extends StatefulWidget {
  const TemplatesUI({super.key});

  @override
  State<TemplatesUI> createState() => _TemplatesUIState();
}

class _TemplatesUIState extends State<TemplatesUI> {
  late final TemplatesController controller;

  @override
  void initState() {
    super.initState();
    controller = TemplatesController();
    controller.init();
    controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    super.dispose();
  }

  void _showTemplateApplied(TemplateModel template) {
    controller.useTemplate(template);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2500),
          margin: EdgeInsets.only(
            left: AppMedia.w(24),
            right: AppMedia.w(24),
            bottom: AppMedia.h(24),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppMedia.w(24)),
          ),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 18,
              ),
              SizedBox(width: AppMedia.w(8)),
              Expanded(
                child: Text(
                  'Applied "${template.title}"! Creating layout in editor...',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontSize: AppMedia.w(12),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppMedia.h(64)),
        child: SafeArea(
          bottom: false,
          child: Container(
            height: AppMedia.h(64),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppMedia.w(8)),
              child: Row(
                children: [
                  _TopBarIconButton(
                    icon: Icons.close_rounded,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'AnimeClip Templates',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppMedia.w(width < 600 ? 20 : 22),
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                  SizedBox(width: AppMedia.w(48)),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppMedia.w(16),
                AppMedia.h(18),
                AppMedia.w(16),
                AppMedia.h(28),
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Start faster with ready-made animation & manga templates.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: AppMedia.w(width < 600 ? 14 : 16),
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(
                left: AppMedia.w(16),
                right: AppMedia.w(16),
                bottom: AppMedia.h(18),
              ),
              sliver: SliverToBoxAdapter(
                child: _CategoryFilter(
                  controller: controller,
                ),
              ),
            ),
            if (controller.selectedCategory == TemplateCategory.manga ||
                controller.selectedCategory == TemplateCategory.all)
              _MangaSection(
                controller: controller,
                onUseTemplate: _showTemplateApplied,
              ),
            if (controller.selectedCategory == TemplateCategory.anime ||
                controller.selectedCategory == TemplateCategory.all)
              _AnimeSection(
                controller: controller,
                viewportWidth: width,
                onUseTemplate: _showTemplateApplied,
              ),
            SliverToBoxAdapter(
              child: SizedBox(height: AppMedia.h(24)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _TopBarIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      splashRadius: AppMedia.w(22),
      icon: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface,
        size: AppMedia.w(24),
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final TemplatesController controller;

  const _CategoryFilter({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _CategoryPill(
            label: 'All',
            count: controller.allCount,
            selected: controller.selectedCategory == TemplateCategory.all,
            onTap: () => controller.setCategory(TemplateCategory.all),
          ),
          SizedBox(width: AppMedia.w(8)),
          _CategoryPill(
            label: 'Anime',
            count: controller.animeCount,
            selected: controller.selectedCategory == TemplateCategory.anime,
            onTap: () => controller.setCategory(TemplateCategory.anime),
          ),
          SizedBox(width: AppMedia.w(8)),
          _CategoryPill(
            label: 'Manga',
            count: controller.mangaCount,
            selected: controller.selectedCategory == TemplateCategory.manga,
            onTap: () => controller.setCategory(TemplateCategory.manga),
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryPill({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outlineVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppMedia.w(999)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppMedia.w(14),
            vertical: AppMedia.h(8),
          ),
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppMedia.w(999)),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: selected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                  fontSize: AppMedia.w(12),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: AppMedia.w(6)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppMedia.w(6),
                  vertical: AppMedia.h(2),
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.18)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppMedia.w(999)),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: selected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: AppMedia.w(10),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MangaSection extends StatelessWidget {
  final TemplatesController controller;
  final ValueChanged<TemplateModel> onUseTemplate;

  const _MangaSection({
    required this.controller,
    required this.onUseTemplate,
  });

  @override
  Widget build(BuildContext context) {
    final templates = controller.templates
        .where((template) => template.isManga)
        .toList(growable: false);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: AppMedia.w(16)),
      sliver: SliverToBoxAdapter(
        child: _SectionBlock(
          title: 'Manga Templates',
          subtitle: 'Start your manga with a ready-made page layout.',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final count = _mangaColumns(constraints.maxWidth);
              final gap = AppMedia.w(14);
              final itemWidth =
                  (constraints.maxWidth - ((count - 1) * gap)) / count;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: templates.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count,
                  crossAxisSpacing: gap,
                  mainAxisSpacing: AppMedia.h(14),
                  mainAxisExtent: _mangaCardHeight(itemWidth),
                ),
                itemBuilder: (context, index) {
                  return _MangaTemplateCard(
                    template: templates[index],
                    onUseTemplate: () => onUseTemplate(templates[index]),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  int _mangaColumns(double width) {
    if (width >= 1000) return 4;
    if (width >= 650) return 3;
    return 2;
  }

  double _mangaCardHeight(double itemWidth) {
    final imageHeight = itemWidth * 4 / 3;
    return imageHeight + AppMedia.h(154);
  }
}

class _AnimeSection extends StatelessWidget {
  final TemplatesController controller;
  final double viewportWidth;
  final ValueChanged<TemplateModel> onUseTemplate;

  const _AnimeSection({
    required this.controller,
    required this.viewportWidth,
    required this.onUseTemplate,
  });

  @override
  Widget build(BuildContext context) {
    final templates = controller.templates
        .where((template) => template.isAnime)
        .toList(growable: false);

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppMedia.w(16),
        AppMedia.h(28),
        AppMedia.w(16),
        0,
      ),
      sliver: SliverToBoxAdapter(
        child: _SectionBlock(
          title: 'Anime Stickman Templates',
          subtitle: 'Standard keyframe motion loops ready for 2D animation.',
          trailing: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppMedia.w(8),
              vertical: AppMedia.h(3),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppMedia.w(999)),
            ),
            child: Text(
              '10 loops',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: AppMedia.w(11),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final count = _animeColumns(constraints.maxWidth);
              final gap = AppMedia.w(12);
              final itemWidth =
                  (constraints.maxWidth - ((count - 1) * gap)) / count;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: templates.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count,
                  crossAxisSpacing: gap,
                  mainAxisSpacing: AppMedia.h(16),
                  mainAxisExtent: _animeCardHeight(itemWidth),
                ),
                itemBuilder: (context, index) {
                  return _AnimeTemplateCard(
                    template: templates[index],
                    onUseTemplate: () => onUseTemplate(templates[index]),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  int _animeColumns(double width) {
    if (width >= 1050) return 3;
    if (width >= 650) return 2;
    return 1;
  }

  double _animeCardHeight(double itemWidth) {
    final imageHeight = viewportWidth < 600 ? 192.0 : 220.0;
    return imageHeight + AppMedia.h(178);
  }
}

class _SectionBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Widget child;

  const _SectionBlock({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: AppMedia.h(14)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppMedia.w(16),
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: AppMedia.h(3)),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: AppMedia.w(12),
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: AppMedia.w(8)),
                trailing!,
              ],
            ],
          ),
        ),
        child,
      ],
    );
  }
}

class _MangaTemplateCard extends StatelessWidget {
  final TemplateModel template;
  final VoidCallback onUseTemplate;

  const _MangaTemplateCard({
    required this.template,
    required this.onUseTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppMedia.w(20)),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppMedia.w(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _ImagePreview(
              image: template.image,
              aspectRatio: 3 / 4,
              borderRadius: AppMedia.w(12),
            ),
          ),
          SizedBox(height: AppMedia.h(10)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppMedia.w(8),
              vertical: AppMedia.h(3),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppMedia.w(6)),
            ),
            child: Text(
              'Manga',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: AppMedia.w(10),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: AppMedia.h(4)),
          Text(
            template.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: AppMedia.w(14),
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          SizedBox(height: AppMedia.h(2)),
          SizedBox(
            height: AppMedia.h(32),
            child: Text(
              template.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: AppMedia.w(11),
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
          ),
          SizedBox(height: AppMedia.h(10)),
          SizedBox(
            width: double.infinity,
            height: AppMedia.h(36),
            child: ElevatedButton(
              onPressed: onUseTemplate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: AppMedia.w(8)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppMedia.w(12)),
                ),
              ),
              child: Text(
                'Use Template',
                style: TextStyle(
                  fontSize: AppMedia.w(11),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimeTemplateCard extends StatelessWidget {
  final TemplateModel template;
  final VoidCallback onUseTemplate;

  const _AnimeTemplateCard({
    required this.template,
    required this.onUseTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppMedia.w(20)),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: AppMedia.h(192),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _ImagePreview(
                  image: template.image,
                  aspectRatio: 16 / 9,
                  borderRadius: 0,
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Container(
                        width: AppMedia.w(52),
                        height: AppMedia.w(52),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.42),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: AppMedia.w(30),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: AppMedia.w(8),
                  bottom: AppMedia.h(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppMedia.w(7),
                      vertical: AppMedia.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(AppMedia.w(5)),
                    ),
                    child: Text(
                      template.duration,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: AppMedia.w(11),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppMedia.w(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppMedia.w(18),
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: AppMedia.h(4)),
                  Expanded(
                    child: Text(
                      template.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: AppMedia.w(13),
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: AppMedia.h(10)),
                  SizedBox(
                    width: double.infinity,
                    height: AppMedia.h(40),
                    child: OutlinedButton(
                      onPressed: onUseTemplate,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onSurface,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        side: BorderSide(color: Theme.of(context).colorScheme.outline),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppMedia.w(12),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppMedia.w(9)),
                        ),
                      ),
                      child: Text(
                        'Use Template',
                        style: TextStyle(
                          fontSize: AppMedia.w(12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String image;
  final double aspectRatio;
  final double borderRadius;

  const _ImagePreview({
    required this.image,
    required this.aspectRatio,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderRadius == 0
            ? null
            : Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.image_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}
