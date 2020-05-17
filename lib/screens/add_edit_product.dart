import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_arena/providers/products_provider.dart';

class AddOrEditProductScreen extends StatefulWidget {
  @override
  _AddOrEditProductScreenState createState() => _AddOrEditProductScreenState();
}

class _AddOrEditProductScreenState extends State<AddOrEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title;
  double _price;
  String _description;
  String _imageUrl;
  bool _isLoading = false;

  TextEditingController _imageUrlController = TextEditingController();

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  var productId;
  var edProduct;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    Future.delayed(Duration.zero, () {
      productId = ModalRoute.of(context).settings.arguments as String;
      edProduct = Provider.of<ProductsProvider>(context).findById(productId);
      setState(() {
        // _titleController.text = edProduct.title;
        // _priceController.text = edProduct.price;
        // _descriptionController.text = edProduct.description;
        _imageUrlController.text = edProduct.imageUrl;
      });
    });

    super.initState();
  }

  _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _isLoading = true;
      });
      if (productId != null) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(productId, _title, _price, _description, _imageUrl);
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      } else {
        try {
          await Provider.of<ProductsProvider>(context, listen: false)
              .addProduct(_title, _price, _description, _imageUrl);
          Navigator.pop(context);
        } catch (e) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An Error occured'),
              content: Text(e.toString()),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('OK'),
                )
              ],
            ),
          );
        }
      }
    } else {
      print('Error adding product');
    }
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final edProduct =
        Provider.of<ProductsProvider>(context).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _handleSubmit)
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: edProduct != null ? edProduct.title : '',
                      validator: (val) =>
                          val.isEmpty ? 'Title is required' : null,
                      onSaved: (val) => _title = val,
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          // move from title field to price field
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                    ),
                    TextFormField(
                      initialValue: edProduct != null
                          ? edProduct.price.toString()
                          : 0.0.toString(),
                      validator: (val) =>
                          val.isEmpty ? 'Price is required' : null,
                      onSaved: (val) => _price = double.parse(val),
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                    ),
                    TextFormField(
                      initialValue:
                          edProduct != null ? edProduct.description : '',
                      validator: (val) =>
                          val.isEmpty ? 'Description is required' : null,

                      onSaved: (val) => _description = val,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      // textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text(
                                  'Enter an image URL',
                                  textAlign: TextAlign.center,
                                )
                              : FittedBox(
                                  child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                )),
                        ),
                        Expanded(
                          // expanded bcz textformfield inside row gets full width
                          child: TextFormField(
                            // initialValue: edProduct != null ? edProduct.imageUrl:'',
                            // validator: (val) => val.isEmpty ? 'Title is required' : null,

                            onSaved: (val) => _imageUrl = val,
                            controller:
                                _imageUrlController, // controller added bcz we want to see preview
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _handleSubmit(),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
