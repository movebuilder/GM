import 'dart:convert';
import 'dart:typed_data';

import 'package:aptos/aptos.dart';
import 'package:aptos/coin_client.dart';
import 'package:aptos/constants.dart';
import 'package:aptos/models/payload.dart';
import 'package:aptos/models/signature.dart';
import 'package:aptos/models/table_item.dart';
import 'package:aptos/models/transaction.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed25519;
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:gm/aptos/transaction/chat_message.dart';

class TxBuilder {

  static const String moduleId = "0xfaf52ae1b48f945014ab1ba2798f85498995848cedfb0fbd167fada7ccb2d66e::chat";
  static const String messageStoreResouceType = moduleId + "::MessageStore";
  static const String allContactsResourceType = moduleId + "::All_Contact";

  late AptosClient client;
  late CoinClient coinClient;

  TxBuilder({String? endpoint}) {
    client = AptosClient(endpoint ?? Constants.testnetAPI, enableDebugLog: true);
    coinClient = CoinClient(client);
  }

  Future<Decimal> getBalanceByAddress(String address) async {
    var balance = await coinClient.checkBalance(address);
    return Decimal.fromBigInt(balance) * Decimal.fromInt(10).pow(-8);
  }

  Future<Decimal> getBalanceByAccount(AptosAccount account) async {
    return await getBalanceByAddress(account.address);
  }

  Future<dynamic> transferAptos(
    AptosAccount sender,
    String receiverAddress,
    String amount, {
    String? gasPrice,
    String? maxGasAmount,
    String? expirationTimestamp,
  }) async {
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

    final payload = Payload(
        "entry_function_payload",
        "$moduleId::$moduleFunc",
        [typeArgs],
        [receiverAddress, amount.toString()]
    );

    final result = _submitTx(
        sender,
        payload,
        entryFunctionPayload,
        gasPrice: gasPrice,
        maxGasAmount: maxGasAmount,
        expirationTimestamp: expirationTimestamp);
    return result;
  }

  /// CHAT MESSAGE ///

  Future<List<String>> getChatList(String address) async {
    try {
      final accountResource = await client.getAccountResouce(address, allContactsResourceType);
      final contacts = accountResource["data"]["contacts"];
      return contacts.cast<String>();
    } catch (e) {
      dynamic err = e;
      if(err.response.statusCode == 404) {
        return [];
      }
      rethrow;
    }
  }

  Future<List<ChatMessage>> getMessages(String myAddress, String otherAddress) async {
    try {
      final accountResource = await client.getAccountResouce(
          myAddress,
          messageStoreResouceType
      );

      final handle = accountResource["data"]["messages"]["handle"];

      final tableItem = new TableItem(
          "address",
          "vector<$moduleId::Message>",
          otherAddress
      );

      final messageData = await client.queryTableItem(
          handle,
          tableItem
      );

      final messageList = <ChatMessage>[];
      for (var message in messageData) {
        messageList.add(ChatMessage.fromJson(message));
      }
      return messageList;
    } catch(e) {
      dynamic err = e;
      if (err.response.statusCode == 404 || err.response.statusCode == 400) {
        return <ChatMessage>[];
      }
      rethrow;
    }
  }

  Future<bool> checkChatEnabled(String address) async {
    try {
      final data = await client.getAccountResouce(address, messageStoreResouceType);
      return data["type"] == messageStoreResouceType;
    } catch(e) {
      dynamic err = e;
      if (err.response.statusCode == 404 || err.response.statusCode == 400) {
        return false;
      }
      rethrow;
    }
  }

  Future<dynamic> enableChat(
      AptosAccount sender,
      {String? gasPrice,
      String? maxGasAmount,
      String? expirationTimestamp}) async {

    const moduleFunc = "init_store";
    final entryFunc = EntryFunction.natural(moduleId, moduleFunc, [], []);
    final entryFunctionPayload = TransactionPayloadEntryFunction(entryFunc);
    final payload = Payload("entry_function_payload", "$moduleId::$moduleFunc", [], []);

    final result = _submitTx(
        sender,
        payload,
        entryFunctionPayload,
        gasPrice: gasPrice,
        maxGasAmount: maxGasAmount,
        expirationTimestamp: expirationTimestamp);
    return result;
  }

  Future<dynamic> sendMessage(
      AptosAccount sender,
      String receiverAddress,
      String message,
      {String? gasPrice,
      String? maxGasAmount,
      String? expirationTimestamp}) async {
    const moduleFunc = "send";
    final entryFunc = EntryFunction.natural(
      moduleId,
      moduleFunc,
      [],
      [bcsToBytes(AccountAddress.fromHex(receiverAddress)), bcsSerializeStr(message)]
    );
    final entryFunctionPayload = TransactionPayloadEntryFunction(entryFunc);
    final payload = Payload(
        "entry_function_payload",
        "$moduleId::$moduleFunc",
        [],
        [receiverAddress, HexString.fromBuffer(Uint8List.fromList(utf8.encode(message))).hex()]
    );

    final result = _submitTx(
        sender,
        payload,
        entryFunctionPayload,
        gasPrice: gasPrice,
        maxGasAmount: maxGasAmount,
        expirationTimestamp: expirationTimestamp);
    return result;
  }

  Future<bool> isPending(String txHash) async {
    return await client.transactionPending(txHash);
  }

  Future<BigInt> estimateGasAmount(TransactionRequest tx) async {
    final gasAmount = await client.estimateGasAmount(tx);
    return gasAmount;
  }

  Future<int> gasPrice() async {
    final gasPrice = await client.estimateGasPrice();
    return gasPrice;
  }

  Future<BigInt> estimateGasPrice(TransactionRequest tx) async {
    final gasPrice = await client.estimateGasUnitPrice(tx);
    return gasPrice;
  }

  Future<dynamic> _submitTx(
      AptosAccount sender,
      Payload payload,
      TransactionPayload entryFunctionPayload,
      {String? gasPrice,
      String? maxGasAmount,
      String? expirationTimestamp}
  ) async {
    final senderAddress = sender.address;
    final accountInfo = await client.getAccount(senderAddress);
    final ledgerInfo = await client.getLedgerInfo();
    final sequenceNumber = int.parse(accountInfo.sequenceNumber);

    gasPrice ??= (await client.estimateGasPrice()).toString();
    maxGasAmount ??= "2000";
    expirationTimestamp ??= DateTime.now().add(Duration(minutes: 1)).millisecondsSinceEpoch.toString();

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
        sequenceNumber: rawTx.sequenceNumber.toString(),
        maxGasAmount: rawTx.maxGasAmount.toString(),
        gasUnitPrice: rawTx.gasUnitPrice.toString(),
        expirationTimestampSecs: rawTx.expirationTimestampSecs.toString(),
        payload: payload,
        signature: Signature("ed25519_signature", sender.pubKey().hex(), "0x"+HEX.encode(signature)));

    final result = await client.submitTransaction(tx);
    debugPrint(result.toString());
    return result;
  }
}