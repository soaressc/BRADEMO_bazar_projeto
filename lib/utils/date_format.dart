class FormatData {
  static String formatData(DateTime date, {bool comHora = false}) {
    final dia = date.day.toString().padLeft(2, '0');
    final mes = date.month.toString().padLeft(2, '0');
    final ano = date.year.toString();
    final hora = date.hour.toString().padLeft(2, '0');
    final minuto = date.minute.toString().padLeft(2, '0');

    if (comHora) {
      return '$dia/$mes/$ano $hora:$minuto';
    } else {
      return '$dia/$mes/$ano';
    }
  }

  static String nomeMes(DateTime date) {
    const meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return meses[date.month - 1];
  }

  static String nomeMesEAno(DateTime date, {bool comHora = false}) {
    final mesAno = '${nomeMes(date)} de ${date.year}';
    if (comHora) {
      final hora = date.hour.toString().padLeft(2, '0');
      final minuto = date.minute.toString().padLeft(2, '0');
      return '$mesAno • $hora:$minuto';
    }
    return mesAno;
  }

  static String nomeMesEAnoAbreviado(DateTime date, {bool comHora = false}) {
    final nomeMesAbreviado = nomeMes(date).substring(0, 3); 
    final ano = date.year.toString();
    final mesAno = '$nomeMesAbreviado de $ano';

    if (comHora) {
      final hora = date.hour.toString().padLeft(2, '0');
      final minuto = date.minute.toString().padLeft(2, '0');
      return '$mesAno • $hora:$minuto';
    }

    return mesAno;
  }
}
