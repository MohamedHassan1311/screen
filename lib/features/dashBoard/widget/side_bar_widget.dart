import 'dart:async';

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

import '../provider/SpeakProvider.dart';
import '../provider/files_provider.dart';

class SideBarWidget extends StatefulWidget {
  const SideBarWidget({super.key});

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {

  FocusNode? rawKeyboardListenerNode;
  late FocusAttachment _focusAttachment;
  bool _keyBoardCallback(KeyEvent event){
    {

      if( event.character=="0") {
        Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(0);
        print(0);
      }
      if(event.character=="1") {
        Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(1);
        print(1);
      }
      if(event.character=="2") {
        Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(2);
        print(1);
      }
      if(event.character=="3") {
        Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(3);
        print(3);
      }
      if(event.character=="4") {
        Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(4);
        print(4);
      }
      if(event.character=="5") {
        Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(5);
        print(5);
      }
      if(event.character=="6") {
        Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(6);
        print(6);
      }   if(event.character=="7") {
        Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(7);
        print(6);
      }
      if(event.character=="8") {
        Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(8);
        print(6);
      }
      if(event.character=="9") {
        Provider.of<SpeakProvider>(context, listen: false). updateOrderNumber(9);
        print(9);
      } if(event.logicalKey==LogicalKeyboardKey.enter) {
        Provider.of<SpeakProvider>(context, listen: false).speak();

      }
      // if(event.logicalKey==LogicalKeyboardKey.arrowRight) {
      //   Provider.of<SpeakProvider>(context, listen: false).nextNumber();
      //   print("arrowRight");
      // }  if(event.logicalKey==LogicalKeyboardKey.arrowLeft) {
      //   Provider.of<SpeakProvider>(context, listen: false).previousNumber();
      //   print(9);
      // }
      // NOT PRINTED!!
    }
    return false;
  }
  @override
  void initState() {
    //
    // rawKeyboardListenerNode = FocusNode();


Future.delayed(Duration.zero,(){
  // focusNode.requestFocus();
  Provider.of<SpeakProvider>(context, listen: false).restData();
});
    super.initState();
  }

  List testList=["5",'6','185',"7",'8',"9","10"];

  @override
  Widget build(BuildContext context) {

    return Consumer<SpeakProvider>(builder: (context, provider, _) {
      provider.focusTextField.requestFocus();
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
                          formatter: <TextInputFormatter>[
                            // for below version 2 use this
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),

                            FilteringTextInputFormatter.digitsOnly

                          ],
                          keyboardAction: TextInputAction.go,
                          focus: provider.focusTextField,
                          onSaved: (xc) async {

                              // Timer.periodic(Duration(seconds: 1), (Timer t) async {
                              //   Provider.of<SpeakProvider>(context, listen: false)
                              //       .updateOrderNumber(t.tick);
                              //   Provider.of<SpeakProvider>(context, listen: false).speak();
                              // });


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
    });
  }
}
