import 'package:file_manager/features/file_feature/presentation/bloc/file_action_bloc/file_action_bloc.dart';
import 'package:file_manager/utility/dialogs_and_snackbars/dialogs_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/assets.dart';
import '../../../../utility/global_widgets/elevated_button_widget.dart';
import '../../../../utility/global_widgets/shimmer.dart';
import '../../../../utility/global_widgets/somthing_wrong.dart';
import '../../../../utility/theme/color_style.dart';
import '../bloc/file_list_bloc/file_bloc.dart';
import 'file_item.dart';

class FileList extends StatefulWidget {
  FileList({required this.event, Key? key}) : super(key: key);

  FileEvent event;
  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    search();
    super.initState();
  }

  void search() {
    context.read<FileBloc>().add(widget.event);
  }

  List<int> checkInFilesIds = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<FileBloc, FileState>(builder: (context, state) {
      if (state is FileInitial) {
        return ListView.builder(
            controller: scrollController,
            itemCount: 8,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.038,
                    right: screenWidth * 0.038,
                    top: screenHeight * 0.02,
                    bottom: screenHeight * 0.02),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.kSecondColor,
                      radius: 30,
                      child: Icon(Icons.file_copy_rounded),
                    ),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    ShimmerLoader(
                      height: screenHeight * 0.02,
                      width: screenWidth * 0.4,
                    ),
                  ],
                ),
              );
            });
      }
      if (state is FileDoneState) {
        if (state.files.isEmpty) {
          return SomethingWrongWidget(
            title: "No Files found !",
            svgPath: Assets.imagesSearch,
            elevatedButtonWidget: ElevatedButtonWidget(
              title: "Refresh",
              onPressed: () {
                search();
              },
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            search();
          },
          child: ListView.builder(
              controller: scrollController,
              itemCount: state.files.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index >= state.files.length) {
                  if (checkInFilesIds.isEmpty) {
                    return const SizedBox();
                  }
                  return BlocProvider(
                    create: (context) => FileActionBloc(),
                    child: BlocConsumer<FileActionBloc, FileActionState>(
                      listener: (context, state) {
                        if (state is FileActionResponseState) {
                          DialogsWidgetsSnackBar.showSnackBarFromStatus(
                              context: context,
                              helperResponse: state.helperResponse,
                            popOnSuccess: false,
                          );
                          search();
                          checkInFilesIds = [];
                        }
                      },
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: ElevatedButtonWidget(
                            title: "Check in ${checkInFilesIds.length} Files",
                            isLoading: state is FileActionLoadingState,
                            onPressed: () {
                              context.read<FileActionBloc>().add(
                                  SendCheckInMultipleFilesEvent(
                                      folderId: widget.event.folderId,
                                      fileIds: checkInFilesIds));
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
                return FileItemWidget(
                  fileEntity: state.files[index],
                  index: index,
                  event: widget.event,
                  value: checkInFilesIds.contains(state.files[index].id),
                  onChange: (value) {
                    setState(() {
                      if (value == true) {
                        checkInFilesIds.add(state.files[index].id);
                      } else {
                        checkInFilesIds.removeWhere(
                            (element) => element == state.files[index].id);
                      }
                    });
                  },
                );
              }),
        );
      }
      return SomethingWrongWidget(
        helperResponse: (state as FileErrorState).helperResponse,
        elevatedButtonWidget: ElevatedButtonWidget(
          title: "Refresh",
          onPressed: () {
            search();
          },
        ),
      );
    });
  }
}
