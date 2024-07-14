import 'package:budsy/journal/model/journal_entry.dart';
import 'package:flutter/material.dart';

class ViewJournalEntrySheet extends StatelessWidget {
  final JournalEntry journalEntry;
  const ViewJournalEntrySheet(this.journalEntry, {super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.3,
      builder: (context, controller) => BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                journalEntry.products![0].name!,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8.0),
              Text(
                journalEntry.products![0].category!.name,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Feelings',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: journalEntry.feelings!
                    .map(
                      (feeling) => Chip(
                        label: Text(feeling.toString().split('.').last),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
