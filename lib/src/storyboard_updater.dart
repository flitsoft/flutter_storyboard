import 'package:flutter_storyboard/src/constants/git_runner_key.dart';
import 'package:flutter_storyboard/src/services/storyboard_repository.dart';
import 'package:flutter_storyboard/src/utils/runner_messenger.dart';

class StoryboardUpdater {
  Future<void> main() async {
    final baseBranch =
        const String.fromEnvironment(STORYBOARD_BASE_BRANCH_NAME);
    final featureBranch =
        const String.fromEnvironment(STORYBOARD_FEATURE_BRANCH_NAME);
    final repo = StoryboardRepository();
    final data = await repo.read(featureBranch);
    if (data == null) return;
    final dataStore = data.dataStore();
    if (dataStore == null) return;
    await repo.saveDatastore(dataStore, baseBranch);
    RunnerMessenger.sendMessage(BASE_BRANCH_UPDATED, "");
  }
}
