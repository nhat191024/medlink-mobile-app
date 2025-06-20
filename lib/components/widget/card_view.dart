import 'package:medlink/utils/app_imports.dart';

class CardView extends StatelessWidget {
  final Widget? child;
  final double? borderRadius;
  final Color? background;
  final EdgeInsetsGeometry? padding;

  const CardView({super.key, this.child, this.borderRadius, this.background, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius != null ? borderRadius! : 0.0),
      ),
      child: child,
    );
  }
}
