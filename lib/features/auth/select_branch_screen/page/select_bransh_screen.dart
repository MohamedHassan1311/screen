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
import '../../../../app/core/utils/text_styles.dart';
import '../../../../app/localization/localization/language_constant.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../components/dynamic_drop_down_button.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../../dashBoard/provider/files_provider.dart';
import '../provider/auth_provider.dart';

class SelectBranchScreen extends StatefulWidget {
  const SelectBranchScreen({Key? key}) : super(key: key);

  @override
  State<SelectBranchScreen> createState() => _SelectBranchScreenState();
}

class _SelectBranchScreenState extends State<SelectBranchScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      // await Provider.of<AuthProvider>(context, listen: false).logIn();
      Provider.of<AuthProvider>(context, listen: false).getBranches();

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
                      Form(
                          key: _formKey,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 30.h, 0, 24.h),
                                      child: Text(
                                        "الفرع",
                                        style: AppTextStyles.w600.copyWith(
                                            fontSize: 15,
                                            color: ColorResources.WHITE_COLOR),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          provider.isLoadinBranches == false,
                                      child: DynamicDropDownButton(
                                        items:
                                            provider.storeBranches?.items ?? [],
                                        name: provider.branch?.aname ?? "الفرع",
                                        onChange: provider.selectedBranch,
                                        value: provider.branch,
                                        isInitial: provider.branch != null,
                                      ),
                                    ),
                                    Visibility(
                                      visible: provider.isLoadinBranches,
                                      child: Center(
                                        child: LoadingAnimationWidget.inkDrop(
                                          size: 50,
                                          color: ColorResources.PRIMARY_COLOR,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10.h,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 30.h, 0, 24.h),
                                      child: Text(
                                        "القسم",
                                        style: AppTextStyles.w600.copyWith(
                                            fontSize: 15,
                                            color: ColorResources.WHITE_COLOR),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          provider.isLoadingSection == false ||
                                              provider.storeSection == null,
                                      child: DynamicDropDownButton(
                                        items: provider.storeSection ?? [],
                                        name:
                                            provider.section?.aname ?? "القسم",
                                        onChange: provider.selectedSection,
                                        value: provider.section,
                                        isInitial: provider.section != null,
                                      ),
                                    ),
                                    Visibility(
                                      visible: provider.isLoadingSection &&
                                          provider.storeSection != null,
                                      child: Center(
                                        child: LoadingAnimationWidget.inkDrop(
                                          size: 50,
                                          color: ColorResources.PRIMARY_COLOR,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10.h,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 30.h, 0, 24.h),
                                      child: Text(
                                        "الشاشة",
                                        style: AppTextStyles.w600.copyWith(
                                            fontSize: 15,
                                            color: ColorResources.WHITE_COLOR),
                                      ),
                                    ),
                                    DynamicDropDownButton(
                                      items: provider.storeScreen ?? [],
                                      name: provider.screen?.aname ?? "الشاشة",
                                      onChange: provider.selectedScreen,
                                      value: provider.screen,
                                      isInitial: provider.screen != null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      CheckboxListTile(
                          subtitle: Text("ظهور شاشة الطلبات ",  style: AppTextStyles.w600.copyWith(
                              fontSize: 15,
                              color: ColorResources.WHITE_COLOR),),
                          value: provider.isChecked,
                          onChanged: provider.changeCheckBoxValue),
                      SizedBox(
                        height: 85.h,
                      ),

                      SizedBox(
                        width: 250.h,
                        child: CustomButton(
                            text: "حفظ",
                            onTap: () async {
                              await Provider.of<MediaProvider>(context,
                                      listen: false)
                                  .remove();
                              Provider.of<MediaProvider>(context, listen: false)
                                  .getFilesByScreenID();
                              Provider.of<MediaProvider>(context, listen: false)
                                  .getLastNews();
                              CustomNavigator.push(Routes.DASHBOARD,
                                  clean: true, arguments: 0);
                            }),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      InkWell(
                          onTap: () {
                            Provider.of<AuthProvider>(context, listen: false)
                                .logOutFromAccount();
                          },
                          child: Text(
                            "تسجيل خروج",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.w500.copyWith(),
                          ))
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
