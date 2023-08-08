import 'package:code_scan_listener/code_scan_listener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live/app/core/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import '../../../app/core/utils/color_resources.dart';
import '../../../app/core/utils/text_styles.dart';
import '../../../components/custom_text_form_field.dart';

import '../provider/files_provider.dart';

class SideBarWidget extends StatefulWidget {
  const SideBarWidget({super.key});

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  FocusNode? focusNode;
  FocusNode? rawKeyboardListenerNode;
  @override
  void initState() {
    focusNode = FocusNode();
    rawKeyboardListenerNode = FocusNode();
Future.delayed(Duration.zero,(){
  Provider.of<SpeakProvider>(context, listen: false).restData();
});
    super.initState();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).requestFocus(focusNode);
    FocusScope.of(context).requestFocus(rawKeyboardListenerNode);
    return RawKeyboardListener(
        focusNode: rawKeyboardListenerNode!,
        onKey: (e){},

            /*(event) {
          if(event.isKeyPressed(LogicalKeyboardKey.digit0)) {
            Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(0);
            print(0);
          }
          if(event.isKeyPressed(LogicalKeyboardKey.digit1)) {
            Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(1);
            print(1);
          }
          if(event.isKeyPressed(LogicalKeyboardKey.digit2)) {
            Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(2);
            print(1);
          }
          if(event.isKeyPressed(LogicalKeyboardKey.digit3)) {
            Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(3);
            print(3);
          }
          if(event.isKeyPressed(LogicalKeyboardKey.digit4)) {
            Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(4);
            print(4);
          }
          if(event.isKeyPressed(LogicalKeyboardKey.digit5)) {
            Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(5);
            print(5);
          }
          if(event.isKeyPressed(LogicalKeyboardKey.digit6)) {
            Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(6);
            print(6);
          }   if(event.isKeyPressed(LogicalKeyboardKey.digit7)) {
            Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(7);
            print(6);
          }
          if(event.isKeyPressed(LogicalKeyboardKey.digit8)) {
            Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(8);
            print(6);
          }
          if(event.isKeyPressed(LogicalKeyboardKey.digit9)) {
            Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(9);
            print(9);
          } if(event.isKeyPressed(LogicalKeyboardKey.enter)) {
            Provider.of<SpeakProvider>(context, listen: false).speak();
            print(9);
          }
        // NOT PRINTED!!
        },*/
      child: Consumer<SpeakProvider>(builder: (context, provider, _) {
        return BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade500.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25)),
                child: Stack(
                  children: [

                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 30.h, 0, 24.h),
                            child: Text(
                              "رقم الطلب",
                              style: AppTextStyles.w600.copyWith(
                                  fontSize: 15,
                                  color: ColorResources.WHITE_COLOR),
                            ),
                          ),
                          CustomTextFormField(
                            controller: provider.textEditingController,
                            read: true,



                            inputType: TextInputType.number,

                            keyboardAction: TextInputAction.go,
                            focus: focusNode,
                            onChanged: (s){
                              Future.delayed(Duration(milliseconds: 900),(){
                              print("play");
                              // provider. updateOrderNumber(int.parse('$s'));
                              // provider.speak();
                              print("play");
                              });

                            },

                            onSaved: (xc) async {
                              provider. updateOrderNumber(int.parse('${provider.textEditingController.text.trim()}'));
                              provider.speak();
                              // provider. updateOrderNumber(0);
                            },
                          ),
                          IconButton(
                            icon: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.speaker,
                                    color: Colors.white,
                                  ),
                                )),
                            onPressed: () async {
                              // FocusScope.of(context).unfocus();
                              provider. updateOrderNumber(int.parse('${provider.textEditingController.text.trim()}'));

                              provider.speak();
                            },
                          ),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: provider.orderStrings.length < 20
                                      ? provider.orderStrings.length
                                      : 0,
                                  itemBuilder: (context, index) {
                                    final orderList =
                                        provider.orderStrings.reversed.toList();
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          10, 10.h, 10, 1.h),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.green.shade500
                                                .withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 30.h, 10, 24.h),
                                          child: Text(
                                            orderList[index],
                                            style: AppTextStyles.w600.copyWith(
                                                fontSize: 20,
                                                color:
                                                    ColorResources.WHITE_COLOR),
                                          ),
                                        ),
                                      ),
                                    );
                                  })),
                        ],
                      ),
                    ),
                  ],
                ))

        );
      }),
    );
  }
}
