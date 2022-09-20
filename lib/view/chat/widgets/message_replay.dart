import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsappmessenger/common/providers/message_replay_provider.dart';

class MessageReplayPreview extends ConsumerWidget {
  const MessageReplayPreview({Key? key}) : super(key: key);

  void cancelReplay(WidgetRef ref) {
    ref.read(messageReplayProvider.state).update((state) => null);

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReplay = ref.watch(messageReplayProvider);
    return Container(
      width: 360,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReplay!.isMe ? 'Me' : 'Opposite',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                child: const Icon(Icons.close, size: 16),
                onTap: () => cancelReplay(ref),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(messageReplay.message),
        ],
      ),
    );
  }
}
