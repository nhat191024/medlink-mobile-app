import 'package:medlink/utils/app_imports.dart';

enum NotificationType { success, error, info, warning }

class NotificationModal extends StatelessWidget {
  final String title;
  final String message;
  final NotificationType type;
  final VoidCallback? onClose;
  final VoidCallback? onAction;
  final String? actionText;
  final Duration duration;
  final bool showCloseButton;

  const NotificationModal({
    super.key,
    required this.title,
    required this.message,
    this.type = NotificationType.info,
    this.onClose,
    this.onAction,
    this.actionText,
    this.duration = const Duration(seconds: 3),
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryText.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and close button
              Row(
                children: [
                  // Icon based on notification type
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getBackgroundColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(_getIcon(), color: _getIconColor(), size: 24),
                  ),
                  const SizedBox(width: 12),
                  // Title
                  Expanded(
                    child: AppTextWidgets.boldTextWithColor(
                      text: title,
                      color: AppColors.primaryText,
                      size: 18,
                    ),
                  ),
                  // Close button
                  if (showCloseButton)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        onClose?.call();
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.close, color: AppColors.secondaryText, size: 20),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Message
              Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Lexend-Regular',
                  color: AppColors.secondaryText,
                  fontSize: 14,
                ),
              ),
              // Action button if provided
              if (actionText != null && onAction != null) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onAction,
                      style: TextButton.styleFrom(
                        backgroundColor: _getActionButtonColor(),
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        actionText!,
                        style: const TextStyle(
                          fontFamily: 'Lexend-Medium',
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case NotificationType.success:
        return AppColors.successLight;
      case NotificationType.error:
        return AppColors.errorLight;
      case NotificationType.info:
        return AppColors.infoLight;
      case NotificationType.warning:
        return AppColors.otherColor1;
    }
  }

  Color _getIconColor() {
    switch (type) {
      case NotificationType.success:
        return AppColors.successMain;
      case NotificationType.error:
        return AppColors.errorMain;
      case NotificationType.info:
        return AppColors.infoMain;
      case NotificationType.warning:
        return AppColors.otherColor2;
    }
  }

  Color _getActionButtonColor() {
    switch (type) {
      case NotificationType.success:
        return AppColors.successMain;
      case NotificationType.error:
        return AppColors.errorMain;
      case NotificationType.info:
        return AppColors.infoMain;
      case NotificationType.warning:
        return AppColors.otherColor2;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.info:
        return Icons.info;
      case NotificationType.warning:
        return Icons.warning;
    }
  }

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    NotificationType type = NotificationType.info,
    VoidCallback? onClose,
    VoidCallback? onAction,
    String? actionText,
    Duration duration = const Duration(seconds: 3),
    bool showCloseButton = true,
    bool autoClose = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.primaryText.withValues(alpha: 0.5),
      builder: (context) => NotificationModal(
        title: title,
        message: message,
        type: type,
        onClose: onClose,
        onAction: onAction,
        actionText: actionText,
        duration: duration,
        showCloseButton: showCloseButton,
      ),
    ).then((_) {
      onClose?.call();
    });

    // Auto close if enabled
    if (autoClose) {
      final navigator = Navigator.of(context);
      Future.delayed(duration, () {
        if (navigator.canPop()) {
          navigator.pop();
        }
      });
    }
  }

  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onClose,
    VoidCallback? onAction,
    String? actionText,
    Duration duration = const Duration(seconds: 3),
    bool autoClose = true,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      type: NotificationType.success,
      onClose: onClose,
      onAction: onAction,
      actionText: actionText,
      duration: duration,
      autoClose: autoClose,
    );
  }

  static void showError({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onClose,
    VoidCallback? onAction,
    String? actionText,
    Duration duration = const Duration(seconds: 5),
    bool autoClose = false,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      type: NotificationType.error,
      onClose: onClose,
      onAction: onAction,
      actionText: actionText,
      duration: duration,
      autoClose: autoClose,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onClose,
    VoidCallback? onAction,
    String? actionText,
    Duration duration = const Duration(seconds: 3),
    bool autoClose = true,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      type: NotificationType.info,
      onClose: onClose,
      onAction: onAction,
      actionText: actionText,
      duration: duration,
      autoClose: autoClose,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onClose,
    VoidCallback? onAction,
    String? actionText,
    Duration duration = const Duration(seconds: 4),
    bool autoClose = true,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      type: NotificationType.warning,
      onClose: onClose,
      onAction: onAction,
      actionText: actionText,
      duration: duration,
      autoClose: autoClose,
    );
  }
}
