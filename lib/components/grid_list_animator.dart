import 'package:flutter/cupertino.dart';
import '../app/core/utils/dimensions.dart';

class GridListAnimatorWidget extends StatelessWidget {
  const GridListAnimatorWidget({ this.aspectRatio,required this.items,Key? key}) : super(key: key);
final List<Widget> items;
final double? aspectRatio;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
      child: GridView.count(
        padding: EdgeInsets.only(top: 6.h),
        crossAxisCount: 2,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        mainAxisSpacing: 8.h,
        childAspectRatio:aspectRatio?? 0.957,
        crossAxisSpacing: 15.w,
        children: items,
      ),
    );
  }
}
