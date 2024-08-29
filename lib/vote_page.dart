import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:voting_dapp/voting_service.dart';

class VotePage extends StatefulWidget {
  final String topic;
  final VotingService votingService;
  const VotePage({
    super.key,
    required this.topic,
    required this.votingService,
  });

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  @override
  void initState() {
    var res = widget.votingService.getResults(widget.topic);
    inspect(res);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
      ),
      body: ListView(
        children: [
          Row(children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'Yes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '30',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(width: 12),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'No',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '16',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            ElevatedButton(
              onPressed: () {
                widget.votingService.vote(widget.topic, true);
              },
              child: const Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.votingService.vote(widget.topic, false);
              },
              child: const Text('No'),
            )
          ])
        ],
      ),
    );
  }
}
