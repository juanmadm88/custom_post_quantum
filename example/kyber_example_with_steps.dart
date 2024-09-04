import 'dart:convert';
import 'package:custom_post_quantum/custom_post_quantum.dart';

void main() {
  var encryptObs = StepObserver();
  var decryptObs = StepObserver();
  var keyGenObs = StepObserver();
  // Instantiate Kyber's internal PKE.
  KyberPKE kyberInstance; 
  
  kyberInstance = KyberPKE.pke512();

  // Define a key generation seed.
  var seed = utf8.encode("sdsasdasdasfasfasf12312421421412");

  // Set the message.
  var msg = utf8.encode("sdasfahsdasdwscxddfjfsklkfsljflw");

  // Define an encryption randomizer.
  var coins = utf8.encode("dsdsascxsc342123123123123123123a");

  // Generate keys from seed.
  var (pk, _) = kyberInstance.generateKeys(seed,observer:keyGenObs);

  var pkBase64 = base64Encode(pk.serialize());

  var pkBytes = base64Decode(pkBase64);
  var pkDeserialized = PKEPublicKey.deserialize(pkBytes, 2);

  // Encrypt the message with the public key.
  var cipher = kyberInstance.encrypt(pkDeserialized, msg, coins,observer:encryptObs);

  var (_, sk) = kyberInstance.generateKeys(seed);

  var skBytes = base64Decode(sk.base64);
  var skDeserialize = PKEPrivateKey.deserialize(skBytes, 2);

  var encryptedMsgBytes = base64Decode(cipher.base64);
  var encryptedMsg = PKECypher.deserialize(encryptedMsgBytes, 2);

  var decryptedMsg = kyberInstance.decrypt(skDeserialize, encryptedMsg,observer:decryptObs);

  print("Key generation");
  keyGenObs.prettyPrint();

  print("decrypted message: ${base64Encode(decryptedMsg)}");
  print("original message: ${base64Encode(msg)}");
}