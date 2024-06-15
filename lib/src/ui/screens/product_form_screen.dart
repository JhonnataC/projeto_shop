// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shop/src/domain/models/product.dart';
import 'package:shop/src/domain/models/product_list.dart';
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

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    imageUrlFocus.addListener(updateImage);
  }

  void updateImage() {
    setState(() {});
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

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  Future<void> submitForm() async {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    formKey.currentState?.save();

    setState(() => isLoading = true);

    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(formData);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('We had an error adding the product'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            )
          ],
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário do Produto'),
        actions: [
          IconButton(
            onPressed: submitForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Carregando...'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: formData['name']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Nome',
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
                          return 'Este nome é inválido';
                        }

                        return null;
                      },
                      onSaved: (name) => formData['name'] = name ?? '',
                    ),
                    TextFormField(
                      initialValue: formData['price']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Preço',
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
                          return 'Preço inválido';
                        }

                        return null;
                      },
                      onSaved: (price) =>
                          formData['price'] = double.tryParse(price!) ?? 0,
                    ),
                    TextFormField(
                      initialValue: formData['description']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
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
                          return 'Descrição inválida';
                        }

                        if (description.trim().length < 10) {
                          return 'A descrição deveria ser mais longa';
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
                              labelText: 'URL da imagem',
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
                                return 'url inválida';
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
                              ? const Text('Adicione a URL',
                                  style: TextStyle(fontSize: 14))
                              : Image.network(imageUrlController.text),
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
