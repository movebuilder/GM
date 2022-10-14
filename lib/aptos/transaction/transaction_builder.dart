
import 'dart:typed_data';

import 'package:aptos/aptos.dart';
import 'package:aptos/constants.dart';
import 'package:aptos/models/payload.dart';
import 'package:aptos/models/signature.dart';
import 'package:aptos/models/transaction.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed25519;
import 'package:flutter/foundation.dart';

class TransactionBuilder {

  late AptosClient client;

  TransactionBuilder({String? endpoint}) {
    client = AptosClient(endpoint ?? Constants.testnetAPI, enableDebugLog: true);
  }

  Future<dynamic> transferAptos(AptosAccount sender,
      String receiverAddress,
      String amount,
      String gasPrice,
      String maxGasAmount,
      String expirationTimestamp) async {
    final senderAddress = sender.address().hex();
    final accountInfo = await client.getAccount(senderAddress);
    final ledgerInfo = await client.getLedgerInfo();
    final sequenceNumber = int.parse(accountInfo["sequence_number"].toString());

    const typeArgs = "0x1::aptos_coin::AptosCoin";
    const moduleId = "0x1::coin";
    const moduleFunc = "transfer";
    final entryFunc = EntryFunction.natural(
      moduleId,
      moduleFunc,
      [TypeTagStruct(StructTag.fromString(typeArgs))],
      [bcsToBytes(AccountAddress.fromHex(receiverAddress)), bcsSerializeUint64(BigInt.parse(amount))],
    );
    final entryFunctionPayload = TransactionPayloadEntryFunction(entryFunc);

    final rawTx = RawTransaction(
        AccountAddress.fromHex(senderAddress),
        BigInt.from(sequenceNumber),
        entryFunctionPayload,
        BigInt.parse(maxGasAmount),
        BigInt.parse(gasPrice),
        BigInt.parse(expirationTimestamp),
        ChainId(ledgerInfo["chain_id"]));

    final txnBuilder = TransactionBuilderEd25519(
      Uint8List.fromList(sender.signingKey.publicKey.bytes),
      (signingMessage) => Ed25519Signature(ed25519.sign(sender.signingKey.privateKey, signingMessage).sublist(0, 64)),
    );

    final signedTx = txnBuilder.rawToSigned(rawTx);
    final txEdd25519 = signedTx.authenticator as TransactionAuthenticatorEd25519;
    final signature = txEdd25519.signature.value;

    final tx = TransactionRequest(
        sender: senderAddress,
        sequenceNumber: sequenceNumber.toString(),
        maxGasAmount: maxGasAmount.toString(),
        gasUnitPrice: gasPrice.toString(),
        expirationTimestampSecs: expirationTimestamp.toString(),
        payload: Payload(
            "entry_function_payload",
            "$moduleId::$moduleFunc",
            ["0x1::aptos_coin::AptosCoin"],
            [receiverAddress, amount.toString()]),
        signature: Signature("ed25519_signature", sender.pubKey().hex(), "0x"+HEX.encode(signature)));

    final result = await client.submitTransaction(tx);
    debugPrint(result.toString());
    return result;
  }

}