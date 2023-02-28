import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled3/shared/component/costant.dart';
import 'package:untitled3/shared/network/local/layout_states.dart';
import '../shared/component/component.dart';
// import '../shared/network/local/database/database.dart';
import '../shared/network/local/layout_cubit.dart';

class LayoutScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return LoyoutCubit();
      },
      child: BlocConsumer<LoyoutCubit, LayoutStates>(
        listener: (context, state) {
          if( state is InsartIntoDatabaseState){
              
          }
        },
        builder: (context, state) {
          var cubit = LoyoutCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.title[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! GetdataFromDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                LoyoutCubit.get(context).iconFloatingBottom,
              ),
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  cubit
                      .insertDB(
                          title: titleController.text,
                          date: dateController.text,
                          time: timeController.text);
                          Navigator.pop(context);
                          cubit.bottomSheetClose();
                  
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) {
                          cubit.bottomSheetOpen();
                          return Container(
                            width: double.infinity,
                            height: 265,
                            color: Colors.amber,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    defaultTextFormField(
                                        textController: titleController,
                                        prefixIcon: Icons.title,
                                        labelText: "Title",
                                        validater: (value) {
                                          if (value == null) {
                                            return ' should not be empty';
                                          }
                                          return null;
                                        },),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    defaultTextFormField(
                                      textController: dateController,
                                      prefixIcon: Icons.date_range_outlined,
                                      labelText: "date",
                                      validater: (value) {
                                        if (value == null) {
                                          return ' should not be empty';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.utc(
                                              2023, 7, 20, 20, 18, 04),
                                        ).then(
                                          (value) {
                                            dateController.text =
                                                value.toString();
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    defaultTextFormField(
                                      textController: timeController,
                                      prefixIcon: Icons.timer_outlined,
                                      labelText: "time",
                                      validater: (value) {
                                        if (value == null) {
                                          return ' should not be empty';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then(
                                          (value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                          },
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                      .closed
                      .then(
                        (value) {
                          cubit.bottomSheetClose();
                        },
                      );
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (value) {
                cubit.changeNavBarIndex(index: value);
              },
              items: cubit.navBarItem,
            ),
          );
        },
      ),
    );
  }
}
