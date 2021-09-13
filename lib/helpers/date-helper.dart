import 'package:date_format/date_format.dart' as formater;
import 'package:intl/intl.dart';

class DateHelper {
  static String formatDate(DateTime date, int oper, int valor) {
    String data = date.toString();
    var temp = data.split(" ");
    var horaMinuto = temp[1];
    data = temp[0];
    temp = data.split("-");
    var dia = int.parse(temp[2]);
    var mes = int.parse(temp[1]);
    var ano = int.parse(temp[0]);
    String meses;

    if (oper == 1) {
      //somar mês
      if (mes == 12)
        mes = 1;
      else
        mes = mes + valor;
    } else if (oper == 2) {
      //somar ano
      ano = ano + valor;
    }
    if (mes < 10) {
      meses = '0' + mes.toString();
    } else {
      meses = mes.toString();
    }
    data =
        ano.toString() + "-" + meses + "-" + dia.toString() + " " + horaMinuto;
    return data;
  }

  /*Retorna ano mes dia hora minuto */
  static List<int> separaData(DateTime date) {
    var dt = date.toString();
    var temp = dt.split(' ');

    var min = int.parse((temp[1].split('.'))[0].split(':')[1]);
    var hora = int.parse((temp[1].split('.'))[0].split(':')[0]);
    var dia = int.parse((temp[0].split('-'))[2]);
    var mes = int.parse((temp[0].split('-'))[1]);
    var ano = int.parse((temp[0].split('-'))[0]);

    List<int> data = [ano, mes, dia, hora, min];
    return data;
  }

  /* Formata data para inserir na db sqlite */
  static String? toDbString(DateTime date) {
    
    if (date == null) {
      return null;
    }

    return formater
        .formatDate(date, [formater.yyyy, '-', formater.mm, '-', formater.dd]);
  }

  /* Retorna obj DateTime a partir de uma string com formato padrao do banco (2020-05-29) */
  static DateTime? fromDbString(String inputString) {

    if (inputString == null || inputString.trim().isEmpty) {
      return null;
    }

    return DateFormat("yyyy-MM-dd").parse(inputString);
  }

  // Formato padrão de data BR (29-05-2020)
  static String? formatAsDate(DateTime date) {

    if (date == null) {
      return null;
    }

    return formater
        .formatDate(date, [formater.dd, '/', formater.mm, '/', formater.yyyy]);
  }

  /* Formato padrão de data BR (29-05-2020) */
  static DateTime? fromFormatedString(String inputString) {

    if (inputString == null || inputString.trim().isEmpty) {
      return null;
    }

    return DateFormat("dd/MM/yyyy").parse(inputString);
  }
}
