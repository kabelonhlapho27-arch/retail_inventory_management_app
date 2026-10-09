// Add / Edit Product screen
// Used for both adding a new product and editing an existing one.
// If a product is passed in, the form opens in "edit" mode with its values loaded.

import 'package:flutter/material.dart';

import 'product.dart';

class AddProductScreen extends StatefulWidget {
  // null = adding a new product, otherwise = editing this product
  final Product? product;
  final List<String> existingCodes;

  const AddProductScreen({super.key, this.product, this.existingCodes = const []});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Key used to validate the whole form at once
  final _formKey = GlobalKey<FormState>();

  // Controllers hold the text typed into each field
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  // Selected dropdown values
  String _category = kCategories.first;
  String _status = kStatuses.first;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();

    // Edit mode: load the existing product's values into the form
    final product = widget.product;
    if (product != null) {
      _codeController.text = product.productCode;
      _nameController.text = product.productName;
      _priceController.text = product.price.toStringAsFixed(2);
      _quantityController.text = product.quantity.toString();
      _category = kCategories.contains(product.category)
          ? product.category
          : 'Other';
      _status = kStatuses.contains(product.status)
          ? product.status
          : kStatuses.first;
    }
  }

  @override
  void dispose() {
    // Free the controllers when the screen closes
    _codeController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  // ---------- Validation ----------

  String? _validateCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product code is required';
    }
    if (value.contains(',')) {
      return 'Product code may not contain commas';
    }
    final code = value.trim().toUpperCase();
    if (!_isEditing &&
        widget.existingCodes.any((c) => c.toUpperCase() == code)) {
      return 'A product with this code already exists';
    }
    return null; // null means the input is valid
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product name is required';
    }
    if (value.contains(',')) {
      return 'Product name may not contain commas';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    final price = double.tryParse(value?.trim() ?? '');
    if (price == null) {
      return 'Enter a valid price, e.g. 24.99';
    }
    if (price <= 0) {
      return 'Price must be greater than zero';
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    final quantity = int.tryParse(value?.trim() ?? '');
    if (quantity == null) {
      return 'Enter a whole number, e.g. 35';
    }
    if (quantity < 0) {
      return 'Quantity may not be negative';
    }
    return null;
  }

  // Suggests a status when the quantity changes (user can still override it)
  void _updateStatusFromQuantity(String value) {
    final quantity = int.tryParse(value.trim());
    if (quantity == null || quantity < 0) return;
    setState(() {
      if (quantity == 0) {
        _status = 'Out of Stock';
      } else if (quantity <= 5) {
        _status = 'Low Stock';
      } else {
        _status = 'Available';
      }
    });
  }

  // ---------- Save ----------

  void _save() {
    // Runs every validator; stops here if any field is invalid
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      productCode: _codeController.text.trim(),
      productName: _nameController.text.trim(),
      category: _category,
      price: double.parse(_priceController.text.trim()),
      quantity: int.parse(_quantityController.text.trim()),
      status: _status,
      image: Product.imageForCategory(_category),
    );

    // Send the new/updated product back to the previous screen
    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Product' : 'Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product image preview - changes with the selected category
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.green.shade200,
                  child: ClipOval(
                    child: Image.asset(
                      Product.imageForCategory(_category),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.inventory_2,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Image is chosen automatically from the category',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Product Code
              TextFormField(
                controller: _codeController,
                readOnly: _isEditing,
                decoration: InputDecoration(
                  labelText: 'Product Code',
                  hintText: 'e.g. PRD006',
                  helperText: _isEditing ? 'Product code cannot be changed' : null,
                  border: const OutlineInputBorder(),
                ),
                validator: _validateCode,
              ),
              const SizedBox(height: 16),

              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'e.g. Coca-Cola 2L',
                  border: OutlineInputBorder(),
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: kCategories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _category = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Unit Price - numeric keyboard with decimal point
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Unit Price',
                  prefixText: 'R ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: _validatePrice,
              ),
              const SizedBox(height: 16),

              // Quantity in Stock - numeric keyboard
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity in Stock',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: _validateQuantity,
                onChanged: _updateStatusFromQuantity,
              ),
              const SizedBox(height: 16),

              // Status
              DropdownButtonFormField<String>(
                key: ValueKey(_status),
                initialValue: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: kStatuses
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _status = value);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Cancel and Save buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      child: Text(_isEditing ? 'Save Changes' : 'Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
