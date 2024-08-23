import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart'; // For making HTTP requests
import 'package:flutter/services.dart';

class VotingService {
  final String rpcUrl = "http://127.0.0.1:7545"; // Ganache URL
  final String privateKey = "<YOUR_PRIVATE_KEY>"; // Gantilah dengan private key salah satu akun di Ganache

  late Web3Client _client;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late EthPrivateKey _credentials;

  VotingService() {
    _client = Web3Client(rpcUrl, Client());
    _initialize();
  }

  Future<void> _initialize() async {
    _credentials = EthPrivateKey.fromHex(privateKey);

    // Load ABI
    _abiCode = await rootBundle.loadString("assets/Voting.json");

    // Contract address - replace with the address obtained from Ganache after deploying
    _contractAddress = EthereumAddress.fromHex("<YOUR_CONTRACT_ADDRESS>");

    // Other initializations...
  }

  Future<void> createVote(String topic) async {
    final contract = DeployedContract(ContractAbi.fromJson(_abiCode, "Voting"), _contractAddress);
    final createVoteFunction = contract.function("createVote");

    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: contract,
        function: createVoteFunction,
        parameters: [topic],
      ),
    );
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
}
