import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../network/local/layout_cubit.dart';

Widget defaultTextFormField({
  required String labelText,
  required TextEditingController textController,
  VoidCallback Function(String)? onFieldSubmitted,
  VoidCallback? Function(String?)? onChanged,
  String? Function(String?)? validater,
  IconData? suffix,
  IconData? prefixIcon,
  bool isPassword = false,
  VoidCallback? onTap,
}) =>
    TextFormField(
      onTap: onTap,
      controller: textController,
      validator: validater,
      keyboardType: TextInputType.visiblePassword,
      obscureText: isPassword,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        prefixIcon: Icon(prefixIcon),
        suffix: Icon(suffix),
      ),
    );

Widget taskItem(Map model, BuildContext context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Row(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              '${model["time"]}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model["title"]}',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                '${model["date"]}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              LoyoutCubit.get(context)
                  .updateDB(status: 'done', id: model['id']);
            },
            icon: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            )),
        IconButton(
          onPressed: () {
            LoyoutCubit.get(context)
                .updateDB(status: 'archive', id: model['id']);
          },
          icon: const Icon(
            Icons.archive,
            color: Colors.grey,
          ),
        )
      ],
    ),
    onDismissed: (direction) {
      LoyoutCubit.get(context).deleteRecord(
        id: model['id'],
      );
    },
  );
}

Widget myDividor() {
  return const SizedBox(
    width: double.infinity,
    height: 30,
    child: Divider(
      color: Colors.grey,
    ),
  );
}

Widget tempScreen({
  required IconData icon,
  required String s,
}) =>
    Center(
      child: Column(
        children: [
          Icon(
            icon,
            size: 100,
            color: Colors.grey,
          ),
          Text(
            s,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );

Widget taskBuilder({
  required List tasks,
  required IconData icon,
  required String text,
}) =>
    ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          itemBuilder: (context, index) => taskItem(tasks[index], context),
          separatorBuilder: (context, index) => myDividor(),
          itemCount: tasks.length,
        ),
      ),
      fallback: (context) => tempScreen(
        icon: icon,
        s: text,
      ),
    );
