import 'package:intl/intl.dart';

//format nilai rupiah
String formatRupiah(num number) {
  final format = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return format.format(number);
}