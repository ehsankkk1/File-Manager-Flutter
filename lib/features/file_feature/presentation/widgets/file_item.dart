import 'package:file_manager/utility/router/app_routes.dart';
import 'package:file_manager/utility/theme/color_style.dart';
import 'package:file_manager/utility/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utility/theme/app_borders.dart';
import '../../domain/entities/file_entity.dart';
import '../bloc/file_list_bloc/file_bloc.dart';

class FileItemWidget extends StatelessWidget {
  FileItemWidget(
      {required this.onChange,
      required this.value,
      required this.event,
      required this.fileEntity,
      Key? key,
      required this.index})
      : super(key: key);
  FileEntity fileEntity;
  FileEvent event;
  int index;
  bool value;
  Function(bool?)? onChange;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: const Color(0xff232323),
        elevation: 0,
        disabledBackgroundColor: AppColors.kGreyColor,
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorders.k0BorderRadius, // <-- Radius
        ),
        padding: EdgeInsets.only(
            left: screenWidth * 0.038,
            right: screenWidth * 0.038,
            top: screenHeight * 0.02,
            bottom: screenHeight * 0.02),
      ),
      onPressed: () {
        Navigator.of(context)
            .pushNamed(AppRoutes.oneFilesScreen, arguments: fileEntity)
            .then((value) => context.read<FileBloc>().add(event));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(value: value, onChanged: onChange),
              CircleAvatar(
                backgroundColor: fileEntity.isAvailable
                    ? AppColors.kGreenColor
                    : AppColors.redColor,
                radius: 30,
                child: const Icon(Icons.file_copy_rounded),
              ),
              SizedBox(
                width: screenWidth * 0.02,
              ),
              Text(
                fileEntity.title,
                style: AppFontStyles.mediumH3,
              ),
            ],
          ),
          if (fileEntity.isAvailable)
            Text(
              "Available",
              style:
                  AppFontStyles.boldH3.copyWith(color: AppColors.kGreenColor),
            )
          else
            Text(
              "Not Available",
              style: AppFontStyles.boldH3.copyWith(color: AppColors.redColor),
            )
        ],
      ),
    );
  }
}
