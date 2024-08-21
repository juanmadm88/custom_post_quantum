import 'dart:convert';
import 'package:post_quantum/post_quantum.dart';
import 'dart:io';

void main () async{
  const int customQ = 3329;
  var originalMessageBase64Encoded = 'MTIzNDU2NzhhMnVpb29sbGExYjJjNGQxa2tsbG1tZGQ=';
  List results =[];
  var startDate = DateTime.now();
  print('VALIDO SI EL TEXTO PLANO ORIGINAL, COINCIDE CON EL TEXTO CIFRADO VUELTO A DESCIFRAR, ITERANDO PARA $customQ VALORES DE Q');
  for (int i=1; i<=customQ; i++) {
    print('\n');
    final kyberCustom = KyberPKE.customModule(i);
    var seed = base64Decode('AAECAwQFBgcICQoLDA0ODwABAgMEBQYHCAkKCwwNDg8=');
    var (pk, sk) = kyberCustom.generateKeys(seed);
    var endDate = DateTime.now();
    var timeDifference = endDate.difference(startDate).inMilliseconds;
    print('TIEMPO QUE TARDA EN GENERAR LAS KEYS PARA q = $i , $timeDifference milisegundos');
    var msg = base64Decode('MTIzNDU2NzhhMnVpb29sbGExYjJjNGQxa2tsbG1tZGQ=');
    var coins = base64Decode('Dw8ODg0NDAwLCwoKCQkICAcHBgYFBQQEAwMCAgEBAAA=');
    var cipher = kyberCustom.encrypt(pk, msg, coins);
    var decryptedMsg = kyberCustom.decrypt(sk, cipher);
    var reamainingDate = DateTime.now();
    print('TIEMPO QUE TARDA EN ENCRIPTAR Y DESENCRIPTAR EL MENSAJE PARA Q = $i , $timeDifference milisegundos');
    var timeRemainingDifference = reamainingDate.difference(endDate).inMilliseconds;
    var isDecryptedMsgEqualsOriginalMessage = (base64Encode(decryptedMsg) == originalMessageBase64Encoded) ? 'Si' : 'No';
    var result = {'q':i, 'coincide': isDecryptedMsgEqualsOriginalMessage, 'tiempoGenerarKeys': '$timeDifference ms', 'tiempoRestante': '$timeRemainingDifference ms' };
    results.add(result);
    print('VOY MAPEANDO LOS VALORES PARA Q = $i \n$result\n');
    print('-------------------------------------------------------------------------------------------');
  }
  print('\n');
  await writeResult(results);
}
String get _localPath  {
  final directory = Directory.current.path;
  return directory;
}
File get _localFile {
  final path = _localPath;
  return File('$path/results/output_custom_Q.txt');
}
Future<File> writeResult(data)  {
  final file = _localFile;
  // Write the file
  print("ESCRIBE EN LA RUTA: $file");
  return file.writeAsString(data.toString());
}