import 'package:flutter/material.dart';
import '../../config/screen_size.dart';

/// Responsive layout widget that switches between mobile, tablet, and desktop layouts
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ScreenSize.tabletMaxWidth) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= ScreenSize.mobileMaxWidth) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// Responsive grid widget that adjusts columns based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double runSpacing;
  final EdgeInsets? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ScreenSize.getGridColumns(
      context,
      mobile: mobileColumns,
      tablet: tabletColumns,
      desktop: desktopColumns,
    );

    return Padding(
      padding:
          padding ?? EdgeInsets.all(ScreenSize.getHorizontalPadding(context)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth =
              constraints.maxWidth - (padding?.horizontal ?? 0);
          final itemWidth =
              (availableWidth - (spacing * (columns - 1))) / columns;

          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: children.map((child) {
              return SizedBox(width: itemWidth, child: child);
            }).toList(),
          );
        },
      ),
    );
  }
}

/// Responsive container that adjusts max width based on screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? mobileMaxWidth;
  final double? tabletMaxWidth;
  final double? desktopMaxWidth;
  final EdgeInsets? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.mobileMaxWidth,
    this.tabletMaxWidth = 800,
    this.desktopMaxWidth = 1400,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    double? maxWidth;
    if (ScreenSize.isDesktop(context)) {
      maxWidth = desktopMaxWidth;
    } else if (ScreenSize.isTablet(context)) {
      maxWidth = tabletMaxWidth;
    } else {
      maxWidth = mobileMaxWidth;
    }

    return Center(
      child: Container(
        width: double.infinity,
        constraints: maxWidth != null
            ? BoxConstraints(maxWidth: maxWidth)
            : null,
        padding:
            padding ??
            EdgeInsets.symmetric(
              horizontal: ScreenSize.getHorizontalPadding(context),
            ),
        child: child,
      ),
    );
  }
}

/// Split view for tablet and desktop - shows list on left and detail on right
class ResponsiveSplitView extends StatelessWidget {
  final Widget list;
  final Widget? detail;
  final double listFlex;
  final double detailFlex;
  final Widget? placeholder;

  const ResponsiveSplitView({
    super.key,
    required this.list,
    this.detail,
    this.listFlex = 1,
    this.detailFlex = 2,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (ScreenSize.isMobile(context)) {
      return list;
    }

    return Row(
      children: [
        Expanded(flex: listFlex.toInt(), child: list),
        const VerticalDivider(width: 1),
        Expanded(
          flex: detailFlex.toInt(),
          child:
              detail ??
              placeholder ??
              const Center(child: Text('Wähle ein Element aus der Liste')),
        ),
      ],
    );
  }
}

/// Responsive padding that adjusts based on screen size
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double? mobile;
  final double? tablet;
  final double? desktop;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    double padding;
    if (ScreenSize.isDesktop(context)) {
      padding = desktop ?? 32.0;
    } else if (ScreenSize.isTablet(context)) {
      padding = tablet ?? 24.0;
    } else {
      padding = mobile ?? 16.0;
    }

    return Padding(padding: EdgeInsets.all(padding), child: child);
  }
}

/// Responsive card that adjusts size based on screen
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? elevation;
  final Color? color;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.elevation,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding =
        padding ?? EdgeInsets.all(ScreenSize.isMobile(context) ? 12.0 : 16.0);

    return Card(
      color: color,
      elevation: elevation ?? (ScreenSize.isMobile(context) ? 2.0 : 4.0),
      child: Padding(padding: cardPadding, child: child),
    );
  }
}
