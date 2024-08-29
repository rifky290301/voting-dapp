import 'package:flutter/material.dart';
import 'package:voting_dapp/vote_page.dart';
import 'package:voting_dapp/voting_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controllerCreateVote = TextEditingController();
  final serviceVote = VotingService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vote App'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create Vote'),
              TextField(
                decoration: const InputDecoration(hintText: 'Masukkan topik'),
                controller: controllerCreateVote,
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  child: const Text('Buat Voting'),
                  onPressed: () async {
                    await serviceVote.createVote(controllerCreateVote.text);
                    setState(() {});
                  },
                ),
              ),
              const Text(
                'Topik Tersedia',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder(
                  future: serviceVote.getAllTopics(),
                  builder: (context, snapshot) {
                    List<String> topics = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: topics.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            topics[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VotePage(
                                  topic: topics[index],
                                  votingService: serviceVote,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
