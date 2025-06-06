class FormatData {
  static String formatData(DateTime data) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    final dia = doisDigitos(data.day);
    final mes = doisDigitos(data.month);
    final ano = data.year;
    return '$dia/$mes/$ano';
  }
}
