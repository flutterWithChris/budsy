import 'package:budsy/stash/model/cannabinoid.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/model/terpene.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Create a new product
  Future<Product?> addProduct(Product product) async {
    try {
      final response =
          await _supabaseClient.from('products').upsert(product.toJson());

      return Product.fromJson(response.data.first);
    } catch (e) {
      print('Error adding product: $e');
      return null;
    }
  }

  // Fetch products for a specific user
  Future<List<Product>?> fetchProducts(String userId) async {
    print('Fetching products for user $userId');
    try {
      final response = await _supabaseClient
          .from('products')
          .select('*')
          .eq('user_id', userId);

      print('Response: $response');

      return response.map((product) => Product.fromJson(product)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return null;
    }
  }

  // Update a product
  Future<Product> updateProduct(Product product) async {
    final response = await _supabaseClient
        .from('products')
        .update(product.toJson())
        .eq('id', product.id!);

    return Product.fromJson(response.data.first);
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    await _supabaseClient.from('products').delete().eq('id', productId);
  }

  // Fetch a product by its ID
  Future<Product?> fetchProductById(String productId) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select(
              '*, product_categories(name, icon_name, color), flower_types(name, icon_name, color)')
          .eq('id', productId);

      return Product.fromJson(response.first);
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  // Fetch cannabinoids for a specific product
  Future<List<Cannabinoid>?> fetchCannabinoids(String productId) async {
    try {
      final response = await _supabaseClient
          .from('product_cannabinoids')
          .select('cannabinoids(*), amount')
          .eq('product_id', productId);

      print('Cannabinoids response: $response');
      print(
          'Cannabinoids Amount: ${response.map((cannabinoid) => cannabinoid['amount'])}');

      List<Cannabinoid> cannabinoids = response
          .map((cannabinoid) =>
              Cannabinoid.fromJson(cannabinoid['cannabinoids'])
                  .copyWith(amount: cannabinoid['amount']))
          .toList();

      print('Cannabinoids: $cannabinoids');

      return cannabinoids;
    } catch (e) {
      print('Error fetching cannabinoids: $e');
      return null;
    }
  }

  // Fetch terpenes for a specific product
  Future<List<Terpene>?> fetchTerpenes(String productId) async {
    try {
      final response = await _supabaseClient
          .from('product_terpenes')
          .select('terpenes(*), amount')
          .eq('product_id', productId);

      List<Terpene> terpenes = response
          .map((terpene) => Terpene.fromJson(terpene['terpenes'])
              .copyWith(amount: terpene['amount']))
          .toList();

      return terpenes;
    } catch (e) {
      print('Error fetching terpenes: $e');
      return null;
    }
  }

  // Fetch images for a specific product
  Future<List<String>?> fetchProductImages(String productId) async {
    try {
      final response = await _supabaseClient
          .from('product_images')
          .select('image_url')
          .eq('product_id', productId);

      return response.map((image) => image['image_url'] as String).toList();
    } catch (e) {
      print('Error fetching images: $e');
      return null;
    }
  }
}
