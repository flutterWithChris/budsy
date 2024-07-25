import 'package:canjo/subscription/bloc/subscription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';

class SubscriptionOfferSheet extends StatelessWidget {
  const SubscriptionOfferSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.8,
            builder: (context, controller) {
              return BlocBuilder<SubscriptionBloc, SubscriptionState>(
                builder: (context, state) {
                  if (state is SubscriptionError) {
                    return Container(
                      child: Text('Error: ${state.error}'),
                    );
                  }
                  if (state is SubscriptionLoading) {
                    return Container(
                      child: const Text('Loading...'),
                    );
                  }
                  if (state is SubscriptionLoaded) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Get Canjo Pro',
                                style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 16),
                            Text('Unlock all features with Canjo Pro',
                                style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 16),
                            // List value propositions
                            ListView(
                              shrinkWrap: true,
                              children: const [
                                ListTile(
                                  leading: Icon(Icons.check),
                                  title: Text(''),
                                ),
                                ListTile(
                                  leading: Icon(Icons.check),
                                  title: Text('Access to all terpenes'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.check),
                                  title: Text('Unlock all feelings'),
                                ),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              controller: controller,
                              itemCount: state.packages!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  title: Text(state
                                      .packages![index].storeProduct.title),
                                  trailing: Text(state.packages![index]
                                      .storeProduct.priceString),
                                  onTap: () {
                                    context.read<SubscriptionBloc>().add(
                                        PurchaseSubscription(
                                            state.packages![index]));
                                  },
                                );
                              },
                            ),
                            const Gap(
                              size: 16,
                            ),
                            // Subscribe button
                            FilledButton(
                              onPressed: () {
                                context.read<SubscriptionBloc>().add(
                                    PurchaseSubscription(
                                        state.packages!.first));
                              },
                              child: const Text('Subscribe'),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      child: const Text('Loading...'),
                    );
                  }
                },
              );
            });
      },
    );
  }
}
