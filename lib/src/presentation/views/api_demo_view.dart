import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/button_state.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/src/data/controller/book_demo_controller.dart';
import 'package:mood_tracker_assessment/src/data/controller/network_stream_controller.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/buttons/outline_button.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/nav_pages_app_bar.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class ApiDemoView extends ConsumerStatefulWidget {
  const ApiDemoView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ApiDemoViewState();
}

class _ApiDemoViewState extends ConsumerState<ApiDemoView> {
  @override
  Widget build(BuildContext context) {
    final networkStatus = ref.watch(networkStreamProvider);
    final bookState = ref.watch(bookDemoControllerProvider);
    final bookCtrl = ref.read(bookDemoControllerProvider.notifier);
    return Scaffold(
      appBar: NavBarPagesAppBar(title: TextConstants.apiDemo.tr(), automaticallyImplyLeading: true),
      body: Column(
        spacing: 15,
        children: [
          networkStatus.when(
            data: (status) {
              bool isConnected = status == InternetStatus.connected;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: isConnected ? Colors.green : Colors.red,
                child: Row(
                  children: [
                    Icon(isConnected ? Icons.wifi : Icons.wifi_off, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      isConnected ? TextConstants.online.tr() : TextConstants.offline.tr(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('${TextConstants.error.tr()}: $error'),
          ),

          //
          Expanded(
            child: Column(
              spacing: 20,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Flexible(
                      child: MoodOutlineButton(
                        state: bookState.isLoading ? ButtonState.loading : ButtonState.loaded,
                        icon: Icon(Icons.download, color: AppColors.kGreen),
                        title: TextConstants.getBooks.tr(),
                        onPressed: () {
                          bookCtrl.getBooks();
                        },
                      ),
                    ),
                    Flexible(
                      child: MoodOutlineButton(
                        icon: Icon(Icons.close, color: AppColors.moodRed),
                        color: AppColors.moodRed,
                        textColor: AppColors.moodRed,
                        title: TextConstants.reset.tr(),
                        onPressed: () {
                          bookCtrl.resetBooksList();
                        },
                      ),
                    ),
                  ],
                ),
                if (bookState.bookLists.isNotEmpty)
                  MoodText.text(
                    text: TextConstants.listOfBooksGenerated.tr(),
                    context: context,
                    textStyle: context.textTheme.bodyLarge,
                  ),

                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.kGrey, width: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        bookState.bookLists.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.menu_book, size: 100, color: AppColors.kGrey),
                                  MoodText.text(
                                    text: TextConstants.noBooksFound.tr(),
                                    context: context,
                                    textStyle: context.textTheme.headlineLarge,
                                  ),
                                ],
                              ),
                            )
                            : ListView.separated(
                              separatorBuilder: (context, index) => const Divider(),
                              itemCount: bookState.bookLists.length,
                              padding: EdgeInsets.all(10),
                              itemBuilder: (context, index) {
                                final books = bookState.bookLists[index];
                                return Column(
                                  children: [
                                    MoodText.text(
                                      text: '${(books.author ?? '')} - ${books.title ?? ''}',
                                      context: context,
                                      textStyle: context.textTheme.bodyLarge,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    MoodText.text(
                                      text: books.toJson() ?? '',
                                      context: context,
                                      textStyle: context.textTheme.bodyLarge,
                                    ),
                                  ],
                                );
                              },
                            ),
                  ),
                ),
              ],
            ).padAll(20),
          ),
        ],
      ),
    );
  }
}
