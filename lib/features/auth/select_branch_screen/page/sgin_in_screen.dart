import 'package:live/app/core/utils/color_resources.dart';
import 'package:live/app/core/utils/dimensions.dart';
import 'package:live/app/core/utils/extensions.dart';
import 'package:live/app/core/utils/images.dart';
import 'package:live/app/core/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:live/features/auth/select_branch_screen/repo/auth_repo.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import '../../../../app/core/utils/svg_images.dart';
import '../../../../app/core/utils/text_styles.dart';
import '../../../../app/localization/localization/language_constant.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../components/dynamic_drop_down_button.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../../dashBoard/provider/files_provider.dart';
import '../provider/auth_provider.dart';

class SginInScreen extends StatefulWidget {
  const SginInScreen({Key? key}) : super(key: key);

  @override
  State<SginInScreen> createState() => _SginInScreenState();
}

class _SginInScreenState extends State<SginInScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
Future.delayed(Duration.zero,(){
  Provider.of<AuthProvider>(context, listen: false).getTents();
});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            Images.loginImage,
          ),
          fit: BoxFit.fitWidth,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE.w),
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        vertical: 30.h),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade500.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25)),
                    child: Consumer<AuthProvider>(builder: (_, provider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 30.h, 0, 24.h),
                            child: Text(
                              "اهلا بك ",
                              style: AppTextStyles.w600.copyWith(
                                  fontSize: 28, color: ColorResources.WHITE_COLOR),
                            ),
                          ),
                        /*  CustomTextFormField(
                            controller: provider.baseUrlTEC,
                            hint: "الرابط",
                            onChanged: (c){
                              provider.  updateBaseUrl();
                            },
                          ),*/
                          Form(
                              key: _formKey,
                              child: Row(
                                children: [
                                Expanded(
                                child: CustomTextFormField(
                                  controller: provider.mailTEC,
                                  hint: "اسم المستخدم",
                                  inputType: TextInputType
                                      .emailAddress,


                                ),
                              ),

                                  SizedBox(width: 10,),Expanded(
                                child: CustomTextFormField(
                                  controller: provider.passwordTEC,
                                  hint: "كلمة المرور",



                                ),
                              ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: DynamicDropDownButton(
                                      items:
                                      provider.tents ?? [],
                                      name: provider.tent?.ename ?? " العضوية",
                                      onChange: provider.selectedTent,
                                      value: provider.tent,
                                      isInitial: provider.tent != null,
                                    ),
                                  ),
                                  SizedBox(width: 10,),


                                ],)


                          ),
                          SizedBox(
                            height: 85.h,
                          ),
                          SizedBox(
                              width: 250.h,

                              child: CustomButton(
                                  textSize: 8,
                                  isLoading:provider.isLoading ,
                                  text: "تسجيل دخول",onTap:() async {
                                    provider.logIn(isFromLogin:true);
                               // await Provider.of<MediaProvider>(context, listen: false).remove();
                               //  Provider.of<MediaProvider>(context, listen: false).getFilesByScreenID();
                               //  CustomNavigator.push(Routes.DASHBOARD, clean: true, arguments: 0);
                              }),),
                          SizedBox(
                            height: 15.h,
                          ),

                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
