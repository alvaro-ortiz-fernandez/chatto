class TimeUtils {

  /// ------------------------------------------------------------
  /// Método que formatea una fecha para mostrar
  /// ------------------------------------------------------------
  static String formatDate(DateTime date) {
    Duration difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return 'Hace ' + difference.inDays.toString() + ' días';
    } else if (difference.inHours > 0) {
      return 'Hace ' + difference.inHours.toString() + ' hrs';
    } else if (difference.inMinutes > 0) {
      return 'Hace ' + difference.inMinutes.toString() + ' min';
    } else {
      return 'Hace 1 min';
    }
  }
}