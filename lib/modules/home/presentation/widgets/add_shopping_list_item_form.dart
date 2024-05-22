import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/home/home.dart';

class AddShoppingListItemForm extends StatefulWidget {
  const AddShoppingListItemForm({super.key, this.item});

  final ShoppingListItem? item;

  @override
  State<AddShoppingListItemForm> createState() =>
      _AddShoppingListItemFormState();
}

class _AddShoppingListItemFormState extends State<AddShoppingListItemForm> {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();

  bool isSubmitting = false;

  bool get canSubmit => isNameValid && isQuantityValid;
  bool get isNameValid => nameController.text.isNotEmpty;
  bool get isQuantityValid {
    if (quantityController.text.isEmpty) return false;

    final quantity = int.tryParse(quantityController.text);

    return quantity != null && quantity > 0;
  }

  @override
  void initState() {
    super.initState();

    quantityController.text = "1";

    nameController.addListener(() {
      setState(() {});
    });
    quantityController.addListener(() {
      setState(() {});
    });

    if (widget.item != null) {
      nameController.text = widget.item!.name;
      quantityController.text = widget.item!.quantity.toString();
    }
  }

  Future<void> submit() async {
    if (!canSubmit) return;

    setState(() {
      isSubmitting = true;
    });

    final items = context.read<ShoppingListItemsRepository>();

    if (widget.item != null) {
      await items.updateItem(
        widget.item!.id,
        nameController.text.trim(),
        int.parse(quantityController.text),
      );
    } else {
      await items.addItem(
        nameController.text.trim(),
        int.parse(quantityController.text),
      );
    }

    setState(() {
      isSubmitting = false;
    });

    Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CupertinoFormSection.insetGrouped(
          header: "".text,
          children: [
            CupertinoFormRow(
              prefix: const Icon(CupertinoIcons.tag),
              child: CupertinoTextFormFieldRow(
                controller: nameController,
                placeholder: "Item name",
              ),
            ),
            CupertinoFormRow(
              prefix: const Icon(CupertinoIcons.number),
              child: CupertinoTextFormFieldRow(
                controller: quantityController,
                placeholder: "Quantity",
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
        CupertinoButton.filled(
          onPressed: canSubmit ? submit : null,
          child: isSubmitting
              ? const CupertinoActivityIndicator()
              : Text(widget.item != null ? "Update" : "Add item"),
        ).stretch(PaddingHorizontal()),
      ],
    );
  }
}
