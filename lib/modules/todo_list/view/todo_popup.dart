import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../_utils/custom_widgets/custom_sizedbox.dart';
import '../../../_utils/custom_widgets/custom_textformfield.dart';
import '../../../_utils/helpers/validations.dart';
import '../../../_utils/res/colors.dart';
import '../../../_utils/res/dimen.dart';
import '../../../_utils/res/strings.dart';
import '../controller/todo_bloc.dart';
import '../model/todo_dto.dart';

class TodoPopup extends StatelessWidget {
  TodoPopup(
      {Key? key,
      this.mContext,
      required this.type,
      this.id,
      required this.titleController,
      required this.descriptionController})
      : super(key: key);

  final BuildContext? mContext;
  final Type type;
  final String? id;
  final TextEditingController titleController, descriptionController;

  final _formKey = GlobalKey<FormState>();

  void _returnErrorText(String? id) {
    bool isValidated = _formKey.currentState?.validate() ?? false;
    if (isValidated) {
      _addUpdateTodo(id);
    }
  }

  void _addUpdateTodo(String? id) {
    id == null
        ? mContext?.read<TodoBloc>().add(
              AddTodo(
                TodoDTO(
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  createdAt: Timestamp.now(),
                ),
              ),
            )
        : mContext?.read<TodoBloc>().add(
              UpdateTodo(
                TodoDTO(
                  id: id,
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  createdAt: Timestamp.now(),
                ),
              ),
            );
    titleController.text = '';
    descriptionController.text = '';
    Navigator.pop(mContext!, true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimen.size20),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              type == Type.add ? AppString.addNewTodo : AppString.editTodo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppDimen.size18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const CustomSizedBox(
              height: AppDimen.size20,
            ),
            CustomTextFormField(
              controller: titleController,
              labelText: AppString.title,
              hintText: AppString.enterTitle,
              textInputAction: TextInputAction.next,
              maxLines: 2,
              minLines: 1,
              maxLength: 50,
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
              validator: (value) {
                return Validation.titleValidation(value);
              },
            ),
            const CustomSizedBox(
              height: AppDimen.size20,
            ),
            CustomTextFormField(
              controller: descriptionController,
              labelText: AppString.description,
              hintText: AppString.enterDescription,
              maxLines: 5,
              minLines: 1,
              maxLength: 250,
              inputFormatters: [
                LengthLimitingTextInputFormatter(250),
              ],
              validator: (value) {
                return Validation.descriptionValidation(value);
              },
            ),
            const CustomSizedBox(
              height: AppDimen.size20,
            ),
            ElevatedButton(
              onPressed: () {
                _returnErrorText(id);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.amber),
              ),
              child: Text(type == Type.add ? AppString.add : AppString.update),
            )
          ],
        ),
      ),
    );
  }
}
