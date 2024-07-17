import 'package:budsy/journal/model/feeling.dart';
import 'package:budsy/journal/model/journal_entry.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JournalRepository {
  SupabaseClient client = Supabase.instance.client;

  // Get entries & also fetch the related products and feelings
  Future<List<JournalEntry>?> getEntries() async {
    try {
      final response = await client.from('journal_entries').select();
      List<JournalEntry> entries = [];

      for (var entry in response) {
        // Fetch related product IDs from journal_products
        final journalProductsResponse = await client
            .from('journal_products')
            .select()
            .eq('entry_id', entry['id']);

        // Fetch related feeling IDs from journal_feelings
        final journalFeelingsResponse = await client
            .from('journal_feelings')
            .select()
            .eq('entry_id', entry['id']);

        List<Product> products = [];
        List<Feeling> feelings = [];

        // Fetch actual products data from products table
        for (var journalProduct in journalProductsResponse) {
          final productResponse = await client
              .from('products')
              .select()
              .eq('id', journalProduct['product_id'])
              .single();
          products.add(Product.fromJson(productResponse));
        }

        // Fetch actual feelings data from feelings table
        for (var journalFeeling in journalFeelingsResponse) {
          final feelingResponse = await client
              .from('feelings')
              .select()
              .eq('id', journalFeeling['feeling_id'])
              .single();
          feelings.add(Feeling.fromJson(feelingResponse));
        }

        entries.add(
          JournalEntry.fromJson(entry).copyWith(
            products: products,
            feelings: feelings,
          ),
        );
      }
      return entries;
    } catch (e) {
      print(e);
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
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Update a journal entry
  Future<JournalEntry?> updateEntry(JournalEntry entry) async {
    try {
      final response = await client
          .from('journal_entries')
          .upsert(entry.toJson(
            userId: Supabase.instance.client.auth.currentUser!.id,
          ))
          .select();
      return JournalEntry.fromJson(response.first);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Delete a journal entry
  Future<void> deleteEntry(String entryId) async {
    try {
      await client.from('journal_entries').delete().eq('id', entryId);
    } catch (e) {
      print(e);
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
    } catch (e) {
      print(e);
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
    } catch (e) {
      print(e);
    }
  }
}
