import 'dart:convert';
import 'package:custom_post_quantum/custom_post_quantum.dart';
// import 'dart:io';

void main () async{
  const int customN = 256;
  var failureCounter = 0;
  var originalMessageBase64Encoded = 'MTIzNDU2NzhhMnVpb29sbGExYjJjNGQxa2tsbG1tZGQ=';
  List results =[];
  var startDate = DateTime.now();
  print('VALIDO SI EL TEXTO PLANO ORIGINAL, COINCIDE CON EL TEXTO CIFRADO VUELTO A DESCIFRAR, ITERANDO PARA $customN VALORES DE N');
  for (int i=1; i<=customN; i++) {
    print("PRUEBO GENERAR LA KEY para n:$i ");
    print('\n');
    try {
      final kyberCustom = KyberPKE.customPolynGrade(i);
      var seed = base64Decode('AAECAwQFBgcICQoLDA0ODwABAgMEBQYHCAkKCwwNDg8=');
      var (pk, sk) = kyberCustom.generateKeys(seed);
      var endDate = DateTime.now();
      var timeDifference = endDate.difference(startDate).inMilliseconds;
      print('TIEMPO QUE TARDA EN GENERAR LAS KEYS PARA N = $i , $timeDifference milisegundos');
      var msg = base64Decode('MTIzNDU2NzhhMnVpb29sbGExYjJjNGQxa2tsbG1tZGQ=');
      var coins = base64Decode('Dw8ODg0NDAwLCwoKCQkICAcHBgYFBQQEAwMCAgEBAAA=');
      var cipher = kyberCustom.encrypt(pk, msg, coins);
      var decryptedMsg = kyberCustom.decrypt(sk, cipher);
      var reamainingDate = DateTime.now();
      print('TIEMPO QUE TARDA EN ENCRIPTAR Y DESENCRIPTAR EL MENSAJE PARA N = $i , $timeDifference milisegundos');
      var timeRemainingDifference = reamainingDate.difference(endDate).inMilliseconds;
      var isDecryptedMsgEqualsOriginalMessage = (base64Encode(decryptedMsg) == originalMessageBase64Encoded) ? 'Si' : 'No';
      var result = {'n':'$i', 'coincide': isDecryptedMsgEqualsOriginalMessage, 'tiempoGenerarKeys': '$timeDifference ms', 'tiempoRestante': '$timeRemainingDifference ms' };
      results.add(result);
      print('VOY MAPEANDO LOS VALORES PARA n = $i \n$result\n');
      print('-------------------------------------------------------------------------------------------');
    } catch (e, stacktrace) {
      failureCounter+=1;
      print('FALLO PARA n: $i , CAUSA: $e');
      print('$stacktrace');
      print('-------------------------------------------------------------------------------------------');
    }
     print("Cantidad de Fallos: $failureCounter");
  }
  print('\n');
}
