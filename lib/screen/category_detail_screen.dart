import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../services/dbbebidas.dart';

class CategoryDetailScreen extends StatefulWidget {
  final Category? category;

  CategoryDetailScreen({this.category});

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'Crear Categoria' : 'Editar Categoria'),
        actions: widget.category != null
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await DatabaseService().deleteCategory(widget.category!.id!);
              Navigator.pop(context, true);
            },
          ),
        ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final category = Category(
                      id: widget.category?.id,
                      name: _nameController.text,
                    );

                    if (widget.category == null) {
                      await DatabaseService().insertCategory(category);
                    } else {
                      await DatabaseService().updateCategory(category);
                    }

                    Navigator.pop(context, true);
                  }
                },
                child: Text(widget.category == null ? 'Crear' : 'Editar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
