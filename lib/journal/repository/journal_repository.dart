import 'package:canjo/app/snackbars.dart';
import 'package:canjo/consts.dart';
import 'package:canjo/journal/model/feeling.dart';
import 'package:canjo/journal/model/journal_entry.dart';
import 'package:canjo/stash/model/product.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JournalRepository {
  SupabaseClient client = Supabase.instance.client;

// Get entries & also fetch the related products and feelings
  Future<List<JournalEntry>?> getEntries() async {
    try {
      final response = await client.from('journal_entries').select();
      List<JournalEntry> entries = [];

      List<Future<void>> entryFutures = response.map((entry) async {
        // Fetch related product IDs from journal_products
        final journalProductsResponse = client
            .from('journal_products')
            .select()
            .eq('entry_id', entry['id']);

        // Fetch related feeling IDs from journal_feelings
        final journalFeelingsResponse = client
            .from('journal_feelings')
            .select()
            .eq('entry_id', entry['id']);

        final journalProducts = await journalProductsResponse;
        final journalFeelings = await journalFeelingsResponse;

        // Fetch actual products and feelings data concurrently
        List<Future<Product>> productFutures =
            journalProducts.map((journalProduct) async {
          final productResponse = await client
              .from('products')
              .select()
              .eq('id', journalProduct['product_id'])
              .single();
          return Product.fromJson(productResponse);
        }).toList();

        List<Future<Feeling>> feelingFutures =
            journalFeelings.map((journalFeeling) async {
          final feelingResponse = await client
              .from('feelings')
              .select()
              .eq('id', journalFeeling['feeling_id'])
              .single();
          return Feeling.fromJson(feelingResponse);
        }).toList();

        List<Product> products = await Future.wait(productFutures);
        List<Feeling> feelings = await Future.wait(feelingFutures);

        entries.add(
          JournalEntry.fromJson(entry).copyWith(
            products: products,
            feelings: feelings,
          ),
        );
      }).toList();

      await Future.wait(entryFutures);

      return entries;
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to fetch entries. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Add a new journal entry
  Future<JournalEntry?> addEntry(JournalEntry entry) async {
    try {
      final response = await client
          .from('journal_entries')
          .upsert(entry.toJson(
            userId: Supabase.instance.client.auth.currentUser!.id,
          ))
          .select();

      return JournalEntry.fromJson(response.first);
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to add entry. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Update a journal entry
  Future<JournalEntry?> updateEntry(JournalEntry entry) async {
    try {
      final response = await client
          .from('journal_entries')
          .update(entry.toJson(
            userId: Supabase.instance.client.auth.currentUser!.id,
          ))
          .eq('id', entry.id!)
          .select();
      JournalEntry responseEntry = JournalEntry.fromJson(response.first);
      return responseEntry;
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to update entry. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Delete a journal entry
  Future<void> deleteEntry(String entryId) async {
    try {
      await client.from('journal_entries').delete().eq('id', entryId);
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to delete entry. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }

  // Add products into journal_products table
  Future<void> addProductToEntry(
      String entryId, String productId, String userId) async {
    try {
      await client.from('journal_products').upsert({
        'entry_id': entryId,
        'product_id': productId,
        'user_id': userId,
      });
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to add products. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }

  // Remove products from journal_products table
  Future<void> removeProductsFromEntry(String entryId, String userId) async {
    try {
      await client
          .from('journal_products')
          .delete()
          .eq('entry_id', entryId)
          .eq('user_id', userId);
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to remove products. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }

  // Add feelings into journal_feelings table
  Future<void> addFeelingToEntry(
      String entryId, String feelingId, String userId) async {
    try {
      await client.from('journal_feelings').upsert({
        'entry_id': entryId,
        'feeling_id': feelingId,
        'user_id': userId,
      });
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to add feelings. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }

  // Remove feelings from journal_feelings table
  Future<void> removeFeelingsFromEntry(String entryId, String userId) async {
    try {
      await client
          .from('journal_feelings')
          .delete()
          .eq('entry_id', entryId)
          .eq('user_id', userId);
    } catch (e, stackTrace) {
      scaffoldKey.currentState?.showSnackBar(
        getErrorSnackBar('Failed to remove feelings. Please try again.'),
      );
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }
}
