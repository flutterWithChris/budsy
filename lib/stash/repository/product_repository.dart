import 'dart:io';

import 'package:canjo/app/snackbars.dart';
import 'package:canjo/consts.dart';
import 'package:canjo/stash/model/cannabinoid.dart';
import 'package:canjo/stash/model/product.dart';
import 'package:canjo/stash/model/terpene.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
      print('Create product response: $response');
      Product createdProduct = Product.fromJson(response.first);
      print('Created Product');
      return createdProduct;
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error creating product!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Fetch products for a specific user
  Future<List<Product>?> fetchProducts(String userId) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select('*')
          .eq('user_id', userId);

      return response.map((product) => Product.fromJson(product)).toList();
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error fetching products!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Update a product
  Future<Product?> updateProduct(Product product) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .update(product.toJson())
          .eq('id', product.id!)
          .select();

      return Product.fromJson(response.first);
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error updating product!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await _supabaseClient.from('products').delete().eq('id', productId);
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error deleting product!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return;
    }
  }

  // Fetch a product by its ID
  Future<Product?> fetchProductById(String productId) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select('*')
          .eq('id', productId);

      return Product.fromJson(response.first);
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error fetching product!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
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

      List<Cannabinoid> cannabinoids = response
          .map((cannabinoid) =>
              Cannabinoid.fromJson(cannabinoid['cannabinoids'])
                  .copyWith(amount: cannabinoid['amount']))
          .toList();

      return cannabinoids;
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error fetching cannabinoids!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Remove cannabinoids from a product
  Future<void> removeProductCannabinoids(String productId) async {
    try {
      await _supabaseClient
          .from('product_cannabinoids')
          .delete()
          .eq('product_id', productId);
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error removing cannabinoids!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return;
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
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error fetching terpenes!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
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

      if (response.isNotEmpty) {
        final imageUrls = (response as List)
            .map((image) => image['image_url'] as String)
            .toList();

        // Generate signed URLs for each image
        final signedUrls = await Future.wait(imageUrls.map((imagePath) async {
          final signedUrlResponse = await _supabaseClient.storage
              .from('product_images')
              .createSignedUrl(imagePath, 60); // 60 seconds validity

          return signedUrlResponse;
        }).toList());

        return signedUrls.where((url) => url != null).toList();
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error fetching images!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
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
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error fetching cannabinoids!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Fetch all terpenes
  Future<List<Terpene>?> fetchAllTerpenes() async {
    try {
      final response = await _supabaseClient.from('terpenes').select('*');

      return response.map((terpene) => Terpene.fromJson(terpene)).toList();
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error fetching terpenes!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // Add cannabinoids to a product
  Future<void> addProductCannabinoids(
      String productId, List<Cannabinoid> cannabinoids) async {
    try {
      final List<Map<String, dynamic>> data = cannabinoids
          .map((cannabinoid) => {
                'product_id': productId,
                'cannabinoid_id': cannabinoid.id,
                'amount': cannabinoid.amount
              })
          .toList();

      await _supabaseClient.from('product_cannabinoids').upsert(data);
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error adding cannabinoids!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }

  // Add terpenes to a product

  Future<void> addProductTerpenes(
      String productId, List<Terpene> terpenes) async {
    try {
      final List<Map<String, dynamic>> data = terpenes
          .map((terpene) => {
                'product_id': productId,
                'terpene_id': terpene.id,
                'amount': terpene.amount
              })
          .toList();

      await _supabaseClient.from('product_terpenes').upsert(data);
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error adding terpenes!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return;
    }
  }

  // Remove terpenes from a product
  Future<void> removeProductTerpenes(String productId) async {
    try {
      await _supabaseClient
          .from('product_terpenes')
          .delete()
          .eq('product_id', productId);
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error removing terpenes!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return;
    }
  }

// Add images to a product
  Future<void> addProductImages(
      String userId, String productId, List<XFile> images) async {
    try {
      final List<Map<String, dynamic>> data = [];
      Uuid uuid = const Uuid();

      for (var i = 0; i < images.length; i++) {
        String imageId = uuid.v4();
        File imageFile = File(images[i].path);
        XFile image = images[i];

        // Determine the content type
        final mimeType =
            lookupMimeType(imageFile.path) ?? 'application/octet-stream';

        // Upload to Supabase storage with content type
        final uploadResult =
            await _supabaseClient.storage.from('product_images').upload(
                  '$userId/$productId/${imageId}_${image.name}',
                  imageFile,
                  fileOptions: FileOptions(
                    cacheControl: '3600',
                    upsert: false,
                    contentType: mimeType,
                  ),
                );

        if (uploadResult.isEmpty) {
          // Handle the error appropriately here
          scaffoldKey.currentState!
              .showSnackBar(getErrorSnackBar('Error uploading image!'));
          throw 'Error uploading image';
        }

        // Retrieve public URL
        final String filePath = '$userId/$productId/${imageId}_${image.name}';

        data.add({'product_id': productId, 'image_url': filePath});
      }

      if (data.isNotEmpty) {
        // Store in the database

        await _supabaseClient.from('product_images').insert(data);
      }
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error adding images!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }

  // Remove images from a product
  Future<void> removeProductImages(String productId) async {
    try {
      await _supabaseClient
          .from('product_images')
          .delete()
          .eq('product_id', productId);
    } catch (e, stackTrace) {
      scaffoldKey.currentState!
          .showSnackBar(getErrorSnackBar('Error removing images!'));
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return;
    }
  }
}
