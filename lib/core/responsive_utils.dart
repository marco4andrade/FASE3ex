import 'package:flutter/material.dart';

/// Utilidades para diseño responsivo
///
/// Proporciona métodos helper para crear interfaces adaptativas
/// que se ajustan al tamaño de pantalla del dispositivo
class ResponsiveUtils {
  /// Puntos de quiebre para diferentes tamaños de pantalla
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Obtiene el tipo de dispositivo basado en el ancho de pantalla
  static DeviceType getDeviceType(double width) {
    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Muestra un modal responsivo que se adapta al tamaño de pantalla
  static Future<T?> showResponsiveModal<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    String? title,
    bool barrierDismissible = true,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = getDeviceType(screenWidth);

    switch (deviceType) {
      case DeviceType.mobile:
        return showModalBottomSheet<T>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: builder(context),
            ),
          ),
        );
      case DeviceType.tablet:
      case DeviceType.desktop:
        return showDialog<T>(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: deviceType == DeviceType.desktop ? 500 : 400,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                  Flexible(child: builder(context)),
                ],
              ),
            ),
          ),
        );
    }
  }

  /// Muestra un diálogo de confirmación responsivo
  static Future<bool?> showResponsiveConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    Color? confirmColor,
    bool isDestructive = false,
  }) {
    return showResponsiveModal<bool>(
      context: context,
      title: title,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(cancelText),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDestructive ? Colors.red : confirmColor,
                    foregroundColor: isDestructive || confirmColor != null
                        ? Colors.white
                        : null,
                  ),
                  child: Text(confirmText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Obtiene el número de columnas para un grid basado en el ancho
  static int getGridColumnCount(double width) {
    if (width > desktopBreakpoint) {
      return 4;
    } else if (width > tabletBreakpoint) {
      return 3;
    } else if (width > mobileBreakpoint) {
      return 2;
    } else {
      return 1;
    }
  }

  /// Calcula el padding responsivo
  static EdgeInsets getResponsivePadding(double width) {
    if (width > desktopBreakpoint) {
      return const EdgeInsets.all(24.0);
    } else if (width > tabletBreakpoint) {
      return const EdgeInsets.all(20.0);
    } else {
      return const EdgeInsets.all(16.0);
    }
  }
}

/// Enum para tipos de dispositivo
enum DeviceType { mobile, tablet, desktop }
