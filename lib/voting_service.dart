import 'dart:developer';

import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart'; // For making HTTP requests
import 'package:flutter/services.dart';

class VotingService {
  final String rpcUrl = "http://127.0.0.1:7545"; // Ganache URL
  final String privateKey = "0x1b316c67fcf3915fa4216970048607752bc4816ab7de3292e5a7ed7f83ab94c5";

  late Web3Client _client;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _credentials;

  VotingService() {
    _client = Web3Client(rpcUrl, Client());
    _initialize();
  }

  Future<void> _initialize() async {
    log("_initialize _initialize _initialize");
    _credentials = EthPrivateKey.fromHex(privateKey);
    _abiCode = await rootBundle.loadString("assets/Voting.json");
    _contractAddress = EthereumAddress.fromHex("0x56Fe29ea53FE2Af22746dd510056Ff5EC0928C3E");
  }

  Future<void> createVote(String topic) async {
    try {
      print('------------------- $topic');
      final contract = DeployedContract(ContractAbi.fromJson(_abiCode, "Voting"), _contractAddress);
      print('------------------- 32');
      final createVoteFunction = contract.function("createVote");
      print('------------------- 34');

      await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
          contract: contract,
          function: createVoteFunction,
          parameters: [topic],
        ),
      );
    } catch (e) {
      log(topic.runtimeType.toString()); // Harusnya String
      log(e.toString());
    }
  }

  Future<void> vote(String topic, bool voteYes) async {
    final contract = DeployedContract(ContractAbi.fromJson(_abiCode, "Voting"), _contractAddress);
    final voteFunction = contract.function("vote");

    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: contract,
        function: voteFunction,
        parameters: [topic, voteYes],
      ),
    );
  }

  Future<List<dynamic>> getResults(String topic) async {
    final contract = DeployedContract(ContractAbi.fromJson(_abiCode, "Voting"), _contractAddress);
    final getResultsFunction = contract.function("getResults");

    final results = await _client.call(
      contract: contract,
      function: getResultsFunction,
      params: [topic],
    );
    return results;
  }

  Future<List<String>> getAllTopics() async {
    final contract = DeployedContract(ContractAbi.fromJson(_abiCode, "Voting"), _contractAddress);
    final getAllTopicsFunction = contract.function("getAllTopics");

    final topics = await _client.call(
      contract: contract,
      function: getAllTopicsFunction,
      params: [],
    );

    return (topics[0] as List).map((topic) => topic as String).toList();
  }
}
