import 'dart:io';

import 'package:budsy/stash/model/cannabinoid.dart';
import 'package:budsy/stash/model/product.dart';
import 'package:budsy/stash/model/terpene.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ProductRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Create a new product & re
  Future<Product?> addProduct(Product product) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .upsert(product.toJson())
          .select();
      print('Response: $response');
      Product createdProduct = Product.fromJson(response.first);
      print('Created Product: $createdProduct');

      return createdProduct;
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
    try {
      final response = await _supabaseClient
          .from('products')
          .update(product.toJson())
          .eq('id', product.id!)
          .select();

      return Product.fromJson(response.first);
    } catch (e) {
      print('Error updating product: $e');
      return product;
    }
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
          .select('*')
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

  // Fetch all cannabinoids
  Future<List<Cannabinoid>?> fetchAllCannabinoids() async {
    try {
      final response = await _supabaseClient.from('cannabinoids').select('*');

      return response
          .map((cannabinoid) => Cannabinoid.fromJson(cannabinoid))
          .toList();
    } catch (e) {
      print('Error fetching cannabinoids: $e');
      return null;
    }
  }

  // Fetch all terpenes
  Future<List<Terpene>?> fetchAllTerpenes() async {
    try {
      final response = await _supabaseClient.from('terpenes').select('*');

      return response.map((terpene) => Terpene.fromJson(terpene)).toList();
    } catch (e) {
      print('Error fetching terpenes: $e');
      return null;
    }
  }

  // Add cannabinoids to a product
  Future<void> addProductCannabinoids(
      String productId, List<Cannabinoid> cannabinoids) async {
    final List<Map<String, dynamic>> data = cannabinoids
        .map((cannabinoid) => {
              'product_id': productId,
              'cannabinoid_id': cannabinoid.id,
              'amount': cannabinoid.amount
            })
        .toList();

    await _supabaseClient.from('product_cannabinoids').upsert(data);
  }

  // Add terpenes to a product

  Future<void> addProductTerpenes(
      String productId, List<Terpene> terpenes) async {
    final List<Map<String, dynamic>> data = terpenes
        .map((terpene) => {
              'product_id': productId,
              'terpene_id': terpene.id,
              'amount': terpene.amount
            })
        .toList();

    await _supabaseClient.from('product_terpenes').upsert(data);
  }

  // Add images to a product
  Future<void> addProductImages(String productId, List<XFile> images) async {
    try {
      String? url;
      // Store in supabase storage
      for (var i = 0; i < images.length; i++) {
        Uuid uuid = const Uuid();
        String imageId = uuid.v4();
        File imageFile = File(images[i].path);
        XFile image = images[i];
        url = await _supabaseClient.storage
            .from('product_images')
            .upload('$productId/${image.name}', imageFile);
      }

      if (url == null) {
        print('Error uploading image');
        return;
      }

      // Store in database
      final List<Map<String, dynamic>> data = images
          .map((image) => {'product_id': productId, 'image_url': url})
          .toList();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
