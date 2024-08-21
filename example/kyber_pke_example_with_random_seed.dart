
import 'dart:convert';
import 'dart:math';
import 'package:custom_post_quantum/post_quantum.dart';


void main () {
  const numberOfInteractions = 200;
  var doesMatch = true;
  final coins = base64Decode('Dw8ODg0NDAwLCwoKCQkICAcHBgYFBQQEAwMCAgEBAAA=');
  var originalMessage = 'MTIzNDU2NzhhMnVpb29sbGExYjJjNGQxa2tsbG1tZGQ=';
    const keys = [
    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,
    30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,
    55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,
    80,81,82,83,84,85,86,87,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,
    105,107,108,109,110,111,112,113,114,115,116,117,118,119,121,122,123,124,125,
    126,128,129,130,131,133,134,138,139,140,141,142,143,145,146,148,151,152,153,
    157,158,162,165,166,167,168,169,170,173,180,183,186,188,256,384,512,640,768,
    896,1024
  ];
  for (var e in keys) {
    print("Genero $numberOfInteractions cifrados para el valor de k:$e");
    var kyberCustom = KyberPKE.customNumberOfPolynomPerVector(e);
      for (int i=1; i<=200; i++) {
        var seed = generateRandomSeed(e);
        print(" Cifrado numero: $i, para el valor de k:$e, con esta semilla: $seed");
        var (pk, sk) = kyberCustom.generateKeys(base64Decode(seed));
        var cipher = kyberCustom.encrypt(pk, base64Decode(originalMessage), coins);
        var decryptedMsg = kyberCustom.decrypt(sk, cipher);
        doesMatch = base64Encode(decryptedMsg) == originalMessage;
        (doesMatch == true) ? print("Se sigue iterando, el mensaje original coincide con el descifrado") : 
                                print("Se corta la iteracion, el mensaje original no coincide con el descifrado");
        if(doesMatch == false) break;
      }
    if(doesMatch == false) {
      print("Para k:$e no hubo coincidencia entre el valor del mensaje descifrado y el mensaje original");
      break;
    }
    print("Proximo valor de k:${e+1}");
  }
  print("Luego de hacer n:$numberOfInteractions, Sobre este conjunto de claves: $keys ");
  (doesMatch == true) ? print("Todas coincidieron el descifrado con el cifrado")   : print("No todas coincidieron el descifrado con el cifrado");
}

String generateRandomSeed(int k)  {
  final values = List<int>.generate(32, (i) => Random.secure().nextInt(256));
  print("Genero al azar estos valores: $values     ,para k: $k");
  return base64Encode(values);
}