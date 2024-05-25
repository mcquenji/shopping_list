import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mcquenji_core/mcquenji_core.dart';
import 'package:shopping_list/modules/home/home.dart';
import 'package:shopping_list/utils.dart';

class CreateShoppingListForm extends StatefulWidget {
  const CreateShoppingListForm({super.key});

  @override
  State<CreateShoppingListForm> createState() => _CreateShoppingListFormState();
}

class _CreateShoppingListFormState extends State<CreateShoppingListForm> {
  final nameController = TextEditingController();

  bool get canSubmit => nameController.text.isNotEmpty;

  @override
  void initState() {
    nameController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  Future<void> submit() async {
    if (!canSubmit) return;

    Modular.to.pop();

    final lists = context.read<ShoppingListsRepository>();

    await lists.createNewList(nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CupertinoFormSection.insetGrouped(
            header: "".text,
            children: [
              CupertinoFormRow(
                prefix: const Icon(CupertinoIcons.square_list_fill),
                child: CupertinoTextFormFieldRow(
                  controller: nameController,
                  placeholder: t.shoppingLists_new_name,
                ),
              ),
            ],
          ),
          CupertinoButton.filled(
            onPressed: canSubmit ? submit : null,
            child: t.shoppingLists_new_submit.text,
          ).stretch(PaddingHorizontal().Bottom(40)),
        ],
      ),
    );
  }
}
