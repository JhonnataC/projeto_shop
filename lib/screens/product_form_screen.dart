import 'package:flutter/material.dart';
import 'package:projeto_shop/models/product.dart';
import 'package:projeto_shop/models/product_list.dart';
import 'package:provider/provider.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final priceFocus = FocusNode();
  final descriptionFocus = FocusNode();

  final imageUrlFocus = FocusNode();
  final imageUrlController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final Map<String, Object> formData = {};

  @override
  void initState() {
    super.initState();
    imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        formData['id'] = product.id;
        formData['name'] = product.name;
        formData['price'] = product.price;
        formData['description'] = product.description;
        formData['url'] = product.imageUrl;
        imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    priceFocus.dispose();
    descriptionFocus.dispose();
    imageUrlFocus.dispose();
    imageUrlFocus.removeListener(updateImage);
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  void submitForm() {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    formKey.currentState?.save();

    Provider.of<ProductList>(
      context,
      listen: false,
    ).saveProduct(formData);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Form'),
        actions: [
          IconButton(
            onPressed: submitForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: formData['name']?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(priceFocus);
                },
                validator: (_name) {
                  final name = _name ?? '';

                  if (name.trim().isEmpty) {
                    return 'the name is invalid';
                  }

                  return null;
                },
                onSaved: (name) => formData['name'] = name ?? '',
              ),
              TextFormField(
                initialValue: formData['price']?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                focusNode: priceFocus,
                textInputAction: TextInputAction.next,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(descriptionFocus);
                },
                validator: (_price) {
                  final priceString = _price ?? '';
                  final price = double.tryParse(priceString) ?? -1;

                  if (price <= 0) {
                    return 'price is invalid';
                  }

                  return null;
                },
                onSaved: (price) =>
                    formData['price'] = double.tryParse(price!) ?? 0,
              ),
              TextFormField(
                initialValue: formData['description']?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
                focusNode: descriptionFocus,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                validator: (_description) {
                  final description = _description ?? '';

                  if (description.trim().isEmpty) {
                    return 'description is invalid';
                  }

                  if (description.trim().length < 10) {
                    return 'the description should be longer';
                  }

                  return null;
                },
                onSaved: (description) =>
                    formData['description'] = description ?? '',
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      focusNode: imageUrlFocus,
                      keyboardType: TextInputType.url,
                      controller: imageUrlController,
                      validator: (_imageUrl) {
                        final imageUrl = _imageUrl ?? '';

                        if (!isValidImageUrl(imageUrl)) {
                          return 'url is invalid';
                        }

                        return null;
                      },
                      onSaved: (imageUrl) =>
                          formData['imageUrl'] = imageUrl ?? '',
                      onFieldSubmitted: (_) => submitForm(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.5,
                        color: Colors.blueGrey,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: imageUrlController.text.isEmpty
                        ? const Text('Enter the Url',
                            style: TextStyle(fontSize: 14))
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(
                              imageUrlController.text,
                              height: 100,
                              width: 100,
                            ),
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
